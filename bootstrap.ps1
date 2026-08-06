# =============================================================
# claude-analyst-starter — bootstrap para Windows 10/11
# Uso: abre PowerShell y ejecuta:
#   irm https://raw.githubusercontent.com/Barku1234/claude-analyst-starter/main/bootstrap.ps1 | iex
# =============================================================

$ErrorActionPreference = "Stop"

function Write-Step($msg) {
    Write-Host ""
    Write-Host "==> $msg" -ForegroundColor Cyan
}

function Write-Ok($msg) {
    Write-Host "    OK $msg" -ForegroundColor Green
}

function Write-Warn($msg) {
    Write-Host "    !! $msg" -ForegroundColor Yellow
}

function Write-Err($msg) {
    Write-Host "    XX $msg" -ForegroundColor Red
}

Write-Host ""
Write-Host "============================================================"
Write-Host "  claude-analyst-starter - setup automatico"
Write-Host "============================================================"

# --- 1. Chequear Windows version ---
Write-Step "Chequeando version de Windows..."
$osVersion = [System.Environment]::OSVersion.Version
if ($osVersion.Major -lt 10) {
    Write-Err "Necesitas Windows 10 o 11. Vas a tener que actualizar."
    exit 1
}
$build = (Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion").CurrentBuild
Write-Ok "Windows $($osVersion.Major) build $build"

# --- 2. Chequear winget ---
Write-Step "Chequeando winget (gestor de paquetes de Windows)..."
try {
    $wingetVersion = winget --version 2>$null
    Write-Ok "winget $wingetVersion encontrado"
} catch {
    Write-Err "winget no esta instalado. Instalalo desde Microsoft Store:"
    Write-Host "  ms-windows-store://pdp/?ProductId=9NBLGGH4NNS1"
    Write-Host "  (buscar 'App Installer' de Microsoft, click Get)"
    Read-Host "Cuando lo instales, dale Enter aca para continuar"
}

# --- 3. Instalar dependencias con winget ---
Write-Step "Instalando Node.js LTS..."
winget install --id OpenJS.NodeJS.LTS -e --silent --accept-package-agreements --accept-source-agreements 2>&1 | Out-Null
Write-Ok "Node.js listo"

Write-Step "Instalando Git for Windows..."
winget install --id Git.Git -e --silent --accept-package-agreements --accept-source-agreements 2>&1 | Out-Null
Write-Ok "Git listo"

Write-Step "Instalando Python 3.12..."
winget install --id Python.Python.3.12 -e --silent --accept-package-agreements --accept-source-agreements 2>&1 | Out-Null
Write-Ok "Python listo"

Write-Step "Instalando VS Code..."
winget install --id Microsoft.VisualStudioCode -e --silent --accept-package-agreements --accept-source-agreements --override "/SILENT /mergetasks='!runcode,addcontextmenufiles,addcontextmenufolders,associatewithfiles,addtopath'" 2>&1 | Out-Null
Write-Ok "VS Code listo"

# --- 4. Refrescar PATH para esta sesion ---
Write-Step "Refrescando PATH..."
$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
Write-Ok "PATH actualizado"

# --- 5. Instalar Claude Code CLI via npm ---
Write-Step "Instalando Claude Code CLI..."
$npmPath = (Get-Command npm -ErrorAction SilentlyContinue).Source
if (-not $npmPath) {
    Write-Warn "npm no aparece todavia en el PATH. Puede que necesites cerrar y reabrir esta ventana."
    Write-Host "  Cierra PowerShell, abrilo de nuevo, y volve a correr el bootstrap."
    exit 1
}
npm install -g "@anthropic-ai/claude-code" 2>&1 | Out-Null
Write-Ok "Claude Code CLI instalado"

# --- 6. Instalar extension de VS Code ---
Write-Step "Instalando extension Claude Code en VS Code..."
$codePath = (Get-Command code -ErrorAction SilentlyContinue).Source
if ($codePath) {
    code --install-extension anthropic.claude-code 2>&1 | Out-Null
    Write-Ok "Extension instalada"
} else {
    Write-Warn "VS Code no responde todavia. La extension la vas a poder instalar despues manualmente."
}

# --- 7. Clonar el starter ---
Write-Step "Clonando el starter en Documentos..."
$targetDir = Join-Path $env:USERPROFILE "Documents\claude-analyst-starter"
if (Test-Path $targetDir) {
    Write-Warn "Ya existe $targetDir - salteando clone"
} else {
    $gitPath = (Get-Command git -ErrorAction SilentlyContinue).Source
    if (-not $gitPath) {
        Write-Warn "git no aparece todavia en el PATH. Cerra y reabri PowerShell, despues clona manual:"
        Write-Host "  cd `$env:USERPROFILE\Documents"
        Write-Host "  git clone https://github.com/Barku1234/claude-analyst-starter.git"
    } else {
        git clone https://github.com/Barku1234/claude-analyst-starter.git $targetDir 2>&1 | Out-Null
        Write-Ok "Starter clonado en $targetDir"
    }
}

# --- 8. Crear shortcut de escritorio ---
Write-Step "Creando shortcut 'Claude Analyst' en el escritorio..."
if (Test-Path $targetDir) {
    $desktopPath = [Environment]::GetFolderPath("Desktop")
    $shortcutPath = Join-Path $desktopPath "Claude Analyst.lnk"
    $wshShell = New-Object -ComObject WScript.Shell
    $shortcut = $wshShell.CreateShortcut($shortcutPath)
    $shortcut.TargetPath = "code"
    $shortcut.Arguments = "`"$targetDir`""
    $shortcut.WorkingDirectory = $targetDir
    $shortcut.IconLocation = "code.exe,0"
    $shortcut.Description = "Abrir Claude Analyst en VS Code"
    $shortcut.Save()
    Write-Ok "Shortcut creado: Desktop\Claude Analyst.lnk"
}

# --- 9. Crear alias 'cra' en PowerShell profile ---
Write-Step "Registrando alias 'cra' en tu PowerShell..."
if (-not (Test-Path $PROFILE)) {
    New-Item -Path $PROFILE -Type File -Force | Out-Null
}
$aliasBlock = @"

# --- claude-analyst-starter (auto-generado, no editar) ---
function cra {
    <#
    .SYNOPSIS
      Abre Claude Analyst en VS Code. Tipeale /start-session adentro.
    #>
    code "`$env:USERPROFILE\Documents\claude-analyst-starter"
}
Set-Alias -Name cre -Value cra -Description "Claude Research Analyst (alias)"
# --- fin ---
"@
$profileContent = Get-Content $PROFILE -Raw -ErrorAction SilentlyContinue
if ($profileContent -notlike "*claude-analyst-starter*") {
    Add-Content -Path $PROFILE -Value $aliasBlock
    Write-Ok "Alias 'cra' agregado al perfil PowerShell"
} else {
    Write-Ok "Alias ya estaba registrado"
}

# --- 10. Abrir VS Code ---
if ($codePath -and (Test-Path $targetDir)) {
    Write-Step "Abriendo VS Code..."
    Start-Process code -ArgumentList $targetDir
    Write-Ok "VS Code abriendo"
}

# --- Mensaje final ---
Write-Host ""
Write-Host "============================================================" -ForegroundColor Green
Write-Host "  LISTO. Todo instalado." -ForegroundColor Green
Write-Host "============================================================" -ForegroundColor Green
Write-Host ""
Write-Host "PROXIMOS PASOS (en VS Code que se acaba de abrir):"
Write-Host ""
Write-Host "  1. Click en el icono naranja de Claude Code a la derecha"
Write-Host "     (si no lo ves, presiona Ctrl+Shift+P y busca 'Claude Code')"
Write-Host ""
Write-Host "  2. Click 'Login' - te abre el browser para loguearte con Anthropic"
Write-Host ""
Write-Host "  3. Cuando volves a VS Code, en el panel de Claude escribi:"
Write-Host "     /onboard-analyst" -ForegroundColor Yellow
Write-Host ""
Write-Host "     Claude te va a hacer 4-5 preguntas y termina de configurarse solo."
Write-Host ""
Write-Host "============================================================"
Write-Host ""
Write-Host "PARA ABRIR MAS ADELANTE (cualquiera de las 3):" -ForegroundColor Cyan
Write-Host ""
Write-Host "  A) Doble-click en 'Claude Analyst' en tu escritorio"
Write-Host ""
Write-Host "  B) Abrir PowerShell y tipear:  cra"
Write-Host ""
Write-Host "  C) VS Code -> Ctrl+Shift+P -> escribir 'Claude Analyst'"
Write-Host ""
Write-Host "Y adentro, siempre arrancar con:  /start-session" -ForegroundColor Yellow
Write-Host "Y al terminar el dia:             /end-session" -ForegroundColor Yellow
Write-Host ""
Write-Host "============================================================"
