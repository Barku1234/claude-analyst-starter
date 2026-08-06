---
name: excel-ib-conventions
description: Formato Excel estándar de banca de inversión — colores de celda (azul input / negro fórmula / verde link), fuentes, borders, layout, print setup. Cargar SIEMPRE que estés generando o editando un .xlsx.
---

# Excel IB Conventions

Reglas de formato que todo Analyst / Associate aplica desde el día 1. Los MDs las revisan.

Usá la skill `xlsx` para escribir/editar archivos; esta skill dice **cómo tienen que quedar**.

## 1. Color coding de celdas (el más importante)

| Contenido de la celda | Color de fuente | Ejemplo |
|---|---|---|
| **Hardcoded input** (número tipeado a mano) | **Azul** `#0000FF` | `WACC = 8.5%` en assumptions |
| **Fórmula** que referencia solo esa hoja | **Negro** `#000000` | `=B5*C5` |
| **Link a otra hoja** del mismo file | **Verde** `#008000` o `#006400` | `=Assumptions!B10` |
| **Link a otro workbook** (external) | **Rojo** `#FF0000` | `='[Comps.xlsx]Trading'!B5` — evitar si se puede |
| **Fecha hardcoded** (input) | Azul, italic | `31/12/2025` en encabezado columna |
| **Nota / comment** en celda | Gris `#808080`, italic 9pt | "assumes flat FX" |

**Nunca combinar fuente y fórmula en la misma celda**. Si necesitás formatear texto ("$" o "%") usalo con Format Cells, no en la fórmula.

## 2. Fill colors (background)

| Uso | Fill | Cuándo |
|---|---|---|
| **Check row** que debería dar 0 | Amarillo claro `#FFFF99` | Balance check, footings check |
| **Sensitivity headers** (row/column labels) | Gris claro `#D9D9D9` | Tornado table, 2-way sensitivity |
| **Total row** | Amarillo más oscuro `#FFE699` o **negrita + top border** | Fila `Total`, `EBITDA`, `Net Income` |
| **Section header** | Azul oscuro `#1F4E78` con fuente blanca | `INCOME STATEMENT`, `BALANCE SHEET` |
| **Warning / flag** | Rojo claro `#FFC7CE` | Si un check falla, celda se pinta |

## 3. Fuentes

- **Números**: `Calibri 10pt` (default). Bold para totals y section headers.
- **Headers de columna** (Year, Date): `Calibri 10pt bold`.
- **Section headers**: `Calibri 11pt bold`, uppercase, background azul oscuro + blanco.
- **Footnotes**: `Calibri 8pt italic`, gris.
- **Cover page title**: `Calibri 24pt bold`.
- **Cover page subtitle**: `Calibri 14pt`.

**Nunca Comic Sans, Arial, Times New Roman.** Calibri es el estándar de la industria.

## 4. Formato de números

En `Format Cells → Number`:

| Tipo | Formato Excel | Ejemplo |
|---|---|---|
| Currency millones | `_-#,##0.0,,_-;-#,##0.0,,_-;_-"-"_-;_-@_-` | `1,234.5` (representa 1.234,500,000) |
| Currency billions | `_-#,##0.00,,,_-;-#,##0.00,,,_-;_-"-"_-;_-@_-` | `1.23` |
| Percentage | `0.0%;(0.0%);"-"` | `18.5%` / `(3.2%)` / `-` |
| Basis points | `0"bps";(0)"bps";"-"` | `250bps` |
| Múltiplo | `0.0"x";(0.0)"x";"-"` | `13.1x` |
| Ratio | `0.00` | `1.25` |
| Whole units | `#,##0;(#,##0);"-"` | `1,234` |

**Reglas hard:**
- **Negativos siempre en paréntesis rojo/negro** (nunca con `-` al principio).
- **Zeros en dash** (`-`) no en `0` o `0.0` — lee más limpio.
- **Consistencia de decimales por columna**: si una celda es `18.5%`, todas las de esa columna son `X.X%`.

## 5. Layout de hoja

**Column widths estándar:**
- Column A (labels): `40` (para "Revenue growth (%)")
- Column B, C, D... (data): `12` (suficiente para `$1,234.5` o `18.5%`)
- Ajustar si histórico + forecast (muchas columnas): `10-11`.

**Row heights:**
- Default `15pt`.
- Section headers: `20pt`.
- Cover title: `40pt`.

**Freeze panes:**
- Siempre freeze en la primera columna con datos (típicamente `B` o `C`).
- Y en la primera fila con datos (típicamente `4-5`).

**Gridlines:**
- **Off** en output tabs (View → uncheck Gridlines) para look limpio.
- **On** en workings tabs (assumptions, schedules).

**Zoom:**
- `85%` default (aprovecha el ancho de pantalla).
- `100%` para print tabs.

## 6. Borders

- **Top+Bottom border black thin** en filas de Totals.
- **Bottom border double** debajo del "final answer" (ej: Enterprise Value, Value per share).
- **NO borders** en cell-by-cell fill (sucia la hoja).

## 7. Print setup

Todo tab presentable configurado para imprimir:

- **Orientation**: Landscape (default para modelos financieros).
- **Fit to**: 1 page wide × 1 page tall (obligatorio para 1-pagers).
- **Margins**: Narrow.
- **Header**: título del modelo + fecha.
- **Footer** (obligatorio): `Strictly Confidential | [Banco] | Page X of Y`.
- **Print area**: definido explícitamente (nunca dejar que Excel adivine).

## 8. Naming conventions

- **Tabs**: `Assumptions`, `IS`, `BS`, `CFS`, `Debt Sched`, `WC Sched`, `PPE Sched`, `DCF`, `Comps`, `Cover`. No `Sheet1`, `Sheet2`.
- **Named ranges** (Formulas → Define Name): `WACC`, `TaxRate`, `TerminalGrowth`, `ForecastYears`. Usar en fórmulas: `=EBIT*(1-TaxRate)` en lugar de `=B5*(1-B10)`.
- **File name**: `[Company]_[ModelType]_[YYYYMMDD]_v[X].xlsx` — ej: `Apple_DCF_20260805_v3.xlsx`.

## 9. Anti-patterns (nunca hacer)

- ❌ **Merged cells** (rompen ordenamiento y navigation). Usar "Center Across Selection" en su lugar.
- ❌ **Hardcodes en fórmulas** (`=B5*1.05`). Poné el `1.05` como named range o assumption.
- ❌ **Circular references** salvo revolver (con iterative calc activo, cap iterations = 100).
- ❌ **Volatile functions** (`INDIRECT`, `OFFSET`, `NOW`, `TODAY`) — cada cálculo del workbook las recalcula.
- ❌ **VLOOKUP con range_lookup TRUE** (approximate match, causa bugs sutiles). Usar `INDEX/MATCH` o `XLOOKUP` con exact match.
- ❌ **Grupos ocultos con contenido crítico** (columnas/filas hidden). Usar `Outline group` (con `+/-`) explícito.
- ❌ **Colores custom RGB inventados**. Usá los 6-7 colores estándar de arriba.

## 10. Cover page obligatoria

Todo modelo entregable tiene una tab `Cover` con:

- Nombre del modelo (grande, 24pt bold)
- Cliente / target company
- Fecha de la versión
- Autor (analista, associate)
- Version number (`v1`, `v2`, `Final`)
- Disclaimer legal (typically 4-6 líneas — usar el del banco)
- Footer confidencial

## Referencias

- Wall Street Prep, Training The Street conventions
- Cada banco tiene su templatebook interno — leer `memory/user_role.md` para overrides del banco del usuario si existen.
