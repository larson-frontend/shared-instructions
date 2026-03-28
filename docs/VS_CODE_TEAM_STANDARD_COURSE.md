# VS Code Team Standard: Wie Teams eine gemeinsame Dev-Umgebung in VS Code aufbauen

> **Dieses Repository ist die Referenz-Implementierung zu diesem Artikel.**
> Alle beschriebenen Dateien (`.vscode/`, `.github/`, `.editorconfig`) sind im Repo enthalten und sofort nutzbar.
> Clone → anpassen → commiten.

---

## Worum es in diesem Artikel geht

Dieser Artikel zeigt, wie ein Team eine einheitliche Entwicklungsumgebung in VS Code aufbaut und dauerhaft gemeinsam pflegt.

Der Fokus liegt auf fünf Bausteinen:

1. Gemeinsame Workspace-Settings in `.vscode/`
2. Gemeinsame GitHub Copilot Instructions in `.github/`
3. Gemeinsame Formatierungs- und Qualitätsregeln
4. Gemeinsame Debugging-Profile
5. Erweiterte Agent-Workflows mit Custom Agents und spezialisierten Instructions

Das Ziel ist nicht nur, dass "alles funktioniert", sondern dass alle Entwickler im Team dieselben Standards, dieselbe Toolchain und dieselben AI-Konventionen verwenden.

Der Text ist als praxisnaher Leitfaden für Leser gedacht, die in ihrem Team eine belastbare Norm für Editor, Debugging, Formatierung und AI-gestützte Workflows etablieren wollen.

---

## Für wen dieser Artikel gedacht ist

Dieser Artikel ist besonders relevant für:

- Tech Leads, die Teamstandards definieren
- Senior Developers, die Onboarding und Produktivität verbessern wollen
- Teams, die GitHub Copilot, Custom Agents und gemeinsame VS Code Settings sauber versionieren möchten
- Projektverantwortliche, die wiederholbare Entwicklungsumgebungen über mehrere Repositories hinweg aufbauen

---

## Warum ein Team-Standard wichtig ist

Ohne gemeinsame Norm entstehen typische Probleme:

- unterschiedliche Formatter erzeugen unnötige Diffs
- Debug-Konfigurationen funktionieren nur auf einzelnen Rechnern
- neue Teammitglieder brauchen zu lange für das Setup
- Copilot oder andere Agents liefern unterschiedliche Ergebnisse je nach persönlicher Einstellung
- Reviews werden unklar, weil jeder mit einer anderen lokalen Umgebung arbeitet

Ein gemeinsamer VS Code Standard löst genau diese Probleme.

Der Grundsatz ist einfach:

> Das Repository beschreibt die Arbeitsumgebung so weit wie möglich mit.

---

## Was Leser konkret mitnehmen

Nach diesem Artikel weiß ein Team:

1. eine gemeinsame `.vscode/settings.json` definieren
2. Formatierung, Linting und Save-Verhalten standardisieren
3. Debugging-Profile versionieren
4. Copilot Instructions teamweit teilen
5. file-spezifische Instructions für Teilbereiche definieren
6. Custom Agents für Spezialfälle bereitstellen
7. klare Governance für Änderungen an der Dev-Umgebung etablieren

---

## Zielbild: Repository-Struktur

Ein praxistauglicher Aufbau sieht so aus:

```text
your-project/
├── .github/
│   ├── copilot-instructions.md
│   ├── instructions/
│   │   ├── backend.instructions.md
│   │   ├── frontend.instructions.md
│   │   └── testing.instructions.md
│   ├── agents/
│   │   ├── react-agent.agent.md
│   │   └── review-agent.agent.md
│   └── prompts/
│       └── release-check.prompt.md
├── .vscode/
│   ├── settings.json
│   ├── launch.json
│   ├── tasks.json
│   └── extensions.json
├── docs/
│   └── engineering-standards.md
├── src/
└── README.md
```

Wenn ihr Shared Instructions über mehrere Projekte hinweg nutzen wollt, könnt ihr zusätzlich ein separates Repo wie `shared-instructions/` pflegen und in die Projekte per Symlink oder als Nachbar-Repo einbinden.

---

## Baustein 1: Was gehört in `.vscode/`

Die `.vscode/` Dateien definieren das Verhalten des Editors für das gesamte Team.

### 1. `settings.json`

Hier landen Regeln für:

- Formatter
- Format on Save
- Linter-Verhalten
- Dateiende / Whitespace
- Standard-Interpreter oder Tool-Pfade
- Copilot Instructions Referenzen

### 2. `launch.json`

Hier liegen gemeinsame Debug-Profile, zum Beispiel:

- Frontend lokal starten
- Node.js Backend debuggen
- Java Spring Boot attachen
- Cypress oder Playwright Targets vorbereiten

