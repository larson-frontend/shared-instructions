# VS Code Team Standard

```
╔══════════════════════════════════════════════════════════════════╗
║                                                                  ║
║   ██╗   ██╗███████╗     ██████╗ ██████╗ ██████╗ ███████╗        ║
║   ██║   ██║██╔════╝    ██╔════╝██╔═══██╗██╔══██╗██╔════╝        ║
║   ██║   ██║███████╗    ██║     ██║   ██║██║  ██║█████╗          ║
║   ╚██╗ ██╔╝╚════██║    ██║     ██║   ██║██║  ██║██╔══╝          ║
║    ╚████╔╝ ███████║    ╚██████╗╚██████╔╝██████╔╝███████╗        ║
║     ╚═══╝  ╚══════╝     ╚═════╝ ╚═════╝ ╚═════╝ ╚══════╝        ║
║                                                                  ║
║          Team Standard · Shared Instructions · AI Agents         ║
║                                                                  ║
╚══════════════════════════════════════════════════════════════════╝
```

> **Eine fertige Vorlage für gemeinsame VS Code Settings, GitHub Copilot Instructions und Custom Agents.**
>
> Clone → anpassen → commiten. Das ganze Team arbeitet sofort mit denselben Standards.

---

## Worum es geht

Dieses Repository ist eine **sofort nutzbare Referenz-Implementierung** für Teams, die eine gemeinsame Entwicklungsumgebung in VS Code aufbauen wollen.

Es enthält:

- fertige `.vscode/` Konfigurationen (Settings, Extensions, Debugging, Tasks)
- fertige `.github/` Copilot Instructions, file-spezifische Instructions und Custom Agents
- einen ausführlichen Artikel, der jeden Baustein erklärt
- Skripte zum Einbinden in bestehende Projekte

**Der Artikel dazu:** [docs/VS_CODE_TEAM_STANDARD_COURSE.md](docs/VS_CODE_TEAM_STANDARD_COURSE.md)

---

## Schnellstart

### 1. Repo clonen

```bash
git clone git@github.com:larson-frontend/shared-instructions.git
```

### 2. In dein Projekt einbinden

```bash
# Symlink im Projektordner anlegen
cd dein-projekt/
ln -s ../shared-instructions shared-instructions
```

Oder die Dateien direkt in dein Projekt kopieren:

```bash
# .vscode/ und .github/ in dein Projekt übernehmen
cp -r shared-instructions/.vscode/ dein-projekt/.vscode/
cp -r shared-instructions/.github/ dein-projekt/.github/
cp shared-instructions/.editorconfig dein-projekt/.editorconfig
```

### 3. Anpassen

Die Dateien sind als Startpunkt gedacht. Passe sie an die Toolchain und Konventionen deines Teams an.

---

## Was drin ist

```
shared-instructions/
├── .editorconfig                          ← Einheitliche Editor-Basics
├── .vscode/
│   ├── settings.json                      ← Team-Settings (Formatter, Linter, Copilot)
│   ├── extensions.json                    ← Empfohlene Extensions
│   ├── launch.json                        ← Debug-Profile (Node, Vite, Compound)
│   └── tasks.json                         ← Häufige Tasks (dev, test, build, lint)
├── .github/
│   ├── copilot-instructions.md            ← Globale AI-Regeln fürs Team
│   ├── instructions/
│   │   ├── frontend.instructions.md       ← React/TSX-spezifische Regeln
│   │   ├── backend.instructions.md        ← API/Service-spezifische Regeln
│   │   └── testing.instructions.md        ← Test-Konventionen
│   └── agents/
│       ├── review-agent.agent.md          ← PR-Review Agent
│       └── react-agent.agent.md           ← React UI Agent
├── docs/
│   └── VS_CODE_TEAM_STANDARD_COURSE.md    ← Der vollständige Artikel
├── instructions/                          ← Erweiterte Agent-Definitionen
│   ├── copilot.instructions.md
│   ├── magic-agent.agent.md
│   ├── react-agent.agent.md
│   ├── java-agent.agent.md
│   ├── vue-agent.agent.md
│   └── test.instructions.md
└── scripts/                               ← Setup-Skripte
    └── link-shared-instructions.sh
```

---

## Die Bausteine im Überblick

Der [Artikel](docs/VS_CODE_TEAM_STANDARD_COURSE.md) erklärt jeden Baustein im Detail. Hier die Kurzversion:

