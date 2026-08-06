---
description: 13-week cash flow model (restructuring). Uso: /13-week-cf <empresa>
---

# /13-week-cf

**Uso:** `/13-week-cf TargetCo` — modelo semanal 13 semanas para restructuring / distressed situations.

## Skills

- `restructuring-templates`
- `excel-ib-conventions`
- `xlsx`

## Proceso

1. **Pedile al usuario**:
   - ¿Pre-file (before Chapter 11) o in-court?
   - Day-0 bank balance (starting cash)
   - ¿Existe latest weekly AR aging + AP aging?
   - Payroll cadence (weekly / bi-weekly / monthly)
   - Major payment dates conocidas (rent, tax, interest, insurance)
   - Min operating cash requirement (default: max($10M, 3% revenue))
   - ¿DIP financing en discusión? (facility size, draw schedule)
   - Escenarios? (base / downside / upside)

2. **Construir en `models/[Company]_13WCF_[YYYYMMDD]_v1.xlsx`:**

   **Tabs:**
   - `Cover`
   - `Assumptions` (day-0 cash, DIP size, sensitivity variables)
   - `Base Case` (13 columns = 13 weeks + Total column)
   - `Downside` (idem, con revenue -20%, EBITDA margin -300bps)
   - `Upside` (idem, con revenue +5%, cost cuts)
   - `Chart` (Ending Cash weekly line, con Min Operating Cash line)
   - `Notes` (rationale por línea de disbursement)

3. **Estructura columnaria (todas las tabs):**

   ```
   Row | A: Label                   | B-N: Week 1-13 | O: Total
   ----|-----------------------------|-----------------|--------
     1 | Week ending date            | 15-Aug          | 22-Aug ...
     2 |                             |                 |
     3 | RECEIPTS                    |                 |
     4 |   Customer collections      | ...             |
     5 |   Other receipts            | ...             |
     6 |   Total Receipts            | =SUM(B4:B5)     |
     7 |                             |                 |
     8 | DISBURSEMENTS               |                 |
     9 |   Payroll                   | ...             |
    10 |   Rent                      | ...             |
    11 |   Utilities                 | ...             |
    12 |   Vendors (critical)        | ...             |
    13 |   Vendors (trade payables)  | ...             |
    14 |   Insurance                 | ...             |
    15 |   Taxes                     | ...             |
    16 |   Interest / debt service   | ...             |
    17 |   Professional fees         | ...             |
    18 |   Other                     | ...             |
    19 |   Total Disbursements       | =SUM(B9:B18)    |
    20 |                             |                 |
    21 | NET CASH FLOW               | =B6-B19         |
    22 |                             |                 |
    23 | Beginning Cash              | [day-0]         |
    24 | + Net CF                    | =B21            |
    25 | + DIP Draws                 | ...             |
    26 | - DIP Paydowns              | ...             |
    27 | Ending Cash                 | =B23+B24+B25-B26|
    28 | Min Operating Cash Req      | [floor]         |
    29 | Excess / (Deficit)          | =B27-B28        |
    30 |                             |                 |
    31 | CHECK (should be 0)         | =B27-(B23+B24+B25-B26) |
   ```

4. **Sanity checks:**
   - Check row (fila 31) = 0 en cada semana
   - Ending Cash week 13 no negativa (en base case)
   - Si Ending Cash < Min Op Cash en alguna semana → highlight rojo, calc DIP need
   - Total column (O) = suma horizontal de B-N para líneas cash-flow

5. **Chart obligatorio** (tab `Chart`):
   - X-axis: Week 1-13
   - Y-axis: $ (millions)
   - Line 1: Ending Cash (blue)
   - Line 2: Min Operating Cash Required (red dashed, threshold)
   - Vertical line en el "crossover week" (donde Ending < Min) si aplica
   - Anotación: max deficit + DIP need calc

6. **Al terminar**:
   - Reportá al usuario: ¿la empresa sobrevive 13 semanas sin DIP? ¿Con DIP de qué tamaño? Cuándo es el cash crossover point?

## Output esperado

```
13WCF listo: models/TargetCo_13WCF_20260805_v1.xlsx

Base case:
  Day-0 Cash:         $[X]M
  Week-13 Ending:     $[Y]M
  Min Op Cash Req:    $[Z]M
  Cash trough:        $[W]M in Week [N]
  
  Verdict: [SURVIVE without DIP / NEED DIP of $[X]M by Week [N] / INSOLVENT by Week [N]]

Downside case:
  Week-13 Ending:     $[Y]M
  DIP need:           $[X]M by Week [N]

Upside case:
  Week-13 Ending:     $[Y]M
  Cash headroom:      +$[X]M vs base

Sensitivity to top receipt (customer collections) -10%: DIP need shifts +$[X]M
Sensitivity to payroll +10%: DIP need shifts +$[X]M

Sanity checks: ✓ All check rows = 0 | ✓ S&U on DIP balances

¿Querés que arme el waterfall de creditor recovery o el DIP financing memo?
```

## Reglas hard

- **Cash basis, not accrual.** Que se cobra vs se paga.
- **Weekly granularity**, never monthly.
- **Bottom-up build** (item-by-item), never top-down.
- **Update weekly** durante Chapter 11 (o pre-file negotiation).
- **Nunca > $0 en NET CF base case sin justificación** (si empresa está generando cash sin problema, ¿por qué está en restructuring?).
