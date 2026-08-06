---
description: Research a fondo con multi-fuente, citations, síntesis. Uso: /deep-research <tema>
---

# /deep-research

**Uso:** `/deep-research <tema>` — ej: `/deep-research European alternative dairy market 2025-2030`

## Proceso

1. **Cargá el skill built-in `deep-research`** — te da el framework de multi-source synthesis.

2. **Pedile al usuario contexto** (si falta):
   - ¿Para qué es? (IC memo, pitch, personal learning)
   - ¿Deadline? (afecta profundidad)
   - ¿Región/geografía específica?
   - ¿Fuentes preferidas o vedadas? (ej: no usar broker research del banco competidor)

3. **Ejecutá el research** siguiendo el framework `deep-research`:
   - Multi-source (mín 8-10 fuentes independientes)
   - Verificación cruzada de claims cuantitativos
   - Citations obligatorias con fecha
   - Distinguí "primary source" (SEC filing, company report) de "secondary" (broker research, news)

4. **Estructura del output** (guardar en `research/[topic-kebab]_[YYYYMMDD].md`):

```markdown
# [Topic]

*[Autor], [Fecha]. Sources: [N] primary, [M] secondary.*

## TL;DR (5 bullets max)
- ...

## Market Overview
- Size, growth, dynamics
- Key players + share
- Geographic breakdown

## Deep Analysis
- Structural trends (con datos)
- Competitive dynamics
- Regulatory / macro

## Investment Angles / Implications
- What this means for [investor type: PE, strategic, public equity]
- Actionable insights

## Risks / Unknowns
- Data gaps
- Contentious claims (donde fuentes discrepan)

## Sources
- [1] Company X 10-K FY24, filed Feb 2025, https://sec.gov/...
- [2] McKinsey report "Title", Jun 2024, https://...
- [3] ...
```

5. **Al terminar**: preguntá si quiere que el output alimente un `/ic-memo`, `/company-profile`, o `/pitch-deck`.

## Reglas

- **NUNCA inventes números.** Si no hay fuente, marcá `[NEEDS SOURCE]` y avisá al usuario.
- **NUNCA cites sin URL/fecha.** Todo claim tiene fuente verificable.
- **Distinguí fact vs opinion vs speculation.** Fact = número/evento verificable. Opinion = view del analista/broker. Speculation = "we may see...".
- **Time-stamp los datos.** Un dato de 2019 en un research de 2026 debe explicitar el año.
- Si el research toma >10 min, avisá al usuario que va a tardar y pedí que lo dejes correr.