| # | Baustein | Dateien | Was es löst |
|---|----------|---------|-------------|
| 1 | Workspace Settings | `.vscode/settings.json` | Einheitlicher Formatter, Linter, Save-Verhalten |
| 2 | Team Extensions | `.vscode/extensions.json` | Alle nutzen dieselbe Toolbasis |
| 3 | Debug-Profile | `.vscode/launch.json` | Debugging funktioniert auf jedem Rechner |
| 4 | Task Runner | `.vscode/tasks.json` | Standardisierte Dev-Abläufe |
| 5 | Copilot Instructions | `.github/copilot-instructions.md` | AI kennt eure Architektur und Regeln |
| 6 | File-Instructions | `.github/instructions/*.md` | Bereichsspezifische AI-Regeln |
| 7 | Custom Agents | `.github/agents/*.md` | Spezialisierte AI-Workflows |
| 8 | Editor Config | `.editorconfig` | Basis-Formatierung auch ohne VS Code |

---

## So bindet ihr das Repo in bestehende Projekte ein

### Option A: Symlink (empfohlen)

```bash
# shared-instructions/ liegt neben eurem Projekt
workspace/
├── shared-instructions/     ← Dieses Repo
├── frontend/
│   └── shared-instructions/ → ../shared-instructions  (Symlink)
└── backend/
    └── shared-instructions/ → ../shared-instructions  (Symlink)
```

```bash
# Symlink anlegen
cd frontend/
ln -s ../shared-instructions shared-instructions

# Oder mit dem mitgelieferten Skript
../shared-instructions/scripts/link-shared-instructions.sh
```

Vorteil: Änderungen am Repo wirken sofort in allen Projekten.

### Option B: Dateien kopieren

Für Teams, die keine Symlinks nutzen wollen:

```bash
cp -r shared-instructions/.vscode/ mein-projekt/.vscode/
cp -r shared-instructions/.github/ mein-projekt/.github/
cp shared-instructions/.editorconfig mein-projekt/
```

Nachteil: Updates müssen manuell übernommen werden.

---

## Custom Agents

Dieses Repo enthält zwei Typen von Agent-Definitionen:

### Standard-Agents (`.github/agents/`)

Sofort nutzbar für jedes Projekt:

| Agent | Datei | Einsatz |
|-------|-------|---------|
| Review Agent | `review-agent.agent.md` | PR-Reviews, Risiken erkennen, fehlende Tests finden |
| React Agent | `react-agent.agent.md` | React UI, Komponenten, State, Styling |

### Erweiterte Agents (`instructions/`)

Spezialisierte Agents mit erweiterten Features (Transparency Header, Model Routing, Learning Facts):

| Agent | Datei | Einsatz |
|-------|-------|---------|
| Magic Agent | `magic-agent.agent.md` | Universeller Agent mit Model-Routing |
| React Agent | `react-agent.agent.md` | React/TypeScript Frontend |
| Java Agent | `java-agent.agent.md` | Java/Spring Boot Backend |
| Vue Agent | `vue-agent.agent.md` | Vue 3/Vite Frontend |

---

## Einführung im Team

Der Artikel empfiehlt eine schrittweise Einführung:

**Phase 1 — Minimum Standard:**
- `.vscode/settings.json` + `extensions.json`
- `.github/copilot-instructions.md`

**Phase 2 — Bereichsspezifische Regeln:**
- `.github/instructions/` für Frontend, Backend, Testing
- `.vscode/launch.json` für Debug-Profile

**Phase 3 — Advanced Setup:**
- `.github/agents/` für Custom Agents
- Shared Instructions über mehrere Repos

→ Details im [Artikel, Baustein 11](docs/VS_CODE_TEAM_STANDARD_COURSE.md#baustein-11-einführungsplan-für-ein-echtes-team)

---

## Governance

Damit der Standard nicht veraltet:

1. Änderungen an `.vscode/` und `.github/` nur per PR
2. Jede Änderung braucht eine Begründung
3. klare Ownership: wer pflegt Settings, wer pflegt AI-Instructions
4. Governance-Checkliste vor jedem Merge prüfen

→ Details im [Artikel, Baustein 9](docs/VS_CODE_TEAM_STANDARD_COURSE.md#baustein-9-team-rollen-und-verantwortlichkeiten)

---

## Weitere Dokumentation

| Dokument | Zweck |
|----------|-------|
| [VS Code Team Standard (Artikel)](docs/VS_CODE_TEAM_STANDARD_COURSE.md) | Vollständiger Leitfaden mit allen 13 Bausteinen |
| [Getting Started](docs/GETTING_STARTED.md) | Komplettes Setup von Clone bis Running |
| [Installation](docs/INSTALLATION.md) | Kurzanleitung |
| [Team Setup Guide](docs/TEAM_SETUP_GUIDE.md) | Team-Workflows und Standards |
| [Testing Instructions](instructions/test.instructions.md) | Unit-Test Best Practices (Java/TS) |
| [Agent Usage](docs/agent-usage.md) | Nutzungshistorie und Patterns |

---

## Lizenz

Dieses Repository ist öffentlich. Nutze es als Vorlage für dein Team.

Feedback und Contributions sind willkommen.
