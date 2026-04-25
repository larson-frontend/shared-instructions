# Lösung – Instructions Categories 2026-04 (shared-instructions)

## Strategie

Erweitere die zentrale `Feature/Bug-Doku`-Section in
`.github/copilot-instructions.md` um eine **dritte** Kategorie und
benenne `Bug → Defect` (Engineering-Sprech), wobei `my-bugs/` als
Legacy-Alias erhalten bleibt.

## Neue Kategorien

| Kategorie | Ordner | Zweck |
|-----------|--------|-------|
| **Feature** | `docs/my-features/feature_<name>/` | Neues fachliches Feature, neue UI/Endpunkt |
| **Improvement** | `docs/my-improvements/improvement_<name>/` | Refactoring, Performance, Deps-Hygiene, Tooling, Security-Hardening |
| **Defect** | `docs/my-defects/defect_<name>/` | Bug, Regression, fehlerhaftes Verhalten |

`docs/my-bugs/` bleibt als Legacy-Alias erhalten — neue Defekte gehen
nach `my-defects/`.

## Betroffene Dateien

| Datei | Änderung |
|------|----------|
| `.github/copilot-instructions.md` | Section `### Feature- / Bug-Dokumentation` → `### Feature- / Improvement- / Defect-Dokumentation` |

Parallel wird in den Schwester-Repos die jeweilige
`.github/copilot-instructions.md` mitgepflegt (siehe deren Branches
`chore/deps-hygiene-2026-04`).

## Pflicht-Dateien pro Eintrag (unverändert, plus Lockerung)

5 Pflicht-Dateien (`specifications.md`, `problem.md`, `solution.md`,
`progress.md`, `history.json`). NEU: Vor dem Merge müssen
**mindestens** `problem.md` + `solution.md` vorhanden sein. Die übrigen
drei dürfen für reine Improvements (z. B. Renovate-Sammelbumps)
nachgereicht werden.

## Folgemaßnahmen

- Schwester-Repos (Docs-Article, board-bff) übernehmen die Klassifikation
  in ihren eigenen `.github/copilot-instructions.md` (im selben PR-Pool).
- Dieses Repo wird per Symlink in neue Projekte eingebunden, neue Repos
  erben die Standards automatisch.
