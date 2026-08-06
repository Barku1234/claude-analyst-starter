---
description: M&A buy-side target screening por tesis. Uso: /target-screening <tesis>
---

# /target-screening

**Uso:**
- `/target-screening "US mid-market CPG snacks for PE roll-up"`
- `/target-screening "European SaaS vertical, $50-200M ARR, growth 30%+"`
- `/target-screening "Distressed retailers, likely restructuring 12 months"`

Genera universe filtrado + short-list ranked de targets M&A alineados con una tesis.

## Skills

- `ib-persona`
- `financial-modeling` (para calcs de fit)
- `deep-research` (para pull data)

## Proceso

1. **Traduce la tesis a criterios concretos** con el usuario:
   - Geography (US, EU, LatAm, APAC, global)
   - Sector / sub-sector (SIC codes / GICS)
   - Size (revenue range, EBITDA range, EV range)
   - Growth profile (CAGR range)
   - Margin profile
   - Ownership (private/public/PE-owned/family)
   - Recent activity (recently raised? acquisitive? divestments?)
   - Any "must have" (customer type, tech stack, regulation status)
   - Any "must NOT have" (concentrated customer, unresolved lawsuit, unionized)

2. **Fuentes** (usar en cascada):
   - Capital IQ / PitchBook screener (si acceso)
   - SEC EDGAR (US public)
   - Company websites, LinkedIn, industry associations
   - Recent M&A news (last 24 months) para identificar "who's buying/selling in space"
   - Broker research on sector para peer set

3. **Build universe (long list, 30-100 targets)**:

   Guardar en `research/[Thesis-slug]_UNIVERSE_[YYYYMMDD].xlsx`:

   ```
   Company | Country | Sub-sector | Revenue | EBITDA | Growth | Ownership | Founded | Notes
   ```

4. **Filter to short-list (10-20)**:

   Aplicar criterios rank:
   - **Fit score** (0-10): qué tan bien encaja con tesis
   - **Actionability** (High/Med/Low): posible target de M&A? Owners known to be considering exit?
   - **Deal readiness** (High/Med/Low): financials clean? Sponsor-owned? Founder-led?

   Guardar en `research/[Thesis-slug]_SHORTLIST_[YYYYMMDD].xlsx`.

5. **Deep-dive top 3-5**:

   Para cada uno, corré `/company-profile` → guardar en `research/[thesis-slug]/[target].md`.

6. **Recomendación al final** (memo corto):

   Guardar en `research/[Thesis-slug]_RECOMMENDATION_[YYYYMMDD].md`:

   ```markdown
   # Target Screening: [Thesis]
   
   *[Date]. Analyst: [User]*
   
   ## Methodology
   
   Universe screened: [N] companies matching [criteria X, Y, Z].
   Short-list applied: [criteria].
   Top-ranked: [M] targets.
   
   ## Top Targets (ranked)
   
   ### 1. [TargetCo A] — Score 9.2/10
   - **Fit**: [1-2 lines why]
   - **Financials**: $[X]M revenue, [Y]% growth, [Z]% EBITDA margin
   - **Ownership**: [PE-owned / founder-led / public]
   - **Actionability**: [High — sponsor exited Fund V vintage, likely 12-18m timeline]
   - **Next step**: [Approach through banker X / conference Y / cold outreach]
   
   ### 2. [TargetCo B] — Score 8.7/10
   ...
   
   ### 3. [TargetCo C] — Score 8.5/10
   ...
   
   ## Watch List (secondary)
   
   [3-5 targets with lower actionability but strategic fit]
   
   ## Discarded (top exclusions)
   
   - [Company X]: excluded because [reason]
   - [Company Y]: too large ([$Z]Bn revenue)
   - [Company Z]: recently acquired ([Date])
   
   ## Recommended Approach
   
   [2-3 sentences: how to approach top-ranked, timeline, resources needed]
   ```

## Output esperado

```
Target screening complete.

Files:
  research/us-cpg-snacks_UNIVERSE_20260805.xlsx      (85 companies)
  research/us-cpg-snacks_SHORTLIST_20260805.xlsx     (18 targets, ranked)
  research/us-cpg-snacks_RECOMMENDATION_20260805.md  (memo, 3 top-picks)
  research/us-cpg-snacks/[3 profiles for top-picks]

Top 3 (fit score >8.5):
  1. TargetCo A - $180M rev, PE-owned Fund V vintage
  2. TargetCo B - $220M rev, founder-led (78yo, no succession)
  3. TargetCo C - $340M rev, family-owned, hired banker Q1

Next: recommend outreach through [conference / banker introductions].

¿Querés que profundice en top-3, arme LBO screening en cada uno, o refine criteria y re-corra?
```

## Reglas

- **NUNCA claims sin fuente.** Ownership status, revenue, growth — todo verificable.
- **NUNCA speculate en confidential info** ("we heard they're exploring") sin marcarlo como rumor.
- **Actionability matters more than fit** en un screening. Un target 10/10 fit que no se vende no sirve.
- **Considerá sub-scale plays** (roll-up strategy) — a veces 5 targets de $50M cada uno son más viable que 1 de $250M.
