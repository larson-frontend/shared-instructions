---
applyTo: "src/**/*.tsx,src/**/*.jsx,src/components/**/*,src/features/**/*"
description: "Use when working on React UI, component state, styling, and frontend tests"
---

# Frontend Rules

## Komponenten

- Funktionale Komponenten mit Hooks bevorzugen.
- Bestehende UI-Patterns und Designsprache beibehalten.
- State minimal halten; erst liften wenn nötig.
- Props klar typisieren mit TypeScript Interfaces.

## Styling

- Bestehende Styling-Lösung des Projekts nutzen (CSS Modules, Tailwind, etc.).
- Keine neue Styling-Bibliothek ohne Absprache einführen.

## Testing

- Neue User-Interaktionen brauchen Tests (React Testing Library).
- Behavior testen, nicht Implementation.
- Accessibility (aria-Rollen, Labels) in Tests berücksichtigen.

## Performance

- Unnötige Re-Renders vermeiden.
- Expensive Berechnungen mit `useMemo` schützen.
- Listen mit stabilen Keys versehen.
