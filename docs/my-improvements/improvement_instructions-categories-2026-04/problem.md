# Problem – Instructions Categories 2026-04 (shared-instructions)

## Ausgangslage

Die geteilten Copilot-Instructions (in jedem Projekt per Symlink/Kopie
verfügbar) haben bisher nur **zwei** Doku-Kategorien gekannt:

- `docs/my-features/feature_<name>/` — neue Features
- `docs/my-bugs/bug_<name>/` — Bugs

Diese binäre Aufteilung ist zu grob:

1. **Refactorings, Performance-Tuning, Dependency-Hygiene, Security-Hardening
   und Tooling-Änderungen** sind weder neue Features noch Bugfixes — sie
   landen aktuell entweder in `my-features` (semantisch falsch) oder werden
   gar nicht dokumentiert.
2. Der Begriff **"Bug"** ist umgangssprachlich; im Engineering-Standard
   spricht man eher von **"Defect"** (z. B. ITIL/IEEE 1044).
3. Wer eine reine Improvement-Iteration macht (z. B. Renovate-Sammelbump),
   muss aktuell entweder den Feature-Schema dehnen oder es bleibt
   undokumentiert.

## Konkrete Probleme

- Inkonsistente Doku-Praxis zwischen Repos (Docs-Article, board-bff …).
- Unklare Klassifikation für Mischfälle (z. B. "Security-Patch" — Feature
  oder Bug?).
- Schwerer auffindbar in Reviews: Was ist ein bewusster Refactor, was ist
  ein neues Feature?

## Warum jetzt?

Im Zuge des großen Dependency-Hygiene-PRs in den Schwester-Repos
(Docs-Article, board-bff, Paratrooper-DOS) brauchten wir einen Ordner für
`improvement_deps-hygiene-2026-04`. Diese Iteration zementiert den Standard,
damit zukünftige Improvements konsistent abgelegt werden.
