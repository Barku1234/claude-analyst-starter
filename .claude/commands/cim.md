---
description: Confidential Information Memorandum (CIM) completo. Uso: /cim <target>
---

# /cim

**Uso:** `/cim TargetCo` — genera CIM sell-side de 40-80 páginas.

## Skills

- `ib-persona`, `ic-memo-structure`, `financial-modeling`, `docx`

## Proceso

1. **Contexto obligatorio**:
   - Target real name (CIM va post-NDA, no anónimo)
   - Sector, sub-sector, geografía
   - Deal structure (100% sale / partial / recap)
   - Timeline (bid dates)
   - Management projections disponibles?
   - ¿Existe teaser previo con framework de highlights?

2. **Gathering**:
   - Leé todo lo previo en `research/`, `models/`
   - Corré `/deep-research` si falta contexto de mercado
   - Corré `/build-model` si falta modelo

3. **Estructura del CIM (40-80 páginas)**:

   ```
   1. Cover Page + Disclaimer (2p)
   2. Table of Contents (1p)
   3. Transaction Overview (2p)
      - Process, timeline, deal structure, contact info
   4. Executive Summary (3-5p)
      - Company snapshot, highlights, financial summary
   5. Company Overview (10-15p)
      - History, business model, products/services, customers
      - Segments breakdown
      - Manufacturing/operations
      - Technology / IP
      - Real estate
   6. Industry Overview (5-8p)
      - Market size, growth, trends
      - Competitive landscape (with market share chart)
      - Regulatory environment
   7. Business Model Deep-dive (5-8p)
      - Revenue model (recurring vs one-time, contracts)
      - Customer analysis (concentration, retention, LTV)
      - Go-to-market strategy
      - Pricing strategy
   8. Management Team (3-5p)
      - Org chart
      - Top 10 mgmt bios
      - Comp structure
   9. Financial Overview (10-15p)
      - Historical financials (5y)
      - Revenue/margin bridges
      - Working capital analysis
      - CapEx history + planned
      - Debt/capital structure
      - Projections (5y with assumptions)
   10. Investment Highlights (2p)
       - 5-7 pillars
   11. Next Steps + Bid Instructions (1p)
   12. Appendices (~30% of doc)
       - A: Detailed historical financials
       - B: Detailed projections + assumptions
       - C: Customer contracts (sanitized)
       - D: Real estate details
       - E: Compensation details
       - F: Legal structure / cap table
       - G: Data room index
   ```

4. **Escribí a `research/[Target]_CIM_[YYYYMMDD]_v1.docx`**:
   - Cover con branding del banco + confidentiality legend
   - Header/footer en cada página
   - TOC linkable
   - Charts embed
   - Watermark `DRAFT` si es v1/v2

5. **Reglas críticas CIM (más estricto que memo interno)**:
   - **Nunca inventes proyecciones** — vienen de management o disclose "team analysis"
   - **Nunca overstate**: si mgmt dice "we plan to grow 20%", vos ponés "management targets 20% growth" (transferencia de responsabilidad legal)
   - **Legal disclaimer** en cover + footer de sensitive sections
   - **Historical only from audited**: si dice 2023 revenue $X, viene del audited FS, no del CFO's slide
   - **Forward-looking statements** todos flagged con caveat

## Output esperado

```
CIM listo: research/TargetCo_CIM_20260805_v1.docx

Sections: 12 main + 7 apéndices
Total pages: [N] ([X] main body + [Y] apéndices)
Financial statements: 2021-2025 hist + 2026E-2030E projection

Confidentiality:
  ✓ Watermark DRAFT en todas las páginas
  ✓ Disclaimer legal en cover
  ✓ NDA reminder en footer

Content check:
  ✓ Executive Summary alineado con Investment Highlights section
  ✓ Financial numbers consistent con models/[X].xlsx
  ✓ Management team bios (10 bios)
  ⚠ Data room index (Appendix G) pending del cliente
  ✓ Customer analysis con top-10 (sanitized names)

Word count: ~[X],[Y]00 words

¿Querés que arme el mgmt presentation deck acompañante, o revise una sección específica?
```
