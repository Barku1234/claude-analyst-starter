# Cómo publicar este starter (para vos, el maintainer)

Este doc es solo para vos, el que armó el starter. El amigo NO lo lee.

## Publicar por primera vez

Desde el directorio del starter:

```bash
# 1. Init git
git init
git add .
git commit -m "chore: initial starter for financial analysts"

# 2. Crear repo público en GitHub (con GitHub CLI)
gh repo create claude-analyst-starter --public --source=. --push --description "Claude Code starter for investment banking / equity research analysts"

# Alternativa si no tenés gh:
# - Crear repo manualmente en https://github.com/new (público, sin README/gitignore)
# - Después:
#   git remote add origin https://github.com/Barku1234/claude-analyst-starter.git
#   git branch -M main
#   git push -u origin main
```

## Verificar que el bootstrap funciona

Después de push, el `bootstrap.ps1` es accesible en:

```
https://raw.githubusercontent.com/Barku1234/claude-analyst-starter/main/bootstrap.ps1
```

Chequealo abriendo esa URL en el browser — debería mostrar el script en texto plano.

## Distribuir al amigo

Le mandás **este único mensaje** (por WhatsApp, mail, lo que sea):

```
Hola [nombre], armé un setup de Claude Code hecho a medida para vos
(research financiero, modelos Excel, decks HTML) que se instala solo.

En tu PC Windows, hacé:

1. Abrí PowerShell (tecla Windows → escribí "powershell" → click)
2. Pegá esto entero y Enter:

   irm https://raw.githubusercontent.com/Barku1234/claude-analyst-starter/main/bootstrap.ps1 | iex

3. Esperá 8 min. Cuando termine, VS Code se abre solo.
4. En VS Code, panel Claude a la derecha → Login → tipeá /onboard-analyst.

Si algo se rompe, mandame screenshot. Todo el detalle en:
https://github.com/Barku1234/claude-analyst-starter#instalación-en-windows
```

## Iterar sobre el starter

Cuando quieras mejorar algo:

```bash
# En tu máquina
cd claude-analyst-starter  # o donde lo tengas
# editá archivos...
git add .
git commit -m "improve /ic-memo skill for buy-side deals"
git push
```

**El amigo actualiza así** (en su VS Code adentro del starter):

```bash
git pull
```

Sus archivos en `research/`, `models/`, `decks/`, `memory/` NO se tocan (los ignora `.gitignore`). Solo se actualizan los `.claude/` y docs.

## Roadmap / TODOs futuros

Cosas que podés agregar cuando la usen:

- [ ] Hook `PostToolUse` para auto-format Excel outputs
- [ ] MCP para SEC EDGAR (research SEC filings faster)
- [ ] MCP para Bloomberg (si algún día abren API)
- [ ] Skill custom para el brandbook específico del banco del amigo (colors, fonts)
- [ ] Slash command `/pitch-competitor-comps` para pitches recurrentes
- [ ] Integración con OneDrive / SharePoint para que outputs vayan directo al drive del banco
- [ ] Localización a español si tenés amigos en LatAm banks

## Métricas de uso (opcional)

Si querés medir uso sin ser invasivo:

- Preguntale al amigo de vez en cuando "¿qué comando usás más?"
- Mirá los issues/PRs que abre en el repo (si lo hace)
- Analytics de GitHub (traffic, clones)

No pongas telemetría automática — es un starter privado entre vos y él, no un producto.
