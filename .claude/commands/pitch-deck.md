---
description: Pitch deck HTML editable (exportable PPTX/PDF). Uso: /pitch-deck <cliente> <tema>
---

# /pitch-deck

**Uso:**
- `/pitch-deck "TargetCo Board" "Strategic Alternatives Review"`
- `/pitch-deck "PE Sponsor" "Buyside Opportunity — Project Neptune"`
- `/pitch-deck "Internal IC" "Q3 Deal Review"`

## Skills

- `html-deck-templates` (base)
- `ib-persona`
- `frontend-design` (built-in, para pulir)
- `dataviz` (built-in, para charts)
- `pptx` (built-in, para conversión)

## Proceso

1. **Pedile al usuario contexto**:
   - Audiencia (Board, IC, PE Sponsor, strategic acquirer, client mgmt)
   - Purpose (pitch pursuit, strategic review, IC ask, deal update)
   - Longitud target (20-30 slides main + apéndice típico; 40+ para pitch pursuits grandes)
   - Datos disponibles (modelo, comps, research previos)
   - Deadline
   - ¿Brandbook del banco? (si no, usar defaults del template)

2. **Estructura típica (adaptar según purpose)**:

   ```
   Cover
   Agenda / Executive Summary
   
   1. Situation & Objectives
      - Client context / mandate
      - Objectives of the review
      
   2. Market Overview
      - Industry snapshot (size, growth, dynamics)
      - Trends impacting client
      
   3. [Company / Target] Overview
      - Business description
      - Key financials
      - Positioning
      
   4. Strategic Alternatives (o Investment Thesis según purpose)
      - Option 1: IPO / Sale / Recap / Status Quo
      - Option 2: ...
      - Comparative analysis
      
   5. Valuation
      - Football field
      - Trading comps
      - Precedent transactions
      - DCF (if applicable)
      
   6. Recommendation / Path Forward
      - Rationale
      - Process outline
      - Timeline
      - Bank credentials (why us)
      
   Apéndice
      - Detailed comps
      - Detailed financial projections
      - Bios of deal team
      - Bank tombstones (relevant past transactions)
   ```

3. **Construir el HTML** siguiendo `html-deck-templates`:
   - Cada slide = `<section class="slide">`
   - 1 idea por slide, título con conclusión
   - Charts como SVG inline (mejor calidad print)
   - Tables con formato IB
   - Footer confidential + page number en cada slide

4. **Guardar en `decks/[Client]_[Topic]_[YYYYMMDD]_v1.html`**.

5. **Preview**: `start decks/[file].html` (Windows) abre en Chrome. Verificá visual.

6. **Al terminar**, preguntá:
   - ¿Convertir a PPTX editable? (usa skill `pptx`)
   - ¿Exportar a PDF? (Chrome print o headless)
   - ¿Compartir con deal team?

## Output esperado

```
Pitch deck listo: decks/TargetCoBoard_StrategicReview_20260805_v1.html

Structure:
  Cover + Agenda + Executive Summary        (3 slides)
  1. Situation & Objectives                 (2 slides)
  2. Market Overview                        (4 slides)
  3. TargetCo Overview                      (5 slides)
  4. Strategic Alternatives                 (6 slides)
  5. Valuation                              (4 slides)
  6. Recommendation                         (3 slides)
  Apéndice                                  (12 slides)
  Total: 39 slides

Design:
  Primary color: [banco brand navy #1F4E78]
  Accent: [red #C00000]
  Fonts: Calibri (portable a PPTX)

Charts embedded:
  - Football field (Valuation section)
  - EV/EBITDA distribution
  - Revenue growth by segment
  - Strategic alternatives comparison matrix

Preview: file:///[path]/decks/TargetCoBoard_StrategicReview_20260805_v1.html

¿Querés que convierta a PPTX editable o que ajuste alguna sección?
```

## Reglas

- **Nunca > 6 bullets por slide** (usá 2-column si necesitás más).
- **Charts con conclusión en el título** ("EBITDA margin expanded 300bps '23-'25"), no descriptivos.
- **Colors consistent** — 3 colores máximo por deck (primary, accent, muted).
- **Footer en cada slide** con `Confidential | [Banco] | Page X of Y`.
- **Cover con codename** si aplica (`Project Atlas`).
