---
name: restructuring-templates
description: Templates y convenciones para deals de restructuring / distressed — 13-week cash flow, waterfall, DIP financing, plan of reorganization. Cargar cuando el usuario pida /13-week-cf, /waterfall, o cualquier deal restructuring.
---

# Restructuring Templates

Diferente lente al M&A tradicional: prioridad = **cash preservation + creditor recovery**, no valuation upside.

## 1. 13-Week Cash Flow (13WCF)

**El artefacto central del restructuring.** Muestra semana a semana si la empresa sobrevive o necesita DIP financing.

**Estructura del `.xlsx`:**

```
Column A (labels)         | B (Week 1) | C (Week 2) | ... | N (Week 13) | O (Total 13W)
Week ending date          | 15-Aug     | 22-Aug     | ... | 07-Nov
==============================================================
RECEIPTS
  Customer collections     | ...
  Other receipts           | ...
  Total Receipts           | =SUM(...)
DISBURSEMENTS
  Payroll                  | ...
  Rent                     | ...
  Utilities                | ...
  Vendors (critical)       | ...
  Vendors (trade payables) | ...
  Insurance                | ...
  Taxes                    | ...
  Interest / debt service  | ...
  Professional fees        | ...     ← restructuring advisors, legal
  Other                    | ...
  Total Disbursements      | =SUM(...)
NET CASH FLOW              | Rec - Disb
Beginning Cash             | (from prior week or day-0 bank balance)
+ Net Cash Flow
+ DIP Draws (if any)
- DIP Paydowns
Ending Cash                | check
Min Operating Cash Req     | (typically $5-10M or 3% revenue)
Excess / (Deficit)         | Ending - Min
```

**Reglas críticas:**
- **Weekly, not monthly.** El punto es granularidad.
- **Cash basis, not accrual.** Que se cobra vs se paga, no revenue/expense.
- **Bottom-up build** (línea por línea de disbursement), no top-down.
- **Fila Check** al final: `Ending Cash - (Beginning Cash + Net Cash Flow + DIP flow) = 0`
- **Sensitivity**: base / upside / downside en 3 columns paralelos, o 3 tabs.
- **Update cadence weekly** durante Chapter 11 (o pre-file weekly basis).

**Presentación:**
- Chart line con **Ending Cash vs Min Operating Cash** las 13 semanas.
- Highlight el "cash crossover point" (semana donde Ending Cash < Min) en rojo.
- Waterfall chart: Beg Cash → Receipts (+) → Disbursements (-) → End Cash.

## 2. Waterfall (Creditor Recovery)

**Estructura:**

```
                                    Face Value  | Recovery %  | Recovery $  | Payment Kind
-----------------------------------------------------------------------------------
Priority Claims (secured, superpriority)
  DIP Lenders                       [face]      | 100%        | [$]         | Cash at emergence
  Priority Wage/Tax claims (§507)   [face]      | 100%        | [$]         | Cash
  Admin claims (professionals)      [face]      | 100%        | [$]         | Cash
Secured Debt
  1st Lien Term Loan                [face]      | X%          | [$]         | Cash + New Debt
  1st Lien Revolver                 [face]      | X%          | [$]         | Reinstated
  2nd Lien Notes                    [face]      | X%          | [$]         | New Debt + Equity
Unsecured Debt
  Senior Unsecured Notes            [face]      | X%          | [$]         | New Equity
  Trade Payables                    [face]      | X%          | [$]         | Cash pool
Equity
  Existing Common Stock             ---         | ---         | ---         | Wiped out (or warrants)
-----------------------------------------------------------------------------------
Total Recovery                                                | [$]
```

**Reglas:**
- **Absolute Priority Rule**: senior debt cobra 100% antes de que junior cobre nada (Chapter 11 estricto — puede violarse por acuerdo con clases seniors).
- **Distributable Value** = Enterprise Value (post-emergence) - DIP - Priority Claims - Admin. Este es el pool que se reparte entre secured/unsecured/equity según waterfall.
- **Recovery % en secured**: función de si asset value cubre. Si LTV > 100%, recovery = 100%. Si menor, prorrata.
- **Recovery en new securities**: valuar a **Consensus TEV** post-emergence, no face value pre.

## 3. Sources & Uses (Chapter 11 emergence)

```
SOURCES
  Existing Cash (post-13WCF ending)
  New Term Loan (exit financing)
  New Equity (from unsecured creditors converting debt)
  Rights offering (backstopped by existing creditors)
Total Sources

USES
  Repay DIP Lenders
  Pay Priority + Admin Claims
  Cash to Secured Creditors (pro rata)
  Cash to Unsecured Pool
  Restructuring fees & expenses
  Min operating cash (going-forward)
Total Uses

Check: Sources = Uses
```

## 4. Plan of Reorganization Metrics

Cuando el deal necesita presentar al Bankruptcy Court:

- **TEV** (Total Enterprise Value) post-emergence — driven by DCF + comps
- **Total Debt / EBITDA** post-emergence: target 3-4x (down from 8-10x pre-file)
- **Interest coverage** post-emergence: target >2.5x
- **Liquidity headroom** day 1: 15-25% revolver undrawn

**Creditor voting classes** (Chapter 11 §1129):
- Cada clase vota separately
- 2/3 by amount + majority by number to accept
- Cramdown posible sobre dissenting classes si absolute priority se respeta

## 5. Sensitivity y downside scenarios

Todo modelo restructuring corre 3 escenarios paralelos:
- **Base case**: management plan (usually optimistic — descuentalo 20% en revenue)
- **Downside**: recesión + slippage (revenue -20%, EBITDA margin -300bps)
- **Liquidation**: chapter 7 hypothetical (asset-by-asset recovery)

Presentar los 3 en tab separado o columns paralelas.

## 6. Reglas específicas (Chapter 11 vs Out-of-Court)

**Out-of-Court** (private restructuring, sin filing):
- Faster, cheaper (no professional fees explosion)
- Requiere consent alto (typically >90% of debt holders)
- No stay of execution — vendors pueden cortar terms

**Chapter 11** (public filing):
- Automatic stay (freeze all collection)
- DIP financing available (superpriority)
- Cramdown possible sobre dissenting creditors
- Fees pesados (advisors, legal, court): $30-100M+ para caso mediano

En el memo, comparar ambos con NPV to creditors, timeline, execution risk.

## 7. Timeline template (Chapter 11 típico)

```
T-90 to T-0    | Pre-file: forbearance, negotiate RSA, prep 13WCF
T=0            | Petition Day (file Chapter 11)
T+1 week       | First Day motions (approval of DIP, cash mgmt, wages)
T+2 months     | Schedule of Assets & Liabilities filed
T+3-6 months   | Plan of Reorganization + Disclosure Statement filed
T+4-8 months   | Creditor voting
T+6-12 months  | Confirmation hearing → Effective Date
```

Total: 6-12 meses in-court; 3-6 meses out-of-court.
