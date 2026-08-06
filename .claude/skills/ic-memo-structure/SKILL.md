---
name: ic-memo-structure
description: Estructura estándar de un Investment Committee Memo (buy-side o sell-side). Secciones, orden, longitud, tono. Cargar cuando el usuario pida /ic-memo o cualquier variante (deal memo, credit memo, IC paper).
---

# IC Memo — Estructura estándar

Va acompañado de `ib-persona` (tono) y `financial-modeling` (números).

## Estructura canónica (8-15 páginas + apéndices)

### 1. Executive Summary (1-2 páginas, PRIMERO)

Formato: 5-7 bullets. Cada bullet es una **afirmación fuerte con dato**. Si el reader lee solo esto, ya sabe qué decidir.

Debe contener:
- Descripción del deal (target + transaction structure) en 1 línea
- Recommendation (verbo activo: `Recommend proceeding at $XBn EV`)
- Valuation ($ y múltiplo, con range)
- Key strengths (2-3 bullets, dato-driven)
- Key risks (2-3 bullets, con mitigants)
- Next steps (concretos)

### 2. Transaction Overview (1 página)

- Deal structure diagram (buyer/seller/target/consideration flow)
- Purchase price + funding sources
- Timeline (announcement, close target)
- Deal team

### 3. Company Overview (2-3 páginas)

- Business description (qué hacen, cómo ganan plata, quién compra)
- History (fundación, milestones, ownership evolution)
- Segments / product lines (breakdown de revenue por segmento con %)
- Geographic footprint
- Mgmt team (top 5, background, tenure)

### 4. Industry Overview (1-2 páginas)

- Market size + growth (LT + NTM)
- Dinámicas competitivas (Porter 5 forces summary)
- Trends que benefician / amenazan al target
- Regulatory environment
- **Comparación con market**: dónde está el target vs mercado (share, growth, margins)

### 5. Financial Overview (2 páginas)

- Revenue + EBITDA + FCF hist (3-5y) + forecast (5y)
- Key financial metrics table
- Growth drivers (top 3, cuantificados)
- Margin drivers (mix, scale, pricing)
- Capital structure (debt / equity / covenants)

### 6. Investment Thesis (1-2 páginas — el corazón del memo)

**Formato pillars.** 3-5 pillars, cada uno:
- **Titular**: afirmación fuerte ("Market leader in growing category")
- **Evidence**: 2-4 bullets con datos
- **Value creation**: cómo se traduce en $/EBITDA/multiple

Ejemplos de pillars comunes:
- Market leadership (share, moat, brand)
- Structural growth (secular trends, TAM expansion)
- Margin expansion opportunity (scale, mix, ops leverage)
- Cash flow / capital returns (buybacks, dividends, deleveraging)
- Optionality (adjacencies, geographies, M&A)

### 7. Valuation (2 páginas)

- **Football field** chart (todas las metodologías con rangos)
- **Trading comps** table (median + mean, target position)
- **Precedent transactions** table (últimos 3-5y, similar deals)
- **DCF** summary (base/upside/downside, WACC × TGR sensitivity)
- **LBO** analysis (solo si buy-side; entry × exit IRR grid)
- **Implied premium** vs unaffected (si público) / vs prior fundraise (si privado)

### 8. Risks & Mitigants (1-2 páginas)

**Formato tabla:** Risk | Likelihood | Impact | Mitigant

3-5 risks. Cada uno **con probabilidad estimada** (Low/Med/High) e **impacto cuantificado** ($ o EBITDA).

Ejemplos:
- Customer concentration (top-10 = X% of revenue)
- Regulatory (specific regulation on horizon)
- Key person (mgmt dependency)
- Cyclicality (rev sensitivity to macro)
- Technology disruption (specific threat)
- Working capital / cash burn

### 9. Recommendation (1 página, ÚLTIMO ANTES DE APÉNDICE)

- **Verdict claro** (`Approve at $2.8Bn EV subject to satisfactory DD`)
- Conditions / caveats (concretos, con owner + timeline)
- Approvals needed (Legal, Compliance, Credit Committee, Global Head)
- Next steps con timeline

### Apéndices

- A: Detailed financial projections
- B: Detailed comps set
- C: DCF sensitivity tables full
- D: Management bios (full)
- E: Legal structure / cap table detail

## Reglas de escritura

- **Nunca hedgear** en la Recommendation (ver `ib-persona`).
- **Charts con conclusión en el título** ("Revenue grew 23% CAGR '23-'25", not "Revenue trend").
- **Cada afirmación con fuente** (`Company filings; CapIQ; Team analysis`).
- **Header + footer en cada página**: `Project [Codename] — Confidential — [Banco] — [Date] — Page X of Y`.
- **Codename** (Project Atlas, Project Neptune) obligatorio si no se firmó NDA con todos los readers.

## Longitud target

| Sección | Páginas |
|---|---|
| Executive Summary | 1-2 |
| Transaction Overview | 1 |
| Company Overview | 2-3 |
| Industry Overview | 1-2 |
| Financial Overview | 2 |
| Investment Thesis | 1-2 |
| Valuation | 2 |
| Risks & Mitigants | 1-2 |
| Recommendation | 1 |
| **Total (main body)** | **12-17** |
| Apéndices | 10-30 |

Si te pasás de 20 páginas de main body, hay algo mal — cortá o mové a apéndice.
