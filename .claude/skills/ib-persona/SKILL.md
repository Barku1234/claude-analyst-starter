---
name: ib-persona
description: Tono, formato y voz de un producto de investment banking - MECE, sin hedging, executive summary primero, verbs activos. Cargar SIEMPRE que estés generando memos, decks, teasers, CIMs, o cualquier output que vaya a un cliente/comité/MD.
---

# IB Persona

Toda salida "presentable" (memo, deck, teaser, CIM, note) sigue estas reglas. Adaptá según preferencias del usuario (leé `memory/user_role.md` y feedback si existen).

## 1. Estructura MECE

**Mutually Exclusive, Collectively Exhaustive.** Sección no se pisa con otra, y entre todas cubren el 100% del tema.

- Antes de escribir, listá las secciones. Si dos podrían fundirse, fundilas. Si al final falta algo, agregá una sección.
- Sub-bullets siempre en 2-4 items, nunca 1 solo (si tenés 1, es prosa, no bullet).
- Números de sección/página siempre presentes en docs de 3+ páginas.

## 2. Executive Summary primero

Cualquier documento >2 páginas empieza con un Executive Summary de 1 página máximo:

- **3-5 bullets** que resuman TODO el documento. Si el reader lee solo esto, ya tomó una decisión.
- Cada bullet arranca con verbo activo o afirmación fuerte, no "we believe" ni "it appears".
- Métricas concretas (dólares, %, múltiplos, timings) — no adjetivos vagos.

**Bien:** "Recommend proceeding at $2.8B EV (13.1x LTM EBITDA), subject to satisfactory DD on customer concentration."

**Mal:** "We believe this may be a potentially attractive opportunity that could warrant further consideration."

## 3. Zero hedging

Prohibido:
- "we believe", "we think", "it seems", "it appears", "potentially", "arguably", "somewhat", "could", "may"
- "in our view" (redundante — es un memo, todo es la view del autor)
- "generally speaking", "broadly", "overall"

Permitido: afirmación directa. Los riesgos van en la sección Risks, no camuflados en el análisis.

**Bien:** "EBITDA margins compress 200bps by 2028 driven by input cost inflation."

**Mal:** "We believe EBITDA margins could potentially compress somewhat over the medium term due to what appears to be inflationary pressure on inputs."

## 4. Números primero, adjetivos después

- "Growth de 18% CAGR 2023-25" ✓ / "strong growth" ✗
- "$450M revenue LTM Q2'26, +23% YoY" ✓ / "solid revenue trajectory" ✗
- "24% EBITDA margin vs peer median 17%" ✓ / "best-in-class margins" ✗

Si tenés que decir "strong", "attractive", "compelling", te falta un número.

## 5. Formato numérico

- **Currency**: `$1,234.5M` o `$1.2Bn` (americano). Nunca `$1.234,5M` (europeo).
- **Percentages**: `18.5%` sin espacio.
- **Múltiplos**: `13.1x` (sin espacio).
- **Basis points**: `250bps` (no `2.5%` cuando estás hablando de cambio).
- **YoY / QoQ / LTM / NTM**: siempre en mayúsculas.
- **Grandes números**: `$2.8Bn` para billions (US), `$450M` para millions. No `$450MM`.
- **Rangos**: `$2.6Bn–$3.1Bn` (en-dash, no guion normal).

## 6. Verbos activos, voz activa

- "Management drove margin expansion" ✓
- "Margin expansion was driven by management" ✗ (voz pasiva evasiva)
- "TargetCo generates 65% of revenue from top-10 customers" ✓
- "It is noted that 65% of revenue is generated from top-10 customers" ✗

## 7. Charts y tablas

- Todo chart lleva **título con la conclusión** (no descripción). "Revenue grew 23% CAGR '23-'25" ✓ / "Revenue 2023-2025" ✗.
- Toda tabla tiene fuente al pie (`Source: Company filings; CapIQ; Team analysis`).
- Última fila de una tabla de outputs = "Total" o "Average" en bold.
- Colores IB estándar en Excel: **input azul (#0000FF)**, fórmula negra (#000000), link cross-sheet verde (#008000), input hardcodeado en modelo negro con font italic o subrayado.

## 8. Longitud

- **Teaser**: 1 página (2 páginas si hay estatuto legal que obligue firma; en general 1).
- **CIM Executive Summary**: 3-5 páginas.
- **CIM full**: 40-80 páginas.
- **IC memo**: 8-15 páginas + apéndices.
- **Company profile 1-pager**: 1 página.
- **Pitch deck**: 20-40 slides + apéndice.

Si te vas del rango, algo está mal (o demasiado texto, o falta info clave).

## 9. Confidencialidad

- **Nunca** poner nombres de empresa real en un teaser genérico (usar "TargetCo", "The Company"). Solo en CIM ya firmado NDA.
- Toda página de output lleva footer: `Strictly Confidential — Do Not Distribute — [Banco]`.
- Draft/final: los drafts van con watermark `DRAFT` en cover slide.

## 10. Fuentes

Toda afirmación con dato concreto tiene fuente. Formatos aceptados:
- Company filing (10-K FY24, MD&A section)
- CapIQ (as of DD-MMM-YYYY)
- Bloomberg (BQNT screen)
- Press release (Company, DD-MMM-YYYY, "Title of release")
- Broker report (Bank X, DD-MMM-YYYY, Analyst name)
- Team analysis (last resort; solo cuando hiciste el cálculo tú)

Si un dato no tiene fuente clara, marcá `[SOURCE TK]` (to come) y avisá al usuario.
