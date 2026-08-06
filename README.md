# claude-analyst-starter

Starter para analistas financieros (Investment Banking / Equity Research / Restructuring) que usan **Claude Code** como copiloto en Windows.

Trae armado:

- Sistema de **memoria persistente** (Claude recuerda tu perfil, decisiones, pendientes, entre sesiones)
- **Slash commands** de dominio: `/deep-research`, `/build-model`, `/lbo-model`, `/comps`, `/ic-memo`, `/teaser`, `/cim`, `/pitch-deck`, `/13-week-cf`, `/target-screening`, `/company-profile`
- **Skills** con convenciones IB: formato de Excel (azul input / negro fórmula / verde link), estructura de IC memo, templates de deck HTML, convenciones de modelos DCF/LBO/comps
- **Bootstrap 1-comando** para Windows: instala Node, Git, Python, VS Code, Claude Code y clona todo, desatendido

---

## Instalación en Windows (15 min)

Abrí **PowerShell** (Win+R → escribí `powershell` → Enter) y pegá esta línea:

```powershell
irm https://raw.githubusercontent.com/Barku1234/claude-analyst-starter/main/bootstrap.ps1 | iex
```

El script instala todo lo necesario y abre VS Code apuntando al starter. Después:

1. **Panel Claude Code** a la derecha en VS Code → click **Login** → login con Anthropic.
2. Tipeá **`/onboard-analyst`** en el chat de Claude.
3. Responde 4-5 preguntas. Listo.

Detalles paso-a-paso con troubleshooting → [`INSTALL.md`](./INSTALL.md).

---

## Cómo usar día a día

### Abrir Claude Analyst

Tenés tres formas (usá la que prefieras):

**A) Doble-click** en el icono **"Claude Analyst"** de tu escritorio.

**B) Abrí PowerShell y tipeá `cra`.**

**C) VS Code → Ctrl+Shift+P → escribí "Claude Analyst".**

Cualquiera abre VS Code apuntando al starter con el panel Claude listo.

### Arrancar sesión

Apenas entrás, en el chat de Claude escribí:

```
/start-session
```

Claude lee tu memoria, te dice **en qué quedaste** la sesión anterior, qué **proyectos activos** tenés, qué **pendientes** hay, y sugiere próximos pasos.

### Trabajar

Usá cualquier slash command de la tabla de abajo, o pedile a Claude directamente en lenguaje natural:

> "Necesito un DCF de Salesforce para mañana, base + upside"

Claude va a proponer usar `/build-model` y arrancar.

### Cerrar sesión

Cuando terminás el día (o el bloque de trabajo):

```
/end-session
```

Claude:
1. Analiza qué se hizo en la sesión
2. Actualiza tu memoria con **proyectos nuevos, decisiones, aprendizajes, feedback**
3. Te pregunta si querés hacer commit local de los archivos generados (nunca push automático — vos decidís qué se sube)

Así la próxima vez que abras, `/start-session` recupera todo el contexto.

**Comandos de trabajo** (cualquiera, en cualquier momento):

| Comando | Qué hace |
|---|---|
| `/deep-research <tema>` | Research a fondo con multi-fuente, citations, síntesis |
| `/company-profile <ticker o empresa>` | 1-pager con financials, business, mgmt, comps |
| `/build-model <empresa>` | 3-statement + DCF en `.xlsx` con convenciones IB |
| `/lbo-model <target> <sponsor>` | LBO en `.xlsx`: sources & uses, returns, sensitivity |
| `/comps <sector> <empresas>` | Trading comps + transaction comps table |
| `/ic-memo <deal>` | Investment Committee memo estructurado |
| `/teaser <target>` | 1-pager sell-side (anónimo o no) |
| `/cim <target>` | Confidential Info Memo completo |
| `/pitch-deck <cliente> <tema>` | Deck HTML editable (exportable a PPTX) |
| `/13-week-cf <empresa>` | 13-week cash flow model (restructuring) |
| `/target-screening <tesis>` | Screening de M&A buy-side por tesis |

