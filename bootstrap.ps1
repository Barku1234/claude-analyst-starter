# =============================================================
# claude-analyst-starter -- bootstrap para Windows 10/11  (v2)
# Uso: abre PowerShell y ejecuta:
#   irm https://raw.githubusercontent.com/Barku1234/claude-analyst-starter/main/bootstrap.ps1 | iex
#
# v2 (2026-08-06) -- fixes del primer test real:
#  - La ventana NUNCA se cierra sola. (v1 usaba `exit`, y corriendo
#    via irm|iex eso mata el proceso entero de PowerShell.)
#  - Log completo de cada paso en el Escritorio: claude-setup-log.txt
#  - Resumen final [OK]/[X] por componente + que hacer con lo rojo.
#  - Compatible Windows PowerShell 5.1: los comandos nativos
#    (winget/npm/git/code) corren sin que su stderr se convierta en
#    error fatal (gotcha clasico de 5.1 con 2>&1 + EAP Stop).
#  - Idempotente de verdad: saltea lo que ya esta instalado.
#  - Shortcut con path absoluto a Code.exe (v1 lo creaba roto).
#  - Fallback sin git: baja el starter como ZIP.
# =============================================================

# "Continue": un error no aborta todo; cada paso verifica su resultado
# explicitamente y lo reporta en el resumen final.
$ErrorActionPreference = "Continue"

function Write-Step($msg) { Write-Host ""; Write-Host "==> $msg" -ForegroundColor Cyan }
function Write-Ok($msg)   { Write-Host "    OK $msg" -ForegroundColor Green }
function Write-Warn($msg) { Write-Host "    !! $msg" -ForegroundColor Yellow }
function Write-Err($msg)  { Write-Host "    XX $msg" -ForegroundColor Red }
function Write-Hint($msg) { Write-Host "    ($msg)" -ForegroundColor DarkGray }

$script:LogFile = Join-Path ([Environment]::GetFolderPath("Desktop")) "claude-setup-log.txt"
$script:Results = @()
# 0 = instalado OK / -1978335189 = "ya estaba, sin upgrade aplicable" /
# -1978334963 = "ya estaba instalado" (INSTALL_ALREADY_INSTALLED)
$script:WingetOkCodes = @(0, -1978335189, -1978334963)

function Log($text) {
    try { Add-Content -Path $script:LogFile -Value $text -Encoding UTF8 -ErrorAction SilentlyContinue } catch { }
}

function Add-Result($name, $ok, $note) {
    $script:Results += [pscustomobject]@{ Name = $name; Ok = $ok; Note = $note }
}

# Ejecuta un comando nativo capturando stdout+stderr como TEXTO (nunca
# como errores fatales de PowerShell) y loguea todo con su exit code.
function Invoke-Native([string]$Label, [scriptblock]$Command) {
    $prev = $ErrorActionPreference
    $ErrorActionPreference = "Continue"
    $global:LASTEXITCODE = 0
    $output = ""
    try {
        $output = (& $Command 2>&1 | ForEach-Object { "$_" }) -join "`r`n"
    } catch {
        $output = $output + "`r`nEXCEPCION: " + $_.Exception.Message
        if ($global:LASTEXITCODE -eq 0) { $global:LASTEXITCODE = 1 }
    }
    $code = $global:LASTEXITCODE
    $ErrorActionPreference = $prev
    Log ""
    Log "----- $Label (exit code: $code) -----"
    Log $output
    return [pscustomobject]@{ ExitCode = $code; Output = $output }
}

function Get-Tool($name) {
    $cmd = Get-Command $name -ErrorAction SilentlyContinue
    if ($cmd) { return $cmd.Source } else { return $null }
}

function Update-SessionPath {
    $env:Path = [Environment]::GetEnvironmentVariable("Path", "Machine") + ";" +
                [Environment]::GetEnvironmentVariable("Path", "User")
}

