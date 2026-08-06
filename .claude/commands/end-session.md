---
description: Al cerrar sesión — analizá lo hecho, actualizá memoria, guardá aprendizajes.
---

# /end-session

## Paso 1 — Analizar la sesión

Revisá el contexto de la conversación de esta sesión. Identificá:

- **Qué se hizo**: archivos creados/editados en `research/`, `models/`, `decks/`
- **Decisiones tomadas**: cosas que valen para el futuro (convenciones, criterios, choices no obvias)
- **Aprendizajes**: cosas que salieron mal o al revés de lo esperado
- **Pendientes**: cosas que quedaron sin cerrar
- **Feedback del usuario**: correcciones o preferencias nuevas expresadas durante la sesión

## Paso 2 — Actualizar memoria

Para cada tipo de aprendizaje, escribí (o actualizá) un archivo en `memory/` con el formato:

```markdown
---
name: tipo-descripcion-corta
description: una línea de qué es
metadata:
  type: user | feedback | project | decision | reference | lesson
---

Contenido de la memoria.
```

Después actualizá `memory/MEMORY.md` con una línea por memoria nueva bajo la sección correspondiente.

**Reglas:**
- **No dupliques**: si ya existe una memoria del mismo tema, actualizala en vez de crear otra.
- **No guardes trivialidades**: solo cosas que valgan para futuras sesiones. "Editamos comps.xlsx" es contenido, no memoria. "El MD odia DCFs con TGR > 3%" es memoria.
- **No guardes info que se deriva del código/archivos**: si está en un `.xlsx` o en `git log`, no lo pongas en memoria.
- **Convertí fechas relativas a absolutas**: "el martes" → "2026-08-05".

## Paso 3 — Mostrar resumen al usuario

Reportá:

```
Sesión guardada.

**Lo que se hizo:**
- [archivo 1] — [1 línea]
- [archivo 2] — [1 línea]

**Memoria actualizada:**
- ✍️  [nueva memoria 1]
- ✍️  [nueva memoria 2]

**Pendientes para próxima sesión:**
- [ ] [pendiente]

Nos vemos.
```

## Paso 4 — Opcional: commit git

Si es un git repo y el usuario tiene `research/` o `models/` con cambios, **preguntá** si quiere hacer commit local (nunca push automático). Si sí:

```bash
git add memory/ research/ models/ decks/
git commit -m "session: [resumen 1 línea]"
```

**NUNCA hagas push a un repo público**: los outputs (research, models, decks) pueden tener info confidencial del banco. Push manual, decisión del usuario.