Todos los outputs quedan en `research/`, `models/` o `decks/` según corresponda.

---

## Estructura de carpetas

```
claude-analyst-starter/
├── .claude/                    # Config de Claude Code (NO tocar salvo que sepas)
│   ├── settings.json           # Permisos + plugins recomendados
│   ├── commands/               # Los slash commands (markdown editable)
│   └── skills/                 # Convenciones IB, templates
├── memory/                     # Tu memoria persistente
│   ├── MEMORY.md               # Índice de memorias (Claude lo maneja)
│   └── examples/               # Ejemplos de formato (no se cargan)
├── research/                   # Tus investigaciones activas
├── models/                     # Tus .xlsx (modelos, comps, LBO)
├── decks/                      # Tus .html y .pptx (presentaciones)
├── bootstrap.ps1               # Instalador Windows (no lo edites)
└── README.md, INSTALL.md       # Esta doc
```

---

## Actualizar el starter

Cada tanto vienen mejoras nuevas al repo. Para pullearlas:

**Opción A** — Desde VS Code: `Ctrl+Shift+P` → `Tasks: Run Task` → `Claude Analyst: Update Starter`.

**Opción B** — Desde terminal integrada de VS Code (menú Terminal → New Terminal):
```
git pull
```

Tus archivos en `research/`, `models/`, `decks/` y `memory/` **NO se tocan** — solo se actualizan los slash commands (`.claude/commands/`) y skills (`.claude/skills/`).

## Flow diario típico (ejemplo)

```
09:00  →  Doble-click 'Claude Analyst' en escritorio (o 'cra' en PowerShell)
09:00  →  /start-session
          Claude: "Ayer quedamos con Project Atlas — modelo DCF 80% listo,
                   falta sensitivity y validar WACC. También hay que empezar
                   comps para el IC del jueves."

09:15  →  "Terminá el DCF y armá sensitivity de WACC × TGR"
          Claude edita models/Atlas_DCF_v3.xlsx

10:30  →  /comps CPG Snacks
          Claude arma models/CPGSnacks_Comps_20260806.xlsx con 8 peers

12:00  →  /ic-memo Project Atlas
          Claude genera research/Atlas_ICMemo_v1.docx (draft)

15:00  →  "Revisá el executive summary — está muy hedgeado"
          Claude reescribe con voz directa

17:30  →  /end-session
          Claude: "Guardo: DCF finalizado, comps armados, IC memo v1
                   pendiente review MD. Committeo local (sin push)."

Mañana → /start-session recupera exactamente donde quedaste.
```

---

## Preguntas frecuentes

**¿Los archivos que genera Claude son míos o de Anthropic?**
Son 100% tuyos. Viven en tu disco (`C:\Users\<vos>\Documents\claude-analyst-starter\`). Anthropic no los ve.

**¿Puedo usar esto para trabajo del banco / info confidencial?**
Depende de la política de tu banco. Claude Code manda tus prompts a Anthropic (con opción Enterprise que garantiza no-training). Consultá con compliance antes de meter data material no pública (MNPI).

**¿Cuánto cuesta?**
El plan Claude Pro/Max de Anthropic (uso ilimitado razonable, ~$20-100/mes) alcanza para uso diario intenso. Si usás API con billing por token, un IC memo largo ronda $0.50-2 USD.

**¿Puedo trabajar sin internet?**
No. Claude Code necesita conexión a Anthropic. Los archivos locales sí quedan en tu disco.

**¿Y si algo se rompe?**
Todo lo que hace Claude es reversible con Ctrl+Z en VS Code o `git checkout`. La memoria vive en `memory/MEMORY.md` — si la borrás, Claude arranca de cero pero no se rompe nada más.

---

## Créditos

Starter derivado de la infra de Barku (repo interno, Chile).
Mantenido por [@Barku1234](https://github.com/Barku1234).