function Get-CodeExe {
    $candidates = @(
        (Join-Path $env:LOCALAPPDATA "Programs\Microsoft VS Code\Code.exe"),
        (Join-Path $env:ProgramFiles "Microsoft VS Code\Code.exe"),
        (Join-Path $env:LOCALAPPDATA "Programs\Microsoft VS Code Insiders\Code - Insiders.exe")
    )
    foreach ($p in $candidates) { if (Test-Path $p) { return $p } }
    # Busqueda por registro: cubre instalaciones en rutas no estandar
    $regRoots = @(
        "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall",
        "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall",
        "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall"
    )
    foreach ($root in $regRoots) {
        $keys = Get-ChildItem $root -ErrorAction SilentlyContinue
        foreach ($k in $keys) {
            $props = Get-ItemProperty $k.PSPath -ErrorAction SilentlyContinue
            if ($props.DisplayName -like "Microsoft Visual Studio Code*" -and $props.InstallLocation) {
                foreach ($exe in @("Code.exe", "Code - Insiders.exe")) {
                    $full = Join-Path $props.InstallLocation $exe
                    if (Test-Path $full) { return $full }
                }
            }
        }
    }
    return (Get-Tool "code")   # fallback: el shim code.cmd (tambien es path absoluto)
}

function Show-OutputTail($result) {
    $lines = $result.Output -split "`r?`n" | Where-Object { $_ -ne "" } | Select-Object -Last 6
    foreach ($l in $lines) { Write-Host "      | $l" -ForegroundColor DarkGray }
}

# Traduce exit codes conocidos de winget a un arreglo concreto
function Get-WingetHint($code) {
    switch ($code) {
        -1978335217 { return "fuentes de winget rotas/vacias. Arreglo: correr  winget source reset --force  y despues  winget source update  y re-correr esto" }
        -1978335212 { return "winget sin fuentes configuradas. Arreglo: correr  winget source reset --force  y despues  winget source update  y re-correr esto" }
        -1978335224 { return "la descarga fallo (internet/proxy). Reintentar; si sigue, la red puede estar bloqueando" }
        -1978335215 { return "hash del instalador no coincide. Arreglo: winget source update  y reintentar" }
        -1978334964 { return "el permiso de Windows (UAC) se cancelo o vencio sin responder. Reintentar y darle SI apenas aparezca la ventanita" }
        -1978334961 { return "instalacion bloqueada por politica de la maquina (IT). Instalar manual o hablar con sistemas" }
        -1978334967 { return "Windows necesita REINICIAR para terminar la instalacion. Reiniciar y re-correr esto" }
        -1978334966 { return "Windows necesita REINICIAR para poder instalar. Reiniciar y re-correr esto" }
    }
    return ""
}

