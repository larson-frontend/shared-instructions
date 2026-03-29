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
- TypeScript `strict` Mode ist Pflicht.
- Zod für Runtime-Validierung an Systemgrenzen.

## Commit-Konventionen

Commit-Messages folgen dem Conventional Commits Format:

- `feat: ...` — neues Feature
- `fix: ...` — Bugfix
- `docs: ...` — Dokumentation
- `chore: ...` — Maintenance
- `refactor: ...` — Code-Umbau ohne Verhaltensänderung

## Git Workflow

1. Niemals direkt auf `develop` oder `main` pushen.
2. Feature-Arbeit auf Feature-Branch aus `develop`.
3. PR von Feature-Branch → `develop`, dann `develop` → `main`.
4. Jeder PR braucht Code Review.
5. Nach Merge auf `main`: semantic-release übernimmt alles automatisch.

## Review Rules

- Findings zuerst, Zusammenfassung danach.
- Verweise bei Erklärungen immer auf konkrete Dateien.
- Risiken und fehlende Tests explizit benennen.

## Testing Rules

- Nach jeder Code-Änderung: Bestehende Tests prüfen, ggf. neue schreiben.
- E2E-Tests für User-Flows (Cypress, Playwright).
- MSW-Mock-Handler für neue API-Calls ergänzen.
- Vor dem Commit: Tests müssen grün sein.

## Documentation Rules

- Neue Features dokumentieren, wenn sie für andere relevant sind.
- Änderungen an `.vscode/` oder `.github/` im PR begründen.

### Feature- / Bug-Dokumentation

Am Ende jeder abgeschlossenen Aufgabe den User fragen:
> **„Soll ich das als Feature oder Bug dokumentieren?"**

Struktur: `docs/my-features/feature_<name>/` bzw. `docs/my-bugs/bug_<name>/`

Jeder Ordner enthält **5 Pflicht-Dateien**:

| Datei | Inhalt |
|-------|--------|
| `specifications.md` | Feature-Name, Ziel, Must-Have / Nice-to-Have, API-Endpunkte, Datenmodell |
| `problem.md` | Ausgangslage, konkrete Probleme, warum das Feature nötig ist |
| `solution.md` | Architektur, BFF/FE/DB-Änderungen, betroffene Dateien, technische Details |
| `progress.md` | Status, erledigte [x] + offene [ ] Schritte, Branch-Namen |
| `history.json` | JSON-Array: `{ step, date, action, details, commit, repo }` pro Schritt |

## Lokale Entwicklung

- Frontend mit Mocks: `npm run dev:mock` (MSW)
- Frontend mit BFF: `VITE_API_BASE_URL=http://localhost:3001 npm run dev`
- BFF mit Mock Mode: `ENABLE_MOCK_MODE=true npm run dev`
- BFF mit DB: `npm run dev`