### 3. `tasks.json`

Hier werden häufige Abläufe standardisiert:

- Dev-Server starten
- Tests ausführen
- Build starten
- Linting und Typecheck ausführen

### 4. `extensions.json`

Diese Datei definiert empfohlene Erweiterungen, damit alle dieselbe Werkzeugbasis haben.

---

## Baustein 2: Beispiel für gemeinsame VS Code Settings

Ein solides Team-Beispiel:

```json
{
  "editor.formatOnSave": true,
  "editor.codeActionsOnSave": {
    "source.fixAll.eslint": "explicit"
  },
  "files.eol": "\n",
  "files.insertFinalNewline": true,
  "files.trimTrailingWhitespace": true,
  "typescript.tsdk": "node_modules/typescript/lib",
  "eslint.validate": ["javascript", "javascriptreact", "typescript", "typescriptreact"],
  "github.copilot.chat.codeGeneration.useInstructionFiles": true,
  "github.copilot.chat.followUps": "always",
  "[typescript]": {
    "editor.defaultFormatter": "esbenp.prettier-vscode"
  },
  "[typescriptreact]": {
    "editor.defaultFormatter": "esbenp.prettier-vscode"
  },
  "[json]": {
    "editor.defaultFormatter": "esbenp.prettier-vscode"
  }
}
```

### Warum diese Regeln sinnvoll sind

- `formatOnSave` verhindert Style-Divergenzen
- `insertFinalNewline` und `trimTrailingWhitespace` reduzieren unnötige Diffs
- `typescript.tsdk` stellt sicher, dass das Team die Projekt-TypeScript-Version nutzt
- `eslint.validate` sorgt für konsistente Diagnose im Editor

Wichtig ist: Diese Regeln müssen zur echten Toolchain des Projekts passen. Niemals wahllos globale Lieblingssettings ins Repo schreiben.

---

## Baustein 3: Beispiel für empfohlene Extensions

```json
{
  "recommendations": [
    "esbenp.prettier-vscode",
    "dbaeumer.vscode-eslint",
    "ms-vscode.vscode-typescript-next",
    "github.copilot",
    "github.copilot-chat",
    "ms-playwright.playwright",
    "ms-azuretools.vscode-docker"
  ]
}
```

Der Zweck von `extensions.json` ist nicht, jeden persönlichen Wunsch abzubilden. Empfohlen werden nur Extensions, die für das Team wirklich Teil des Standards sind.

---

## Baustein 4: Debugging als Team-Standard

Viele Teams unterschätzen, wie wertvoll versionierte Debug-Profile sind.

Ein Beispiel für ein Node.js Backend plus Frontend:

```json
{
  "version": "0.2.0",
  "configurations": [
    {
      "name": "Frontend: Vite",
      "type": "node-terminal",
      "request": "launch",
      "command": "npm run dev",
      "cwd": "${workspaceFolder}/Docs-Article"
    },
    {
      "name": "BFF: Node Debug",
      "type": "node",
      "request": "launch",
      "runtimeExecutable": "npm",
      "runtimeArgs": ["run", "dev"],
      "cwd": "${workspaceFolder}/board-bff",
      "console": "integratedTerminal",
      "restart": true,
      "skipFiles": ["<node_internals>/**"]
    }
  ],
  "compounds": [
    {
      "name": "Start FE + BFF",
      "configurations": ["Frontend: Vite", "BFF: Node Debug"]
    }
  ]
}
```

### Gute Regeln für Team-Debugging

- Pfade immer relativ zum Workspace halten
- keine user-spezifischen absoluten Pfade einbauen
- Konfigurationen klar benennen
- Compound-Configs für häufige Team-Abläufe anlegen
- nur Debug-Profile versionieren, die im Alltag wirklich genutzt werden

---

## Baustein 5: GitHub Copilot Instructions als Team-Norm

Die gemeinsame AI-Norm gehört ins Repository.

Die wichtigste Datei ist:

```text
.github/copilot-instructions.md
```

Dort beschreibt ihr:

- Architektur-Grundsätze
- Branching- und Commit-Regeln
- Test-Erwartungen
- Review-Standards
- Dokumentationspflichten
- Team-Konventionen für Code-Generierung

### Beispiel für `copilot-instructions.md`

```md
# Team Copilot Instructions

## Ziel

Arbeite so, dass Änderungen klein, reviewbar und konsistent zum Projektstil bleiben.

## Coding Rules

- Verwende vorhandene Patterns vor neuen Abstraktionen.
- Halte Änderungen minimal und fokussiert.
- Ändere keine öffentlichen APIs ohne klaren Grund.
- Nach UI-Änderungen müssen E2E-Tests geprüft werden.

## Review Rules

- Findings zuerst, Zusammenfassung danach.
- Verweise bei Erklärungen immer auf konkrete Dateien.

## Documentation Rules

- Nach abgeschlossenen Aufgaben immer fragen, ob als Feature oder Bug dokumentiert werden soll.
```

