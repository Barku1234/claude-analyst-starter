# Memoria — índice

> Índice compacto. Una línea por memoria; el detalle vive en cada archivo.
> Claude actualiza este archivo automáticamente al aprender cosas nuevas.
> Empezá vacío — se va llenando solo con el uso.

## Perfil del usuario
_(vacío — completar con `/onboard-analyst`)_

## Proyectos activos
_(vacío — se llena a medida que empezás deals/research)_

## Decisiones tomadas
_(vacío)_

## Lecciones aprendidas
_(vacío)_

## Feedback / preferencias
_(vacío)_

## Referencias
_(vacío — links a Bloomberg terminals, drive folders, templates internos del banco, etc.)_

---

## Cómo funciona esta carpeta

Cada memoria vive en su propio archivo `.md` con este formato:

```markdown
---
name: nombre-kebab-case
description: una-linea que Claude usa para decidir cuándo cargarla
metadata:
  type: user | feedback | project | decision | reference | lesson
---

Contenido de la memoria acá.
```

Y se registra como una línea en este índice arriba:

```markdown
- [Título](nombre-archivo.md) — one-line hook
```

**Ejemplos** en `memory/examples/` (no se cargan, solo referencia).

**Nunca lo edites a mano** — dejá que Claude lo haga durante `/end-session` o cuando algo importante ocurre.
