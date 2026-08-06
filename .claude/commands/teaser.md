---
description: 1-pager sell-side (teaser). Uso: /teaser <target> [--anonymous]
---

# /teaser

**Uso:**
- `/teaser TargetCo` (nombre real, ya se firmó NDA con reader)
- `/teaser TargetCo --anonymous` (blind teaser, sin nombrar target)

## Skills

- `ib-persona`
- `html-deck-templates` (para versión visual)
- `docx` o `pdf` para versión de texto

## Proceso

1. **Pedile al usuario contexto**:
   - Anonymous o named? (blind teasers son estándar sell-side pre-NDA)
   - Codename (si anonymous): "Project [X]"
   - Sector + geography
   - Deal type: 100% sale, majority recap, minority investment
   - Bidder audience: strategic, PE, both
   - Target valuation range (opcional; sino podés omitir en teaser)
   - Contact info del deal team

2. **Estructura del teaser (1 página, MAX 2):**

   ```
   [BANK LOGO]
   
   PROJECT [CODENAME]
   Confidential Investment Opportunity — [Sector]
   [Date]
   
   OVERVIEW
   Leading [description in 15-25 words that doesn't reveal identity]
   
   TRANSACTION
   The Company is exploring a [sale / majority recap / etc.]. [Bank] has been retained as exclusive financial advisor.
   
   KEY METRICS (LTM)
   Revenue:            $[X]M
   EBITDA:             $[Y]M ([Z]% margin)
   Revenue growth:     [X]% ('23-'25 CAGR)
   Employees:          [~N]
   HQ:                 [Region, no exact city]
   
   INVESTMENT HIGHLIGHTS
   • [Highlight 1 — market position, con dato]
   • [Highlight 2 — growth driver, con dato]
   • [Highlight 3 — margin story]
   • [Highlight 4 — customer/product diversification]
   • [Highlight 5 — optionality]
   
   NEXT STEPS
   Interested parties should contact [Bank] to receive the Confidential Information Memorandum (CIM) after executing a mutual NDA.
   
   Contact:
   [Deal Team Lead Name], [Title]
   [Email] | [Phone]
   ```

3. **Escribir en dos formatos**:
   - `decks/[Project]_Teaser_[YYYYMMDD].html` (visual, para email attach o print)
   - `decks/[Project]_Teaser_[YYYYMMDD].pdf` (versión final para distribución)

   Usá el template de `html-deck-templates` para el HTML (adaptá el `.cover` style).

4. **Reglas críticas para teaser anónimo:**
   - **NO nombres del CEO/founders**
   - **NO ubicación exacta** (region-level ok: "Northeast US", "DACH region")
   - **NO customer names**
   - **NO ratios que permitan identificar** (ej: "3rd largest player in cat food with $180M revenue" → Google lo identifica)
   - **SI**: revenue, EBITDA, growth, margins, general industry descriptions

5. **Al terminar**:
   - Preguntá si quiere que arme el CIM completo (`/cim`) o el mgmt presentation deck.

## Output esperado

```
Teaser listo:
  decks/Project_Atlas_Teaser_20260805.html  (visual, editable)
  decks/Project_Atlas_Teaser_20260805.pdf   (final para distribución)

Preview:
  - Anonymous: ✓ (blind teaser)
  - Sector: CPG Snacks
  - Metrics disclosed: Revenue $[X]M, EBITDA $[Y]M, [Z]% growth
  - Highlights: 5 pillars
  - Contact: [Deal Team Lead]

Confidentiality check:
  ✓ No company name
  ✓ No CEO name
  ✓ No exact geography
  ✓ No customer names
  ⚠ "Founded 1998" — considerá remover si combinado con sector/geo identifica

¿Querés que exporte tambien a versión Word (editable por el banco), o que arme el CIM?
```

## Anti-patterns

- ❌ Numbers muy específicos que triangulan identidad ("$487M revenue" es único; "~$500M revenue" es genérico)
- ❌ "Family-owned since 1953" (si sector es niche, identificable)
- ❌ Logos, colores corporativos del target (obvio)
- ❌ Direct quotes del founder/CEO