Diese Datei ist eure zentrale "Policy Engine" für AI-gestützte Zusammenarbeit.

---

## Baustein 6: File-spezifische Instructions

Eine einzige globale Copilot-Datei reicht für große Projekte oft nicht aus.

Dafür nutzt man zusätzliche Instructions in:

```text
.github/instructions/
```

Beispiel:

### `frontend.instructions.md`

```md
---
applyTo: "src/**/*.tsx"
description: "Use when working on React UI, component state, styling, and frontend tests"
---

## Frontend Rules

- Bevorzuge bestehende UI-Patterns.
- Füge Tests für neue Interaktionen hinzu.
- Verändere keine Designsprache ohne Aufgabe.
```

### `backend.instructions.md`

```md
---
applyTo: "server/**/*.ts"
description: "Use when working on API routes, services, validation, and backend architecture"
---

## Backend Rules

- Input immer validieren.
- Business-Logik in Services halten.
- Fehler mit einheitlichen Error-Objekten behandeln.
```

### Was das Team daraus lernt

- globale Regeln bleiben schlank
- bereichsspezifische Regeln bleiben näher am Code
- weniger unnötiger Kontext für den Agenten
- bessere Antworten pro Dateityp

---

## Baustein 7: Custom Agents für Advanced Workflows

Wenn ein Team wiederkehrende Spezialaufgaben hat, reichen Instructions allein oft nicht aus. Dann sind Custom Agents sinnvoll.

Custom Agents liegen typischerweise hier:

```text
.github/agents/
```

### Beispiel: `review-agent.agent.md`

```md
---
name: Review Agent
description: "Use when reviewing pull requests, identifying risks, regressions, and missing tests"
tools: ["read_file", "grep_search", "get_errors"]
---

Du arbeitest wie ein strenger Reviewer.

- Fokussiere dich auf Bugs, Risiken und Regressionen.
- Priorisiere Findings nach Schweregrad.
- Halte die Zusammenfassung knapp.
```

### Beispiel: `react-agent.agent.md`

```md
---
name: React Agent
description: "Use when implementing React UI, component state, styling, and interaction flows"
tools: ["read_file", "apply_patch", "get_errors"]
---

Arbeite komponentenorientiert.

- Bewahre die bestehende Designsprache.
- Ergänze Tests bei neuen User Flows.
- Vermeide unnötige Re-Renders und API-Brüche.
```

### Wann ein eigener Agent sinnvoll ist

- wenn ein Team getrennte Rollen simulieren will
- wenn bestimmte Toolsets eingeschränkt werden sollen
- wenn Review, Coding und Analyse klar getrennt sein sollen
- wenn Spezialdomänen wie React, Java oder Testing wiederholt vorkommen

---

## Baustein 8: Gemeinsame Formatierungsregeln als Teamvertrag

Editor-Settings allein reichen nicht. Der Teamstandard braucht eine technische und soziale Ebene.

### Technische Ebene

- Prettier oder vergleichbarer Formatter im Repo
- ESLint oder vergleichbare Lint-Regeln im Repo
- `.editorconfig`, wenn nötig
- VS Code Settings als Komfortschicht

### Soziale Ebene

- Das Team akzeptiert automatische Formatierung
- Diskussionen über Stil werden in Tool-Regeln übersetzt
- PRs diskutieren Logik, nicht Leerzeichen

Ein guter Standard lautet:

> Was automatisch entschieden werden kann, wird automatisiert.

---

## Baustein 9: Team-Rollen und Verantwortlichkeiten

Damit die gemeinsame Dev-Umgebung nicht verwahrlost, braucht sie Ownership.

### Empfohlene Rollen

1. Engineering Owner für `.vscode/` Standards
2. AI Owner für `.github/` Instructions und Agents
3. Reviewer für Governance-Änderungen

### Regeln für Änderungen

- Änderungen an `.vscode/` nur per PR
- Änderungen an `.github/` nur per PR
- jede Änderung braucht Begründung im PR
- Breaking Changes in der Team-Doku festhalten

---

## Baustein 10: Beispiel für einen vollständigen Team-Standard

### `.vscode/settings.json`

```json
{
  "editor.formatOnSave": true,
  "files.insertFinalNewline": true,
  "files.trimTrailingWhitespace": true,
  "eslint.validate": ["typescript", "typescriptreact"],
  "github.copilot.chat.codeGeneration.useInstructionFiles": true,
  "[typescript]": {
    "editor.defaultFormatter": "esbenp.prettier-vscode"
  },
  "[typescriptreact]": {
    "editor.defaultFormatter": "esbenp.prettier-vscode"
  }
}
```

