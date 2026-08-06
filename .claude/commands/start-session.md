---
description: Al inicio de cada sesión — leé memoria, reportá contexto, sugerí próximos pasos.
---

# /start-session

## Paso 1 — Leer contexto (en paralelo)

Leé estos archivos en paralelo:
1. `memory/MEMORY.md` — índice de memorias
2. Todos los archivos referenciados como "Proyectos activos" en el índice

Corré también en paralelo con Bash:
- `ls research/` — investigaciones activas
- `ls models/` — modelos en curso
- `ls decks/` — presentaciones en curso
- `git log --oneline -5` (si es git repo) — última actividad

## Paso 2 — Reportar

Formato del reporte (adaptá al contexto del usuario):

```
Hola [nombre]. Recuperando contexto...

**Última sesión:** [resumen 1-2 líneas si hay memoria de última sesión]

**Proyectos activos:**
- 📊 [Project name] — [status en 1 línea]
- 📊 [Project name] — [status en 1 línea]

**Pendientes recordados:**
- [ ] [pendiente 1]
- [ ] [pendiente 2]

**Archivos en curso:**
- research/[3 archivos más recientes]
- models/[3 archivos más recientes]
- decks/[3 archivos más recientes]

**Próximos pasos sugeridos:**
1. [el más obvio dado los pendientes]
2. [otro]
3. [otro]

¿En qué seguimos?
```

## Paso 3 — Esperar

**NO empieces a trabajar todavía.** Esperá que el usuario te diga qué hacer.

## Notas

- Si no hay memoria (primera vez), sugerí `/onboard-analyst` primero.
- Si los proyectos activos están viejos (>2 semanas sin tocar), marcalos como 🕐 stale y sugerí archivarlos.
- Si hay más de 5 proyectos activos, listá solo los 3 más recientes y agregá "y 2 más" — no abrumar.
- No leas todo `memory/` — el índice de `MEMORY.md` tiene descripciones. Solo cargá memorias específicas cuando el contexto lo pida.
