---
description: Trading comps + precedent transactions table. Uso: /comps <sector o target> [peers]
---

# /comps

**Uso:**
- `/comps SaaS Vertical` (Claude selecciona peers)
- `/comps Zoom peers:Teams,Webex,RingCentral,Salesforce` (peers dados)
- `/comps Apple` (Claude arma peer set)

## Skills

- `financial-modeling` (sección comps)
- `excel-ib-conventions`
- `xlsx`

## Proceso

1. **Definir peer set** (6-10 companies):
   - Si el usuario los dio, usalos + validá selección.
   - Si no, Claude propone → user aprueba/edita.
   - Criterios MECE: sector similar, tamaño 0.5x-3x, growth profile, geography.
   - **Justificar exclusiones** obvias.

2. **Pull data** de cada peer:
   - Ticker, market cap, EV
   - Revenue (LTM, NTM, +1Y)
   - EBITDA (LTM, NTM, +1Y)
   - Net Income (LTM, NTM)
   - Net Debt
   - Growth (revenue CAGR NTM-3Y, LT consensus)
   - Margins (EBITDA, EBIT, Net)
   - Shareholder returns (dividend yield, buyback yield)

   Fuentes: Capital IQ, Bloomberg, company filings. Marcar `as of DD-MMM-YYYY`.

3. **Precedent transactions** (si el usuario lo pide o si es para M&A):
   - Últimos 3-5 años, deals similares
   - Announced date, target, acquirer, EV, target rev/EBITDA, EV/rev, EV/EBITDA, premium
   - Excluir distressed, carve-outs, minority stakes (salvo relevantes)

4. **Construir en `models/[Sector]_Comps_[YYYYMMDD].xlsx`:**

   **Tabs:**
   - `Cover`
   - `Trading Comps` (main table + medians + means)
   - `Precedent Transactions` (si aplica)
   - `Peer Selection Rationale` (por qué cada peer)
   - `Charts` (football field, EV/EBITDA distribution, growth-margin scatter)

5. **Presentación:**
   - Ordenar por market cap descending
   - Median + Mean bold en filas al final
   - Si hay target company, ponerla en fila separada (bold, distinto color)
   - NTM > LTM (forward > trailing)
   - Números formato IB (ver `excel-ib-conventions`)

6. **Sanity check:**
   - Nadie con múltiplo >2x el median sin justificación (outlier — considerar excluir o marcar)
   - EV/Revenue debería correlacionar con growth × margin (sino algo raro)

## Output esperado

```
Comps listos: models/SaaS_Vertical_Comps_20260805.xlsx

Peer set (6 companies): Peer A, Peer B, ..., Peer F
Excluídos: [X] (razón: distinto sub-sector), [Y] (tamaño 10x más grande)

Trading Multiples (median):
  EV / Revenue NTM:  [X]x
  EV / EBITDA NTM:   [Y]x
  P / E NTM:         [Z]x

Growth-adjusted (rule of 40, PEG):
  Growth CAGR:       [X]%
  EBITDA margin:     [Y]%
  Rule of 40:        [Z] (>40 = healthy)

Charts generados:
  - Football field (rangos por metodología)
  - EV/EBITDA distribution (histogram)
  - Growth vs margin scatter (con target)

Precedent transactions: [N] deals últimos [Y] años, median EV/EBITDA [X]x

¿Querés que arme comps de un sub-set más específico o que use estos para /ic-memo?
```

## Reglas

- **Nunca hagas up comps sin fuente**. Todo dato viene de CapIQ / Bloomberg / filings.
- **Nunca menos de 4 peers** (no es sample).
- **Nunca más de 12** (no es foco).
- **Timestamp** obligatorio (as of).
- **Fuente al pie** de cada tabla.
