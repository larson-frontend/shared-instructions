# Team Copilot Instructions

## Ziel

Arbeite so, dass Änderungen klein, reviewbar und konsistent zum Projektstil bleiben.

## Architektur

Dieses Repository dient als zentraler Standard für VS Code Settings, AI Instructions und Custom Agents.
Es wird per Symlink oder Kopie in Projekte eingebunden.

## Coding Rules

- Verwende vorhandene Patterns vor neuen Abstraktionen.
- Halte Änderungen minimal und fokussiert.
- Ändere keine öffentlichen APIs ohne klaren Grund.
- Nach UI-Änderungen müssen E2E-Tests geprüft werden.

## Commit-Konventionen

Commit-Messages folgen dem Conventional Commits Format:

- `feat: ...` — neues Feature
- `fix: ...` — Bugfix
- `docs: ...` — Dokumentation
- `chore: ...` — Maintenance
- `refactor: ...` — Code-Umbau ohne Verhaltensänderung

## Review Rules

- Findings zuerst, Zusammenfassung danach.
- Verweise bei Erklärungen immer auf konkrete Dateien.
- Risiken und fehlende Tests explizit benennen.

## Documentation Rules

- Neue Features dokumentieren, wenn sie für andere relevant sind.
- Änderungen an `.vscode/` oder `.github/` im PR begründen.