### `.vscode/extensions.json`

```json
{
  "recommendations": [
    "github.copilot",
    "github.copilot-chat",
    "esbenp.prettier-vscode",
    "dbaeumer.vscode-eslint"
  ]
}
```

### `.vscode/launch.json`

```json
{
  "version": "0.2.0",
  "configurations": [
    {
      "name": "Node API",
      "type": "node",
      "request": "launch",
      "runtimeExecutable": "npm",
      "runtimeArgs": ["run", "dev"],
      "cwd": "${workspaceFolder}/server"
    }
  ]
}
```

### `.github/copilot-instructions.md`

```md
# Repo Standards

- Arbeite mit kleinen, reviewbaren Änderungen.
- Verwende bestehende Patterns.
- Ergänze Tests bei UI- oder API-Verhalten.
- Dokumentiere neue Features auf Wunsch des Users.
```

### `.github/agents/react-agent.agent.md`

```md
---
name: React Agent
description: "Use when building or refactoring React features in this repository"
---

Arbeite pragmatisch und bewahre die UI-Konventionen des Projekts.
```

Dieses Beispiel ist klein, aber vollständig genug, um als Teamstandard zu funktionieren.

---

## Baustein 11: Einführungsplan für ein echtes Team

### Phase 1: Minimum Standard

Einführen:

- `.vscode/settings.json`
- `.vscode/extensions.json`
- `.github/copilot-instructions.md`

Noch nicht einführen:

- zu viele Spezial-Agenten
- zu viele file-spezifische Instructions
- komplexe Hooks oder experimentelle Automationen

### Phase 2: Bereichsspezifische Regeln

Einführen:

- `.github/instructions/frontend.instructions.md`
- `.github/instructions/backend.instructions.md`
- `.vscode/launch.json`

### Phase 3: Advanced Setup

Einführen:

- `.github/agents/`
- standardisierte Prompts
- geteilte Task-Konfigurationen
- optional zentrale Shared-Instructions Struktur über mehrere Repos

---

## Baustein 12: Häufige Fehler

### Fehler 1: Zu viele Regeln auf einmal

Wenn ihr direkt mit zehn Custom Agents startet, benutzt sie niemand konsistent. Erst die Basis stabilisieren.

### Fehler 2: Persönliche Präferenzen im Teamstandard

Nicht jede bevorzugte Extension oder jede persönliche Keybinding-Idee gehört in die Team-Defaults.

### Fehler 3: Instructions ohne klare Beschreibung

Wenn `description` unklar ist, werden file-spezifische Instructions und Agents schlechter gefunden.

### Fehler 4: Absolute Pfade in Debug-Configs

Teamstandards müssen auf jedem Rechner funktionieren.

### Fehler 5: Kein Owner für die Umgebung

Was niemand pflegt, veraltet schnell.

---

## Baustein 13: Governance-Checkliste

Bevor ihr eine gemeinsame Dev-Umgebung merged, prüft:

1. Funktionieren die Settings auf einem frischen Rechner?
2. Sind alle Pfade relativ?
3. Sind Formatter und Linter wirklich Projektstandard?
4. Sind Debug-Profile für mehrere Teammitglieder nachvollziehbar?
5. Sind Copilot Instructions konkret und wartbar?
6. Haben file-spezifische Instructions sinnvolle `applyTo` Muster?
7. Haben Custom Agents eine klare Aufgabe?

---

## Fazit: Die eigentliche Team-Norm

Eine gute geteilte VS Code Umgebung ist kein Sammelbecken für Einstellungen. Sie ist eine bewusst gepflegte Engineering-Norm.

Die beste Version dieses Standards hat drei Eigenschaften:

1. Sie reduziert Reibung im Alltag.
2. Sie ist für neue Teammitglieder schnell verständlich.
3. Sie zwingt niemanden in unnötige Sonderfälle.

Wenn ihr diese Linie haltet, werden `.vscode/` und `.github/` nicht nur Konfigurationsordner, sondern ein echter Teil eurer Engineering-Kultur.

---

## Nächste praktische Schritte

Wenn du diesen Kurs im Team umsetzen willst, dann gehe in genau dieser Reihenfolge vor:

1. Standard für `.vscode/settings.json` definieren
2. `extensions.json` mit echten Team-Extensions füllen
3. erstes `launch.json` für den Haupt-Run-Case anlegen
4. `copilot-instructions.md` für globale Regeln erstellen
5. zwei bis drei file-spezifische Instructions ergänzen
6. erst danach Custom Agents für Spezialfälle einführen

Damit entsteht ein sauberer, belastbarer Standard statt einer zufälligen Sammlung von Tool-Configs.