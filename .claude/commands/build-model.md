---
description: Construir 3-statement model + DCF en Excel con convenciones IB. Uso: /build-model <empresa>
---

# /build-model

**Uso:** `/build-model <empresa>` — ej: `/build-model Apple`, `/build-model Netflix bear case`

## Skills obligatorios

- `financial-modeling` (lógica, sanity checks)
- `excel-ib-conventions` (colores, fuentes, layout)
- `xlsx` (built-in, para escribir el archivo)
- `ib-persona` (tono para el título/documentación)

## Proceso

1. **Pedile al usuario contexto** (si falta):
   - ¿Empresa pública o privada?
   - ¿Purpose? (valuation, LBO screening, DCF sanity, coverage init)
   - ¿Financial history disponible? (SEC filings, S-1, private CIM)
   - ¿Forecast horizon? (5y default, 7-10y para growth/cyclical)
   - ¿Base case only o + upside + downside?

2. **Si es pública**: usá WebSearch + WebFetch para pull las últimas 3y de 10-K + latest 10-Q + guidance. Si tenés MCP de EDGAR o Bloomberg configurado, mejor.

3. **Si es privada**: pediles el S-1, offering memo, o management projections que tengan.

4. **Construir el modelo** en `models/[Company]_3StatementDCF_[YYYYMMDD]_v1.xlsx` con tabs:
   - `Cover` (nombre, fecha, autor, disclaimer)
   - `Assumptions` (todos los drivers en un lugar, azul input)
   - `IS` (income statement, hist + forecast)
   - `BS` (balance sheet)
   - `CFS` (cash flow, indirect method)
   - `Debt Sched` (si aplica)
   - `WC Sched` (working capital day-based)
   - `PPE Sched`
   - `DCF` (unlevered FCF → EV → equity → per share)
   - `Sensitivity` (WACC × TGR, WACC × exit multiple)
   - `Comps` (trading comps mini table, para cross-check)

5. **Sanity checks obligatorios** (poner filas `Check` en cada tab):
   - BS balances
   - CFS ties to BS cash
   - EPS ties to diluted share count
   - Sensitivity outputs no NA/DIV0
   - Implied perpetuity growth vs TGR
   - TV / Total EV < 80%

6. **Documentá supuestos clave** en un tab `Notes` o al pie del `Assumptions`:
   - WACC breakdown (Rf, beta, ERP, cost of debt, target D/E)
   - Growth assumptions con rationale
   - Margin trajectory con rationale
   - Tax rate (statutory + effective)
   - Terminal assumptions

7. **Al terminar**:
   - Corré todos los checks. Mostralos al usuario.
   - Preguntá si quiere sensitivity extendida (adicional a la default).
   - Preguntá si quiere que se conecte con `/comps` o `/ic-memo`.

## Output esperado (formato para el usuario)

```
Modelo listo: models/Apple_3StatementDCF_20260805_v1.xlsx

Valuation Summary:
  Base case EV:     $[X]Bn (implied per share: $[Y])
  Downside EV:      $[X]Bn (per share: $[Y])
  Upside EV:        $[X]Bn (per share: $[Y])

  Current market:   $[X]Bn (per share: $[Y]) → [premium/discount %]

WACC: [X]% | Terminal growth: [Y]% | Forecast: [N] years

Sanity checks: ✓ BS balances | ✓ CFS ties | ✓ EPS ties | ⚠ TV/EV = 82% (revisar TGR o exit mult)

Assumptions clave:
  - Revenue CAGR 2026-2030: [X]%
  - EBITDA margin steady state: [Y]%
  - CapEx / revenue: [Z]%

¿Querés que corra sensitivity adicional o que genere comps y IC memo?
```
