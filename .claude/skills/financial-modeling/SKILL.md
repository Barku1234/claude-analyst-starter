---
name: financial-modeling
description: Convenciones de modelos financieros IB — 3-statement, DCF, LBO, comps. Cuándo cada uno, qué inputs, qué outputs, qué sanity checks. Cargar cuando el usuario pida un modelo o cuando estés generando cualquier .xlsx analítico.
---

# Financial Modeling — convenciones IB

Complementa `excel-ib-conventions` (formato de celdas). Este skill cubre **lógica y estructura** de los modelos.

## 1. 3-statement model

**Cuándo:** base de todo (DCF, LBO, comps intrínsecos, LT planning).

**Estructura estándar (tabs):**

1. `Cover` — nombre modelo, versión, fecha, autor, disclaimer
2. `Assumptions` — todos los drivers en un solo lugar, azul input
3. `Income Statement` — histórico + forecast, típicamente 3y hist + 5y forecast
4. `Balance Sheet` — histórico + forecast
5. `Cash Flow Statement` — indirecto (Net Income → CFO → CFI → CFF)
6. `Debt Schedule` — separado si hay revolver, term loans, bonds
7. `Working Capital Schedule` — AR/AP/Inventory day-based
8. `PP&E Schedule` — CapEx, depreciation, disposals
9. `Equity Schedule` — buybacks, dividends, SBC

**Reglas críticas:**
- **Balance sheet balancea** en cada período (check `Assets - Liabilities - Equity = 0` en fila `Check`).
- **CFS reconcilia** con cambio en cash del BS (`Ending Cash CFS = Ending Cash BS`).
- **Interest expense** calculado sobre debt promedio (avg beg/end), no ending balance.
- **Circular reference** aceptable solo para revolver (activar iterative calc en Excel).

**Sanity checks obligatorios (fila Check al final de cada tab):**
- Revenue growth: si >50% YoY sin evento, flag amarillo.
- EBITDA margin: si cambia >500bps YoY, flag.
- FCF conversion: EBITDA → FCF debería ser 40-70% en negocios sanos.
- D&A vs CapEx: LT deberían converger (steady-state).

## 2. DCF (Discounted Cash Flow)

**Cuándo:** valuation intrínseca, IC memo, fairness opinion.

**Estructura:**
```
Assumptions (WACC, TGR, tax rate, forecast period)
FCF forecast (5-10 años, del 3-statement)
  Revenue → EBITDA → EBIT → NOPAT → +D&A → -CapEx → -ΔNWC → Unlevered FCF
Terminal value (Gordon Growth O Exit Multiple)
PV of FCF + PV of TV = Enterprise Value
- Net debt = Equity Value
÷ Diluted shares = Value per share
Sensitivity table (WACC × TGR o × Exit Multiple)
```

**Rangos razonables:**
- **WACC**: 6-12% para large caps developed markets. Emerging o small caps: 10-16%.
- **Terminal growth (Gordon)**: 1.5-3.0%. NUNCA >4% en mercado developed. Cap suave en 3%.
- **Exit multiple**: usar mediana peer group actual, no aspiracional. Sensibilizar ±2x.
- **Forecast period**: 5 años (industria estable), 7-10 años (growth / cyclical / turnaround).

**Checks:**
- **Implied perpetuity growth (si usaste exit multiple)** = razonable (< 4%). Si sale 6%, tu exit multiple es demasiado alto.
- **Implied exit multiple (si usaste Gordon)** = razonable (dentro del range peer). Si sale 40x en un negocio de 15x, tu TGR es demasiado alto.
- **TV / Total EV** típicamente 60-80%. Si es 95%, dependés casi todo del TV → sospechoso.

**Reglas hard:**
- Nunca terminal growth > risk-free rate.
- Nunca WACC < cost of debt.
- **Nunca beta negativo** (excepto gold / hedges muy específicos).
- Mid-year convention estándar (descontar cash flows al mid-year, no year-end) — ajusta ~half period of WACC.

## 3. LBO (Leveraged Buyout)

**Cuándo:** buy-side PE, sponsors, evaluar leverage capacity, IRR analysis.

**Estructura:**

```
Transaction Assumptions
  - Entry EV, entry EBITDA multiple
  - Sources: New Term Loan, HY Bonds, Revolver, PE Equity, Rollover Equity
  - Uses: Purchase Equity, Refi Debt, Fees, Min Cash
Debt Schedule
  - Amortization, interest, mandatory paydown, cash sweep, revolver
Operating Model (3-statement compressed)
Returns
  - Exit EV (year 5 EBITDA × exit multiple)
  - Debt paydown → Exit Equity
  - IRR + MoM sensitivity (entry × exit multiple grid)
Sensitivity
  - Grid IRR: entry multiple × exit multiple (+/- 1x each direction)
  - Grid IRR: leverage × revenue CAGR
```

