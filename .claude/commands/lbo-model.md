---
description: Construir modelo LBO en Excel (sources & uses, returns, sensitivity). Uso: /lbo-model <target> [sponsor]
---

# /lbo-model

**Uso:**
- `/lbo-model TargetCo` (sin sponsor específico)
- `/lbo-model TargetCo Blackstone` (con sponsor)
- `/lbo-model "Chipotle bear case"` (con context)

## Skills obligatorios

- `financial-modeling` (sección LBO)
- `excel-ib-conventions`
- `xlsx`

## Proceso

1. **Pedile al usuario contexto**:
   - Entry EV o entry multiple objetivo? (si sabe, hardcode; si no, asumir 10-12x LTM EBITDA sector-dependent)
   - Financing package esperado? (leverage típica sector: consumer 6.5x, tech 7x, industrials 5.5x, healthcare 6x)
   - Exit horizon? (default 5y)
   - Exit multiple? (default = entry multiple; sensibilizar ±2x)
   - ¿Fees típicos aplicables? (2% purchase equity, 1% annual monitoring)
   - ¿Management rollover? (default 5-10% del equity)

2. **Construir en `models/[Target]_LBO_[YYYYMMDD]_v1.xlsx`:**

   **Tabs:**
   - `Cover`
   - `Assumptions` (todos los inputs de deal + operating)
   - `Sources & Uses` (balancea al centavo)
   - `Operating Model` (3-statement compressed, focus en EBITDA + FCF)
   - `Debt Sched` (Term Loan A/B, Revolver, HY Bonds, Mezz — con amort, interest, mandatory prepay, cash sweep)
   - `Returns` (Exit EV → Exit Equity → IRR + MoM)
   - `Sensitivity` (grid Entry × Exit, grid Leverage × Rev Growth)
   - `Notes` (rationale, credit metrics evolution)

3. **Sanity checks obligatorios:**
   - Sources = Uses (al centavo)
   - Debt / EBITDA year 1 razonable (5-7x sector-dependent)
   - Fixed Charge Coverage > 1.5x cada año (sino default risk)
   - FCF / Debt > 10% year 1 para desapalancarse
   - IRR base case 20-25% (si <15% deal no vuela; si >35% asumís algo muy generoso)
   - MoM base case 2.5-3.0x en 5 años

4. **Sensitivity outputs:**
   - Grid IRR: entry multiple (X-1x, X, X+1x, X+2x) × exit multiple (idem)
   - Grid IRR: leverage (5x, 6x, 7x) × revenue CAGR (2%, 5%, 8%)
   - Chart bar: contribución al IRR (EBITDA growth vs multiple expansion vs debt paydown)

## Output esperado

```
LBO listo: models/TargetCo_LBO_20260805_v1.xlsx

Deal Summary:
  Entry EV:              $[X]Bn ([Y]x LTM EBITDA)
  Sponsor Equity Check:  $[X]Bn
  Debt Financing:        $[X]Bn ([Y]x LTM EBITDA)
  Rollover Equity:       $[X]M ([Y]% of equity)

Returns (5y hold):
  Base case IRR:   [X]%   |   MoM: [Y]x
  Upside IRR:      [X]%   |   MoM: [Y]x
  Downside IRR:    [X]%   |   MoM: [Y]x

Credit metrics day 1:
  Debt / EBITDA:   [X]x
  Fixed Charge Cov: [Y]x
  FCF / Debt:      [Z]%

Sanity checks: ✓ S&U balances | ✓ FCC >1.5x all years | ⚠ IRR base 18% (below 20% target)

¿Querés que ajuste leverage o exit assumptions?
```

## Reglas hard

- **Sources = Uses siempre**. Si no cierra, error.
- **Nunca IRR > 40% en base case**. Es señal de assumptions demasiado agresivos.
- **Nunca leverage > 8x** salvo tech scale-up muy específico.
- **Min operating cash** = max($10M, 3% revenue). No dejes a la empresa sin cash.
- **Interest rates**: usá curva actual (SOFR + spread). Term Loan típicamente SOFR+300-450. HY Bonds SOFR+500-700 (o fixed 7-9%).
