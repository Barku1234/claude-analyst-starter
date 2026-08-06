# Instalación paso a paso — Windows 10/11

Esta guía asume que **nunca abriste una terminal en tu vida**. Tarda ~15 min.

Si algo se rompe, saltá al final: [Troubleshooting](#troubleshooting).

---

## Antes de empezar

Necesitás dos cuentas (5 min desde el celular si querés):

1. **Cuenta Anthropic** con billing → https://console.anthropic.com
   - Si vas a usar Claude Code todos los días, comprá el plan **Claude Pro/Max** ($20-100 USD/mes, uso ilimitado razonable). Es más barato que pagar por token para uso pesado.
2. **Cuenta GitHub** (gratis) → https://github.com

Anotá tu **email y password de Anthropic** en algún lado, los vas a pegar durante el login.

---

## Opción A — Automático (recomendado, 1 comando)

### Paso 1 — Abrir PowerShell
- Presioná la tecla **Windows** de tu teclado.
- Empezá a escribir `powershell`.
- Aparece "Windows PowerShell" → click.
- Se abre una ventana negra con texto azul. Eso es una terminal.

### Paso 2 — Pegar el comando
Copiá esta línea entera y pegala en la ventana negra (click derecho pega en PowerShell), después Enter:

```powershell
irm https://raw.githubusercontent.com/Barku1234/claude-analyst-starter/main/bootstrap.ps1 | iex
```

### Paso 3 — Esperar (~8 min)
Vas a ver mensajes tipo `==> Node.js...` en varios colores. Al final aparece un **RESUMEN** con cada componente en `[OK]` verde o `[X]` rojo, y el script te pide **Enter** para cerrar la ventana (nunca se cierra sola).

```
============================================================
  LISTO. Todo instalado.
============================================================
  RESUMEN:
   [OK] Node.js  instalado v22...
   [OK] Git  ya estaba
   ...
```

Y **VS Code se abre solo** apuntando al starter.

- Si hay algo en **rojo**, el mismo resumen te dice qué hacer (casi siempre: cerrar la ventana, abrir PowerShell de nuevo y volver a pegar el mismo comando — retoma solo lo que falta).
- Todo lo que pasó queda logueado en **`claude-setup-log.txt` en tu Escritorio** — si pedís ayuda, mandá ese archivo.

### Paso 4 — Login en Claude
En VS Code, mirá el **borde derecho**. Debería aparecer un icono naranja (Claude Code). Si no lo ves:
- Presioná `Ctrl+Shift+P` → escribí `Claude Code` → Enter → aparece el panel.

En ese panel, click **Login**. Se abre tu browser:
- Login con Anthropic (mismo email y password de la cuenta).
- Copiá el token que aparece.
- Volvé a VS Code → pegá el token → Enter.

Deberías ver "Ready" en el panel.

### Paso 5 — Onboarding
En el chat de Claude escribí:

```
/onboard-analyst
```

Claude te va a hacer 4-5 preguntas (nombre, banco, industria, etc.), configurar tu memoria y verificar que todo funcione. Tarda 3 min.

**Listo.** Ya podés probar:

```
/company-profile Apple
```

Y ver cómo genera un 1-pager en `research/apple-profile.md`.

---

## Opción B — Manual (si el bootstrap falla)

Instalá **en este orden**, cada uno con su installer .exe oficial. Todos son click-next-next.

### 1. Node.js LTS
- Bajar → https://nodejs.org (botón verde "LTS")
- Ejecutar el `.msi` → next-next-next → **marcá "Add to PATH"**.

### 2. Git for Windows
- Bajar → https://git-scm.com/download/win
- Ejecutar el `.exe` → todos defaults, next-next-next.

### 3. Python 3.12
- Bajar → https://python.org/downloads
- Ejecutar el `.exe` → **⚠️ en la primera pantalla marcá "Add Python to PATH"** (fácil de olvidar).

### 4. VS Code
- Bajar → https://code.visualstudio.com (botón azul "Download for Windows")
- Ejecutar el `.exe` → seleccioná **User Installer**. Marcá todas las casillas de "Additional tasks" (integración con Explorer, PATH, etc.).

### 5. Extensión Claude Code
- Abrí VS Code → botón de bloques a la izquierda (Extensions) → buscá "Claude Code" → instalá el de **Anthropic**.

### 6. Claude Code CLI y clonar starter
- Abrí PowerShell → pegá **todo esto de una** y Enter:

```powershell
npm install -g @anthropic-ai/claude-code
cd $env:USERPROFILE\Documents
git clone https://github.com/Barku1234/claude-analyst-starter.git
code claude-analyst-starter
```

- Cuando VS Code abre → seguí desde el **Paso 4** de la Opción A (login + onboarding).

---

## Troubleshooting

### "La ventana de PowerShell se cerró sola"
Era un bug de la primera versión del bootstrap (arreglado el 2026-08-06). Volvé a pegar el mismo comando: la versión nueva **nunca cierra la ventana sola**, muestra un resumen `[OK]`/`[X]` al final y deja un log `claude-setup-log.txt` en tu Escritorio. Es idempotente: lo que ya se instaló lo saltea.

### "Algo salió en [X] rojo en el resumen"
1. Cerrá la ventana, abrí PowerShell **de nuevo** (como admin) y volvé a pegar el mismo comando — muchos fallos son solo que la ventana vieja no veía los programas recién instalados.
2. Si vuelve a fallar: mandá una foto del resumen + el archivo **`claude-setup-log.txt`** de tu Escritorio a quien te pasó este repo.

### "winget no está instalado"
Instalalo desde Microsoft Store: buscá **"App Installer"** de Microsoft → Get. Después volvé a correr el bootstrap.

### "El script no puede ejecutarse porque la ejecución de scripts está deshabilitada"
Windows bloquea scripts de PowerShell por default. Corré esto en PowerShell **como admin** una vez:
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```
Luego volvé a intentar.

### "npm no se reconoce como comando"
Después de instalar Node.js hay que **cerrar y abrir de nuevo** PowerShell para que el PATH se actualice. Si aún así falla, reiniciá Windows.

### "No aparece el panel Claude Code en VS Code"
`Ctrl+Shift+P` → escribí `Claude Code: Open Panel` → Enter. Si no aparece la opción, la extensión no está instalada: hacé la Opción B paso 5.

### "El login de Claude no vuelve"
Cerrá completamente VS Code y el browser, abrilos de nuevo, retry.

### "No entiendo qué hacer"
Escribile a quien te pasó este repo y compartí una screenshot de lo que estás viendo.

---

## Cómo verificar que quedó todo bien

En el chat de Claude, tipeá:
```
/onboard-analyst verify
```

Debería responder con un checklist ✓/✗ de cada componente:
- ✓ Node.js instalado
- ✓ Python instalado
- ✓ Git instalado
- ✓ Memoria vacía inicializada
- ✓ Skills cargadas
- ✓ MCP Playwright disponible

Si todo verde, listo para trabajar.