**Métricas objetivo (rough guide 2025-26):**
- **Target IRR** sponsor: 20-25% base case, 15% downside, 30%+ upside
- **Target MoM**: 2.5-3.0x base case en 5 años
- **Leverage day 1**: 5.5-7.0x LTM EBITDA (varía por sector; consumer/tech mid-6x, industrial 5-6x)
- **Debt paydown**: ideal FCF/Debt > 15% year 1 para desapalancarse

**Reglas:**
- Sources & Uses **balancea al centavo**.
- Min cash operativo: usar $10M o 3% revenue (whichever higher) como floor.
- Sponsor fees típicos: 2% de purchase equity (upfront) + 1% of EBITDA (monitoring annual).
- Management rollover: 5-10% del equity total (verificar en term sheet).

## 4. Trading Comps

**Cuándo:** valuation relative, benchmarking, IC memos, teasers.

**Estructura:**

```
Company | Ticker | Mkt Cap | EV | Revenue (LTM/NTM) | EBITDA (LTM/NTM) | EV/Revenue | EV/EBITDA | P/E | Growth (LT) | Margin
```

**Reglas de selección de peers:**
- **6-10 comps** ideal. Menos de 4 = no es sample, es cherry-picking. Más de 12 = falta de foco.
- Selección MECE: por (a) sector, (b) tamaño (dentro de 0.5x-3x mkt cap), (c) growth profile, (d) geography.
- **Justificá cada exclusión**: si dejaste afuera un obvio (ej: no incluiste Microsoft en cloud comps de una empresa $10B), explicá por qué.

**Métricas primary:**
- EV/EBITDA (más común, robusto para cross-cap-structure)
- EV/Revenue (para negocios pre-EBITDA o high-growth)
- P/E (para financial services, insurance, o cuando debt no es material)
- EV/EBIT (cuando D&A es distorsivo o comparás capex-heavy vs light)

**Presentación:**
- **Ordenar por market cap descending**.
- **Median + Mean** en fila abajo (bold, highlighted).
- **Target company (si se muestra)** en fila separada al final (bold, distinto color).
- **NTM > LTM** para valuation (forward looking).

## 5. Transaction Comps (Precedent Transactions)

**Cuándo:** M&A valuation, IC memos, sell-side pitches (support pricing).

**Estructura similar a trading comps pero por deal:**
```
Announced | Target | Acquirer | Deal Value | Target Revenue | Target EBITDA | EV/Revenue | EV/EBITDA | Premium to unaffected
```

**Reglas:**
- Últimos **3-5 años** de deals; más viejos ya no reflejan mercado actual.
- **Excluir deals distressed / carve-outs / minority stakes** salvo que sean relevantes.
- Premium calculado a **20-day VWAP pre-announcement**, no closing day (evita "pre-leak" effect).
- **Deal value** ajustado por asumida debt / minority interest.

## 6. Sum-of-the-Parts (SOTP)

**Cuándo:** conglomerados, holdings, empresas multi-segmento.

**Estructura:**
```
Segment 1: EBITDA × Multiple → Segment EV
Segment 2: EBITDA × Multiple → Segment EV
...
Sum of Segment EVs
- Corporate overhead (as multiple of overhead EBITDA)
- Net debt
- Minority interest / preferred
= Equity Value
÷ shares
= Value per share
```

**Cuidado:**
- **Overhead corporativo**: alocar y capitalizar (no siempre a multiple = 0). Rango: 8-12x.
- **Multiples por segmento**: cada uno con su comp set. Documentar.

## 7. Convenciones cross-modelo

- **Signos**: revenue positivo, expenses negativo. NO poner CapEx con signo positivo y restarlo "porque es más intuitivo".
- **Fórmulas nunca dentro de una constant**: separar hardcodes (fondo amarillo o italic) del cálculo.
- **Nunca `=A1+A2+A3+A4+A5`** — usá `=SUM(A1:A5)`. Se quiebra menos al insertar filas.
- **Absolute vs relative refs**: absolutas (`$A$1`) para constantes/anchors, relativas para arrastre.
- **Naming ranges** para constantes globales: `WACC`, `TaxRate`, `TerminalGrowth`.
- **Font**: Calibri 10pt para números, Calibri 11pt bold para headers, Calibri 8pt para footnotes.

## Sanity checks universales (correr antes de entregar)

1. Cambio en un input driver mueve outputs en la dirección esperada.
2. Sensibilidades no explotan (nada NA/DIV0/REF).
3. Sanity trilogy: BS balances / CFS ties to BS cash / IS EPS ties to diluted share count.
4. Corré con inputs extremos (revenue growth 0%, growth 30%): resultados razonables?
5. Cross-check con back-of-envelope: si dice EV $5Bn y peers cotizan 12x $200M = $2.4Bn, ¿de dónde sale la diferencia?
