---
description: Investment Committee memo estructurado. Uso: /ic-memo <deal>
---

# /ic-memo

**Uso:**
- `/ic-memo Project Atlas` (sell-side deal, código project)
- `/ic-memo "Coinbase buy-side"` (buy-side coverage)
- `/ic-memo "Zoom initiation"` (equity research initiating coverage)

## Skills obligatorios

- `ic-memo-structure` (secciones + orden)
- `ib-persona` (tono, no hedging)
- `financial-modeling` (números)
- `docx` (built-in, para escribir el archivo final)

## Proceso

1. **Pedile al usuario contexto crítico**:
   - ¿Sell-side o buy-side?
   - ¿Cliente / sponsor / IC audience?
   - Deadline
   - ¿Codename? (Project X — obligatorio si NDA no firmado con todos los readers)
   - ¿Existe research previo? (`/company-profile`, `/deep-research` outputs)
   - ¿Existe modelo? (`/build-model`, `/lbo-model` outputs)

2. **Gatherá inputs**:
   - Leé outputs previos en `research/`, `models/`, `decks/` relacionados
   - Si falta info crítica, pedí al usuario o corré `/deep-research` inline

3. **Estructura el memo** siguiendo `ic-memo-structure`:
   - Executive Summary (1-2p)
   - Transaction Overview (1p)
   - Company Overview (2-3p)
   - Industry Overview (1-2p)
   - Financial Overview (2p)
   - Investment Thesis (1-2p, 3-5 pillars)
   - Valuation (2p, football field + comps + DCF + LBO si buy-side)
   - Risks & Mitigants (1-2p, tabla)
   - Recommendation (1p)
   - Apéndices

4. **Escribí a `research/[Project]_ICMemo_[YYYYMMDD]_v1.docx`** usando skill `docx`:
   - Font Calibri 11pt body, 14pt bold headers
   - Header en cada página: `[Project Codename] — Confidential — [Banco] — [Date]`
   - Footer: `Page X of Y`
   - Watermark `DRAFT` en cover si aún no es final
   - Charts embed como imágenes o tablas nativas
   - Table of Contents al principio (después del cover)

5. **Reglas de escritura críticas** (leé `ib-persona`):
   - Zero hedging ("we believe" prohibido)
   - Números primero, adjetivos después
   - Verbs activos
   - MECE
   - Cada afirmación con fuente

6. **Al terminar**:
   - Corré un self-review: MECE? Números consistentes con el modelo? Todos los pillars soportados?
   - Reportá al usuario resumen + próximos pasos.

## Output esperado (mostrar al usuario)

```
IC Memo listo: research/Project_Atlas_ICMemo_20260805_v1.docx

Contenido:
  - Executive Summary (2 páginas): 6 bullets, recommendation clara
  - Transaction Overview: EV $[X]Bn ([Y]x LTM EBITDA)
  - Company Overview: 3 páginas
  - Industry: 2 páginas ([market] growing at [Z]% CAGR)
  - Financials: revenue [$X]M → [$Y]M (2026-2030), EBITDA margin [Z]% → [W]%
  - Investment Thesis: 4 pillars ([P1], [P2], [P3], [P4])
  - Valuation: $[X]-$[Y]Bn range, base $[Z]Bn
  - Risks: 5 identified, all with mitigants
  - Recommendation: APPROVE at $[X]Bn subject to [conditions]

Total: [N] páginas main body + [M] apéndices.

Self-review:
  ✓ MECE
  ✓ Zero hedging language
  ✓ Todas las afirmaciones con source
  ⚠ Un chart en Valuation sin footer source (fix pending)
  ✓ Numbers consistent con models/[X].xlsx

¿Querés que revise una sección específica, arme el pitch deck acompañante, o exporte a PDF?
```
