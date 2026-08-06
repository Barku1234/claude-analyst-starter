---
description: 1-pager company profile (research quick-and-dirty). Uso: /company-profile <ticker o empresa>
---

# /company-profile

**Uso:**
- `/company-profile AAPL`
- `/company-profile "Zoom Video"`
- `/company-profile "TargetCo (private)"`

Genera un profile de 1 página en ~30 segundos. Ideal para preparar antes de un meeting, screening rápido, o kickoff de coverage.

## Skills

- `ib-persona`
- `dataviz` (mini chart embed)

## Proceso

1. **Identificá la empresa** — si es ticker público, pull de fuentes públicas. Si privada, pedile al usuario data disponible (S-1, offering memo, website).

2. **Structure del profile (1 página, markdown)**:

   ```markdown
   # [Company Name] ([Ticker])
   
   *[Fecha del profile]. Analyst: [User]*
   
   ## Snapshot
   
   | | |
   |---|---|
   | **HQ** | [City, Country] |
   | **Founded** | [Year] |
   | **CEO** | [Name] (since [Year]) |
   | **Employees** | [~N] |
   | **Sector** | [Sector / Sub-sector] |
   | **Website** | [URL] |
   | **Market Cap** | $[X]Bn |
   | **EV** | $[X]Bn |
   | **Last close** | $[X] ([+/- Y]% YTD) |
   
   ## Business
   
   [2-3 sentences: what they do, how they make money, who buys.]
   
   **Segments** (FY revenue):
   - [Segment A]: [X]% ($[Y]M) — [1-line description]
   - [Segment B]: [X]% ($[Y]M) — ...
   - [Segment C]: [X]% ($[Y]M) — ...
   
   **Geographic mix**: [US X%, EMEA Y%, Asia Z%]
   
   ## Financials (LTM Q[X] '[YY])
   
   | Metric | Value | YoY |
   |---|---|---|
   | Revenue | $[X]M | +[Y]% |
   | Gross Profit | $[X]M ([Z]%) | +/- [Y]bps |
   | EBITDA | $[X]M ([Z]%) | +/- [Y]bps |
   | Net Income | $[X]M | +[Y]% |
   | FCF | $[X]M | +/- [Y]% |
   | Net Debt | $[X]M ([Y]x LTM EBITDA) | |
   
   **3-year track record**: Revenue [$W]M → [$X]M ([Y]% CAGR); EBITDA margin [W]% → [X]%.
   
   ## Valuation
   
   | Multiple | LTM | NTM | +2Y |
   |---|---|---|---|
   | EV / Revenue | [X]x | [Y]x | [Z]x |
   | EV / EBITDA | [X]x | [Y]x | [Z]x |
   | P / E | [X]x | [Y]x | [Z]x |
   
   Vs peer median NTM EV/EBITDA: [X]x (target trades at [+/- Y]% [premium/discount]).
   
   ## Recent Developments (last 6 months)
   
   - **[Date]**: [Event 1, 1 line]
   - **[Date]**: [Event 2]
   - **[Date]**: [Event 3]
   
   ## Key Watch Items
   
   - [Item 1 — earnings, guidance, product launch, regulatory, M&A]
   - [Item 2]
   - [Item 3]
   
   ## Sources
   
   [1] Company 10-K/10-Q filings; [2] Capital IQ (as of [DD-MMM-YYYY]); [3] [any other]
   ```

3. **Guardar en `research/[Ticker or company-slug]_profile_[YYYYMMDD].md`**.

4. **Opcional**: si el usuario pide, generá versión HTML visual usando `html-deck-templates` como 1-slide.

## Output esperado

```
Company profile listo: research/AAPL_profile_20260805.md

Summary:
  Apple Inc. (AAPL) - Consumer Electronics / Services
  Market Cap: $[X]Bn | EV: $[Y]Bn
  LTM Revenue: $[X]Bn (+[Y]% YoY) | EBITDA: $[Z]Bn ([W]% margin)
  Valuation: [X]x NTM EBITDA vs peers [Y]x

Recent developments captured: [N] items last 6 months.

¿Querés que profundice en algún segmento, arme comps, o pase a modelo completo?
```

## Reglas

- **Datos verificables**: todo número con fuente + fecha (as of).
- **Sin recomendación** (no es un memo — es research neutral).
- **1 página**. Si te pasás, resumí o quitá secciones.
- **Charts opcionales**: 1 mini chart (revenue trend) si aporta, sino texto puro.