function Invoke-ClaudeAnalystBootstrap {

    try { $Host.UI.RawUI.WindowTitle = "Claude Analyst - setup" } catch { }

    Write-Host ""
    Write-Host "============================================================"
    Write-Host "  claude-analyst-starter - setup automatico (v2)"
    Write-Host "============================================================"
    Write-Host "  Log detallado en: $script:LogFile"
    Write-Host "  Esta ventana NO se cierra sola: al final pide Enter."

    Set-Content -Path $script:LogFile -Value "claude-analyst-starter bootstrap v2" -Encoding UTF8
    Log ("Fecha: " + (Get-Date))
    Log ("Usuario: " + $env:USERNAME + " | Maquina: " + $env:COMPUTERNAME)
    Log ("PowerShell: " + $PSVersionTable.PSVersion)

    # --- 1. Windows + permisos ---
    Write-Step "Chequeando Windows..."
    $osVersion = [System.Environment]::OSVersion.Version
    if ($osVersion.Major -lt 10) {
        Write-Err "Necesitas Windows 10 u 11. Vas a tener que actualizar."
        Add-Result "Windows" $false "version vieja ($osVersion)"
        return
    }
    $build = (Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion" -ErrorAction SilentlyContinue).CurrentBuild
    Write-Ok "Windows $($osVersion.Major) build $build"
    Log ("Windows build: " + $build)

    $identity = [Security.Principal.WindowsIdentity]::GetCurrent()
    $isAdmin = (New-Object Security.Principal.WindowsPrincipal($identity)).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
    Log ("Admin: " + $isAdmin)
    if (-not $isAdmin) {
        Write-Warn "No estas como Administrador. Los instaladores pueden pedir permiso (UAC): dale que si."
    } else {
        Write-Warn "OJO: si Windows te pidio OTRO usuario y clave para abrir este PowerShell admin,"
        Write-Warn "todo va a caer en el perfil de ESE usuario, no en el tuyo. En ese caso: cerra esto"
        Write-Warn "y corre el mismo comando en un PowerShell NORMAL (sin admin)."
    }

    # --- 2. winget ---
    Write-Step "Chequeando winget (gestor de paquetes de Windows)..."
    $hasWinget = [bool](Get-Tool "winget")
    if ($hasWinget) {
        $wv = Invoke-Native "winget --version" { winget --version }
        Write-Ok ("winget " + $wv.Output.Trim() + " encontrado")
    } else {
        Write-Warn "winget no esta instalado. Se saltean las instalaciones automaticas."
        Write-Warn "Instalalo desde Microsoft Store (buscar 'App Installer' de Microsoft) y re-corre esto."
        Add-Result "winget" $false "instalar 'App Installer' desde Microsoft Store y re-correr"
    }

    # --- 3. Node.js ---
    Write-Step "Node.js..."
    if (Get-Tool "node") {
        $v = ""; try { $v = & node -v 2>$null } catch { }
        Write-Ok "ya estaba ($v)"
        Add-Result "Node.js" $true "ya estaba $v"
    } elseif ($hasWinget) {
        Write-Hint "puede tardar 1-3 min, el detalle va al log"
        $r = Invoke-Native "winget install Node.js LTS" { winget install --id OpenJS.NodeJS.LTS -e --silent --accept-package-agreements --accept-source-agreements }
        Update-SessionPath
        if (Get-Tool "node") {
            $v = ""; try { $v = & node -v 2>$null } catch { }
            Write-Ok "instalado ($v)"
            Add-Result "Node.js" $true "instalado $v"
        } elseif ($script:WingetOkCodes -contains $r.ExitCode) {
            Write-Warn "instalado, pero esta ventana todavia no lo ve. Se arregla reabriendo PowerShell."
            Add-Result "Node.js" $true "instalado - reabrir PowerShell para usarlo"
        } else {
            Write-Err "fallo la instalacion (exit $($r.ExitCode)). Ultimas lineas:"
            Show-OutputTail $r
            $hint = Get-WingetHint $r.ExitCode
            if ($hint) { Write-Warn $hint }
            Add-Result "Node.js" $false ("winget fallo (exit $($r.ExitCode)) - " + $(if ($hint) { $hint } else { "ver log" }))
        }
    } else {
        Add-Result "Node.js" $false "sin winget - instalar manual desde nodejs.org"
    }

    # --- 4. Git ---
    Write-Step "Git..."
    if (Get-Tool "git") {
        $v = ""; try { $v = & git --version 2>$null } catch { }
        Write-Ok "ya estaba ($v)"
        Add-Result "Git" $true "ya estaba"
    } elseif ($hasWinget) {
        Write-Hint "puede tardar 1-3 min, el detalle va al log"
        $r = Invoke-Native "winget install Git" { winget install --id Git.Git -e --silent --accept-package-agreements --accept-source-agreements }
        Update-SessionPath
        if (Get-Tool "git") {
            Write-Ok "instalado"
            Add-Result "Git" $true "instalado"
        } elseif ($script:WingetOkCodes -contains $r.ExitCode) {
            Write-Warn "instalado, pero esta ventana todavia no lo ve. Se arregla reabriendo PowerShell."
            Add-Result "Git" $true "instalado - reabrir PowerShell para usarlo"
        } else {
            Write-Err "fallo la instalacion (exit $($r.ExitCode)). Ultimas lineas:"
            Show-OutputTail $r
            $hint = Get-WingetHint $r.ExitCode
            if ($hint) { Write-Warn $hint }
            Add-Result "Git" $false ("winget fallo (exit $($r.ExitCode)) - " + $(if ($hint) { $hint } else { "ver log" }))
        }
    } else {
        Add-Result "Git" $false "sin winget - instalar manual desde git-scm.com"
    }

    # --- 5. Python (no bloquea el arranque: lo usan los skills de Excel) ---
    Write-Step "Python..."
    $pySrc = Get-Tool "python"
    # Windows trae un python.exe FALSO en WindowsApps que solo abre la Store
    $pyReal = ($pySrc -and ($pySrc -notmatch "WindowsApps"))
    if ($pyReal) {
        $v = ""; try { $v = & python --version 2>$null } catch { }
        Write-Ok "ya estaba ($v)"
        Add-Result "Python" $true "ya estaba"
    } elseif ($hasWinget) {
        Write-Hint "puede tardar 1-3 min, el detalle va al log"
        $r = Invoke-Native "winget install Python 3.12" { winget install --id Python.Python.3.12 -e --silent --accept-package-agreements --accept-source-agreements }
        Update-SessionPath
        $pySrc = Get-Tool "python"
        if ($pySrc -and ($pySrc -notmatch "WindowsApps")) {
            Write-Ok "instalado"
            Add-Result "Python" $true "instalado"
        } elseif ($script:WingetOkCodes -contains $r.ExitCode) {
            Write-Warn "instalado, visible al reabrir PowerShell."
            Add-Result "Python" $true "instalado - reabrir PowerShell para usarlo"
        } else {
            Write-Warn "no se pudo instalar (exit $($r.ExitCode)). NO bloquea: podes arrancar igual."
            Show-OutputTail $r
            $hint = Get-WingetHint $r.ExitCode
            if ($hint) { Write-Warn $hint }
            Add-Result "Python" $false "fallo (no bloquea) - instalar despues desde python.org"
        }
    } else {
        Add-Result "Python" $false "sin winget (no bloquea) - instalar manual desde python.org"
    }

    # --- 6. VS Code ---
    Write-Step "VS Code..."
    $codeExe = Get-CodeExe
    if ($codeExe) {
        Write-Ok "ya estaba"
        Add-Result "VS Code" $true "ya estaba"
    } elseif ($hasWinget) {
        Write-Hint "puede tardar 1-3 min, el detalle va al log"
        $r = Invoke-Native "winget install VS Code" { winget install --id Microsoft.VisualStudioCode -e --silent --accept-package-agreements --accept-source-agreements --override '/VERYSILENT /MERGETASKS="!runcode,addcontextmenufiles,addcontextmenufolders,associatewithfiles,addtopath"' }
        Update-SessionPath
        $codeExe = Get-CodeExe
        if ($codeExe) {
            Write-Ok "instalado"
            Add-Result "VS Code" $true "instalado"
        } else {
            Write-Err "fallo la instalacion (exit $($r.ExitCode)). Ultimas lineas:"
            Show-OutputTail $r
            $hint = Get-WingetHint $r.ExitCode
            if ($hint) { Write-Warn $hint }
            Add-Result "VS Code" $false ("winget fallo (exit $($r.ExitCode)) - " + $(if ($hint) { $hint } else { "ver log" }))
        }
    } else {
        Add-Result "VS Code" $false "sin winget - instalar manual desde code.visualstudio.com"
    }

    # --- 7. Claude Code CLI (opcional: la extension de VS Code trae Claude integrado) ---
    Write-Step "Claude Code CLI..."
    if (Get-Tool "claude") {
        Write-Ok "ya estaba"
        Add-Result "Claude CLI" $true "ya estaba"
    } else {
        $npm = Get-Tool "npm"
        if (-not $npm) {
            Write-Warn "npm no esta visible en esta ventana; este paso queda pendiente."
            Write-Warn "NO bloquea: la extension de VS Code trae Claude integrado igual."
            Add-Result "Claude CLI" $false "pendiente: reabrir PowerShell y re-correr el bootstrap (no bloquea VS Code)"
        } else {
            Write-Hint "puede tardar 1-2 min, el detalle va al log"
            $r = Invoke-Native "npm install -g @anthropic-ai/claude-code" { npm install -g "@anthropic-ai/claude-code" }
            Update-SessionPath
            if ((Get-Tool "claude") -or (Test-Path (Join-Path $env:APPDATA "npm\claude.cmd"))) {
                Write-Ok "instalado"
                Add-Result "Claude CLI" $true "instalado"
            } elseif ($r.ExitCode -eq 0) {
                Write-Ok "instalado (visible al reabrir PowerShell)"
                Add-Result "Claude CLI" $true "instalado - reabrir PowerShell para usarlo"
            } else {
                Write-Err "npm fallo (exit $($r.ExitCode)). Ultimas lineas:"
                Show-OutputTail $r
                Add-Result "Claude CLI" $false "npm fallo (no bloquea VS Code) - ver log"
            }
        }
    }

    # --- 8. Extension Claude Code en VS Code ---
    Write-Step "Extension Claude Code en VS Code..."
    $codeCli = Get-Tool "code"
    if (-not $codeCli -and $codeExe -and ($codeExe -like "*Code.exe")) {
        $maybe = Join-Path (Split-Path $codeExe) "bin\code.cmd"
        if (Test-Path $maybe) { $codeCli = $maybe }
    }
    if ($codeCli) {
        $list = Invoke-Native "code --list-extensions" { & $codeCli --list-extensions }.GetNewClosure()
        if ($list.Output -match "anthropic.claude-code") {
            Write-Ok "ya estaba"
            Add-Result "Extension VS Code" $true "ya estaba"
        } else {
            $r = Invoke-Native "code --install-extension" { & $codeCli --install-extension anthropic.claude-code }.GetNewClosure()
            if ($r.ExitCode -eq 0) {
                Write-Ok "instalada"
                Add-Result "Extension VS Code" $true "instalada"
            } else {
                Write-Warn "no se pudo instalar sola. Se instala a mano: VS Code > Extensions > buscar 'Claude Code'."
                Show-OutputTail $r
                Add-Result "Extension VS Code" $false "instalar a mano desde Extensions"
            }
        }
    } else {
        Add-Result "Extension VS Code" $false "VS Code no encontrado - instalar la extension a mano"
    }

    # --- 9. Bajar el starter ---
    Write-Step "Descargando el starter..."
    $targetDir = Join-Path $env:USERPROFILE "Documents\claude-analyst-starter"
    if (Test-Path (Join-Path $targetDir "README.md")) {
        Write-Ok "ya estaba en $targetDir"
        Add-Result "Starter (carpeta)" $true "ya estaba"
    } else {
        if (Test-Path $targetDir) {
            # quedo una carpeta rota de un intento anterior: apartarla
            $backup = $targetDir + "-roto-" + (Get-Date -Format "yyyyMMdd-HHmmss")
            Move-Item $targetDir $backup -ErrorAction SilentlyContinue
            Log "Carpeta previa incompleta movida a: $backup"
        }
        $cloned = $false
        if (Get-Tool "git") {
            $r = Invoke-Native "git clone" { git clone https://github.com/Barku1234/claude-analyst-starter.git $targetDir }.GetNewClosure()
            if (Test-Path (Join-Path $targetDir "README.md")) {
                $cloned = $true
            } else {
                Write-Warn "git clone no completo (exit $($r.ExitCode)); pruebo bajar el ZIP..."
                Show-OutputTail $r
            }
        }
        if (-not $cloned) {
            try {
                [Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor [Net.SecurityProtocolType]::Tls12
                $prevProgress = $ProgressPreference
                $ProgressPreference = "SilentlyContinue"
                $zip = Join-Path $env:TEMP "claude-analyst-starter.zip"
                Invoke-WebRequest -Uri "https://github.com/Barku1234/claude-analyst-starter/archive/refs/heads/main.zip" -OutFile $zip -UseBasicParsing
                $extract = Join-Path $env:TEMP ("cas-zip-" + (Get-Date -Format "HHmmss"))
                Expand-Archive -Path $zip -DestinationPath $extract -Force
                Move-Item (Join-Path $extract "claude-analyst-starter-main") $targetDir
                Remove-Item $zip -ErrorAction SilentlyContinue
                $ProgressPreference = $prevProgress
                $cloned = $true
                Log "Starter bajado via ZIP (sin historial git)"
            } catch {
                Log ("Descarga ZIP fallo: " + $_.Exception.Message)
            }
        }
        if ($cloned) {
            Write-Ok "starter en $targetDir"
            Add-Result "Starter (carpeta)" $true "descargado"
        } else {
            Write-Err "no pude bajar el starter (ni git ni ZIP). Revisa internet/proxy corporativo."
            Add-Result "Starter (carpeta)" $false "descarga fallo - ver log"
        }
    }

    # --- 10. Shortcut de escritorio ---
    Write-Step "Shortcut 'Claude Analyst' en el escritorio..."
    if ((Test-Path $targetDir) -and $codeExe) {
        try {
            $desktopPath = [Environment]::GetFolderPath("Desktop")
            $shortcutPath = Join-Path $desktopPath "Claude Analyst.lnk"
            $wshShell = New-Object -ComObject WScript.Shell
            $shortcut = $wshShell.CreateShortcut($shortcutPath)
            $shortcut.TargetPath = $codeExe          # v1 ponia "code" relativo -> shortcut roto
            $shortcut.Arguments = '"' + $targetDir + '"'
            $shortcut.WorkingDirectory = $targetDir
            $shortcut.IconLocation = "$codeExe,0"
            $shortcut.Description = "Abrir Claude Analyst en VS Code"
            $shortcut.Save()
            Write-Ok "creado: Desktop\Claude Analyst.lnk"
            Add-Result "Shortcut escritorio" $true "creado"
        } catch {
            Write-Warn ("no se pudo crear: " + $_.Exception.Message)
            Add-Result "Shortcut escritorio" $false "fallo - abrir con el alias: cra"
        }
    } else {
        Add-Result "Shortcut escritorio" $false "falta la carpeta o VS Code"
    }

    # --- 11. Alias 'cra' en el perfil de PowerShell ---
    Write-Step "Alias 'cra' en PowerShell..."
    try {
        if (-not (Test-Path $PROFILE)) { New-Item -Path $PROFILE -Type File -Force | Out-Null }
        $profileContent = Get-Content $PROFILE -Raw -ErrorAction SilentlyContinue
        if ($profileContent -notlike "*claude-analyst-starter*") {
            $aliasBlock = @'

# --- claude-analyst-starter (auto-generado, no editar) ---
function cra {
    code "$env:USERPROFILE\Documents\claude-analyst-starter"
}
Set-Alias -Name cre -Value cra
# --- fin ---
'@
            Add-Content -Path $PROFILE -Value $aliasBlock
            Write-Ok "agregado (en cualquier PowerShell nuevo: tipear cra)"
        } else {
            Write-Ok "ya estaba"
        }
        Add-Result "Alias cra" $true ""
    } catch {
        Write-Warn ("no se pudo: " + $_.Exception.Message)
        Add-Result "Alias cra" $false "fallo (no bloquea)"
    }

    # --- 12. Abrir VS Code ---
    if ($codeExe -and (Test-Path (Join-Path $targetDir "README.md"))) {
        Write-Step "Abriendo VS Code..."
        try {
            Start-Process -FilePath $codeExe -ArgumentList ('"' + $targetDir + '"')
            Write-Ok "abriendo"
        } catch {
            Write-Warn "no abrio solo - usa el shortcut 'Claude Analyst' del escritorio"
        }
    }

    # --- Resumen final ---
    $failed = @($script:Results | Where-Object { -not $_.Ok })
    Write-Host ""
    Write-Host "============================================================" -ForegroundColor $(if ($failed.Count -eq 0) { "Green" } else { "Yellow" })
    if ($failed.Count -eq 0) {
        Write-Host "  LISTO. Todo instalado." -ForegroundColor Green
    } else {
        Write-Host "  TERMINO, pero con $($failed.Count) pendiente(s)." -ForegroundColor Yellow
    }
    Write-Host "============================================================" -ForegroundColor $(if ($failed.Count -eq 0) { "Green" } else { "Yellow" })
    Write-Host ""
    Write-Host "  RESUMEN:"
    foreach ($item in $script:Results) {
        if ($item.Ok) {
            Write-Host ("   [OK] " + $item.Name + "  " + $item.Note) -ForegroundColor Green
        } else {
            Write-Host ("   [X]  " + $item.Name + "  -> " + $item.Note) -ForegroundColor Red
        }
        Log (("RESUMEN " + $(if ($item.Ok) { "[OK] " } else { "[X]  " }) + $item.Name + " - " + $item.Note))
    }
    if ($failed.Count -gt 0) {
        Write-Host ""
        Write-Host "  Que hacer con lo rojo:" -ForegroundColor Yellow
        Write-Host "   1. Cerra esta ventana, abri un PowerShell NUEVO (normal, sin admin)"
        Write-Host "      y volve a pegar el mismo comando: retoma solo lo que falta."
        Write-Host "   2. Si vuelve a fallar: manda una foto de este resumen +"
        Write-Host "      el archivo claude-setup-log.txt que quedo en tu Escritorio."
    }

    # --- Proximos pasos ---
    Write-Host ""
    Write-Host "PROXIMOS PASOS (en VS Code):"
    Write-Host ""
    Write-Host "  1. Click en el icono de Claude Code a la derecha"
    Write-Host "     (si no lo ves: Ctrl+Shift+P y busca 'Claude Code')"
    Write-Host ""
    Write-Host "  2. Click 'Sign In' / 'Login' - te abre el browser para loguearte"
    Write-Host ""
    Write-Host "  3. De vuelta en VS Code, en el panel de Claude escribi:"
    Write-Host "     /onboard-analyst" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "PARA ABRIR MAS ADELANTE (cualquiera de las 3):" -ForegroundColor Cyan
    Write-Host "  A) Doble-click en 'Claude Analyst' en tu escritorio"
    Write-Host "  B) Abrir PowerShell y tipear:  cra"
    Write-Host "  C) VS Code -> File -> Open Recent"
    Write-Host ""
    Write-Host "Y adentro, siempre arrancar con:  /start-session" -ForegroundColor Yellow
    Write-Host "Y al terminar el dia:             /end-session" -ForegroundColor Yellow
}

try {
    Invoke-ClaudeAnalystBootstrap
} catch {
    Write-Host ""
    Write-Err ("Error inesperado: " + $_.Exception.Message)
    Write-Err $_.ScriptStackTrace
    Log ("FATAL: " + $_.ToString())
    Log $_.ScriptStackTrace
    Write-Host ""
    Write-Host "  Manda una foto de este error + el archivo claude-setup-log.txt del Escritorio." -ForegroundColor Yellow
}
Write-Host ""
Read-Host "Presiona Enter para cerrar esta ventana"
