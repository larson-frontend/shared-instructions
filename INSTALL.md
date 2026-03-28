# Shared Instructions — Schritt-für-Schritt Installation

> **Für wen ist diese Anleitung?**
> Für alle im Team — auch wenn du noch nie mit Git, Terminal oder VS Code gearbeitet hast.
> Jeder Schritt ist erklärt. Nichts wird übersprungen.

---

## Inhaltsverzeichnis

1. [Was du brauchst (Voraussetzungen)](#1-was-du-brauchst-voraussetzungen)
2. [Terminal öffnen](#2-terminal-öffnen)
3. [Shared-Instructions klonen](#3-shared-instructions-klonen)
4. [In dein Projekt einbinden](#4-in-dein-projekt-einbinden)
5. [VS Code neu laden](#5-vs-code-neu-laden)
6. [Prüfen ob alles funktioniert](#6-prüfen-ob-alles-funktioniert)
7. [Fehlerbehebung](#7-fehlerbehebung)

---

## 1. Was du brauchst (Voraussetzungen)

Bevor du loslegst, stelle sicher dass diese Programme installiert sind:

### ✅ VS Code

- Download: https://code.visualstudio.com/
- Installiere es ganz normal (Weiter → Weiter → Fertig).

### ✅ Git

**Prüfen ob Git installiert ist:**

Öffne ein Terminal (siehe Schritt 2) und tippe:

```bash
git --version
```

Wenn eine Versionsnummer kommt (z.B. `git version 2.43.0`), ist Git installiert. ✅

Wenn nicht:
- **Linux (Ubuntu/Debian):** `sudo apt install git`
- **macOS:** `xcode-select --install`
- **Windows:** Download von https://git-scm.com/download/win

### ✅ GitHub Copilot Extension

1. Öffne VS Code
2. Klicke links auf das Extensions-Symbol (vier Quadrate, eins schräg)
3. Suche nach `GitHub Copilot`
4. Klicke **Install** bei "GitHub Copilot" und "GitHub Copilot Chat"

> 💡 **Tipp:** Wenn du noch keinen GitHub-Account hast, erstelle einen auf https://github.com
> Copilot braucht einen bezahlten Plan oder eine kostenlose Testversion.

---

## 2. Terminal öffnen

Das Terminal ist das schwarze Fenster, in dem du Befehle eingibst.

### In VS Code (empfohlen)

1. Öffne VS Code
2. Drücke `Strg + ö` (Windows/Linux) oder `Cmd + ö` (macOS)
3. Unten öffnet sich das Terminal ✅

### Außerhalb von VS Code

- **Windows:** Startmenü → "PowerShell" eingeben → öffnen
- **macOS:** Spotlight (Cmd + Leertaste) → "Terminal" eingeben → öffnen
- **Linux:** `Strg + Alt + T`

> 💡 **Tipp:** Im Terminal siehst du einen Pfad wie `~/Projects` oder `C:\Users\dein-name`.
> Das zeigt dir, wo du gerade bist. Wie ein Ordner im Datei-Explorer.

---

## 3. Shared-Instructions klonen

"Klonen" bedeutet: Das Repository (= Ordner mit Dateien) von GitHub auf deinen Computer kopieren.

### Schritt 3.1 — Navigiere zu deinem Projektordner

```bash
# Geh in den Ordner, wo deine Projekte liegen
# Passe den Pfad an deine Ordnerstruktur an!

# Linux/macOS:
cd ~/Projects

# Windows (PowerShell):
cd C:\Users\DEIN_NAME\Projects
```

> 💡 **Kein "Projects"-Ordner?** Erstelle einen:
> ```bash
> mkdir ~/Projects
> cd ~/Projects
> ```

### Schritt 3.2 — Repository klonen

```bash
git clone git@github.com:larson-frontend/shared-instructions.git
```

**Was passiert:**
- Git lädt alle Dateien herunter
- Es entsteht ein neuer Ordner `shared-instructions/`
- Darin sind alle VS Code Settings, Copilot Instructions und Agents

> ⚠️ **Fehler: "Permission denied (publickey)"?**
> Das bedeutet, dass dein SSH-Key nicht bei GitHub hinterlegt ist.
> Nutze stattdessen HTTPS:
> ```bash
> git clone https://github.com/larson-frontend/shared-instructions.git
> ```

### Schritt 3.3 — Prüfe ob es geklappt hat

```bash
ls shared-instructions/
```

Du solltest Dateien und Ordner sehen wie: `.vscode/`, `.github/`, `README.md`, `docs/`, `scripts/`

✅ **Wenn du das siehst: Shared-Instructions ist auf deinem Computer.**

---

## 4. In dein Projekt einbinden

Jetzt musst du shared-instructions mit deinem Projekt verbinden.
Dafür gibt es drei Optionen — wähle die, die am besten passt.

### Option A: Symlink (empfohlen für Linux/macOS)

Ein Symlink ist wie eine Verknüpfung — dein Projekt "sieht" die Dateien aus shared-instructions, ohne sie zu kopieren.

```bash
# 1. Geh in dein Projekt
cd ~/Projects/mein-projekt

# 2. Erstelle den Symlink
ln -s ../shared-instructions shared-instructions
```

**Prüfen:**
```bash
ls -la shared-instructions
```

Du solltest sehen: `shared-instructions -> ../shared-instructions` ✅

> 💡 **Vorteil:** Wenn jemand shared-instructions aktualisiert, hast du die Änderungen automatisch.

### Option B: Dateien kopieren (für alle Betriebssysteme)

Wenn Symlinks nicht funktionieren oder du es einfacher willst:

```bash
# 1. Geh in dein Projekt
cd ~/Projects/mein-projekt

# 2. Kopiere die wichtigsten Ordner
cp -r ../shared-instructions/.vscode/ .vscode/
cp -r ../shared-instructions/.github/ .github/
cp ../shared-instructions/.editorconfig .editorconfig
```

**Windows (PowerShell):**
```powershell
cd C:\Users\DEIN_NAME\Projects\mein-projekt
Copy-Item -Recurse ..\shared-instructions\.vscode\ .vscode\
Copy-Item -Recurse ..\shared-instructions\.github\ .github\
Copy-Item ..\shared-instructions\.editorconfig .editorconfig
```

> ⚠️ **Nachteil:** Updates musst du manuell erneut kopieren.

### Option C: Automatisches Script

Wenn du dir unsicher bist, nutze unser Bootstrap-Script:

```bash
# Linux/macOS
cd ~/Projects/mein-projekt
zsh ../shared-instructions/scripts/bootstrap.sh
```

```powershell
# Windows (PowerShell)
cd C:\Users\DEIN_NAME\Projects\mein-projekt
powershell -ExecutionPolicy Bypass -File ..\shared-instructions\scripts\bootstrap.ps1
```

**Das Script macht automatisch:**
- ✅ Prüft ob shared-instructions vorhanden ist
- ✅ Erstellt den Symlink
- ✅ Konfiguriert VS Code
- ✅ Gibt Feedback, ob alles geklappt hat

---

## 5. VS Code neu laden

Damit VS Code die neuen Settings erkennt, musst du einmal neu laden:

### Methode 1: Tastenkürzel (schnell)

1. Drücke `Strg + Shift + P` (Windows/Linux) oder `Cmd + Shift + P` (macOS)
2. Es öffnet sich die **Command Palette** (ein Suchfeld oben)
3. Tippe: `Reload Window`
4. Drücke `Enter`

### Methode 2: VS Code schließen und öffnen

1. VS Code schließen (`Strg + Q`)
2. VS Code wieder öffnen
3. Dein Projekt öffnen: Datei → Ordner öffnen → Projekt auswählen

✅ **Fertig! VS Code nutzt jetzt die Team-Settings.**

---

## 6. Prüfen ob alles funktioniert

### ✅ Check 1: Settings geladen?

1. `Strg + Shift + P` → tippe `Open Settings (JSON)`
2. Prüfe ob Einstellungen wie `"editor.formatOnSave": true` vorhanden sind

### ✅ Check 2: Empfohlene Extensions?

1. Klicke auf das Extensions-Symbol (links, vier Quadrate)
2. Oben im Suchfeld steht ein Filter-Icon → klicke "Show Recommended Extensions"
3. Du solltest eine Liste sehen: Prettier, ESLint, GitLens, etc.
4. **Installiere alle empfohlenen Extensions** (Button: "Install All")

### ✅ Check 3: Copilot kennt die Instructions?

1. Öffne den Copilot Chat: `Strg + Shift + I` oder klicke das Copilot-Symbol in der Seitenleiste
2. Frage: `Was sind deine Instructions?`
3. Copilot sollte etwas über Conventional Commits, TypeScript strict, etc. antworten

### ✅ Check 4: Agents verfügbar?

1. Im Copilot Chat, tippe `@`
2. Du solltest Agents sehen wie: **Orchestrator**, **React Agent**, **Review Agent**

> ❌ **Siehst du keine Agents?** Dann wurde `.github/agents/` nicht korrekt eingebunden.
> Prüfe ob der Ordner existiert: `ls .github/agents/`

### ✅ Check 5: MCP Server konfiguriert?

1. `Strg + Shift + P` → tippe `MCP: List Servers`
2. Du solltest Server sehen wie: `github`, `filesystem`

> 💡 **MCP Server brauchen ggf. einen GitHub Token.** Beim ersten Start wirst du danach gefragt.

---

## 7. Fehlerbehebung

### Problem: "Permission denied" beim Klonen

**Ursache:** SSH-Key nicht eingerichtet.

**Lösung A** — HTTPS statt SSH nutzen:
```bash
git clone https://github.com/larson-frontend/shared-instructions.git
```

**Lösung B** — SSH-Key einrichten (empfohlen für langfristig):
1. Generiere einen Key: `ssh-keygen -t ed25519 -C "deine-email@example.com"`
2. Drücke 3x Enter (Standard-Pfad, kein Passwort)
3. Kopiere den Key: `cat ~/.ssh/id_ed25519.pub`
4. Gehe zu GitHub → Settings → SSH and GPG Keys → New SSH Key
5. Füge den Key ein und speichere
6. Versuche erneut zu klonen

---

### Problem: Symlink funktioniert nicht (Windows)

Windows unterstützt Symlinks nur eingeschränkt.

**Lösung:** Nutze Option B (Dateien kopieren) oder aktiviere Symlinks:
1. Öffne PowerShell **als Administrator**
2. Führe aus: `fsutil behavior set SymlinkEvaluation L2L:1 R2R:1 L2R:1 R2L:1`
3. Starte den Computer neu

Oder nutze stattdessen eine Junction (funktioniert ohne Admin):
```powershell
cmd /c mklink /J shared-instructions ..\shared-instructions
```

---

### Problem: VS Code zeigt keine empfohlenen Extensions

**Ursache:** `extensions.json` wurde nicht geladen.

**Lösung:**
1. Prüfe ob die Datei existiert: `ls .vscode/extensions.json`
2. Falls nicht → Schritt 4 wiederholen
3. Falls ja → VS Code neu laden (Schritt 5)

---

### Problem: Copilot ignoriert die Instructions

**Ursache:** Die Einstellung `useInstructionFiles` ist nicht aktiv.

**Lösung:**
1. `Strg + Shift + P` → `Open Settings (JSON)`
2. Prüfe ob diese Zeile existiert:
   ```json
   "github.copilot.chat.codeGeneration.useInstructionFiles": true
   ```
3. Falls nicht → füge sie hinzu und speichere
4. VS Code neu laden

---

### Problem: "Agent not found" / Keine Agents sichtbar

**Ursache:** `.github/agents/` Ordner fehlt oder ist leer.

**Lösung:**
```bash
# Prüfe ob der Ordner existiert
ls .github/agents/

# Falls leer oder fehlend:
cp -r ../shared-instructions/.github/agents/ .github/agents/
```

---

### Problem: Format-on-Save funktioniert nicht

**Ursache:** Prettier Extension fehlt oder Default-Formatter nicht gesetzt.

**Lösung:**
1. Installiere Prettier: Extensions → Suche "Prettier - Code formatter" → Install
2. Prüfe die Settings: `"editor.formatOnSave": true` muss vorhanden sein
3. VS Code neu laden

---

## Ordnerstruktur nach der Installation

So sollte dein Projekt aussehen:

```
dein-projekt/
├── .editorconfig                      ← Einheitliche Basis-Formatierung
├── .vscode/
│   ├── settings.json                  ← Team-Settings (Formatter, Linter, Copilot)
│   ├── extensions.json                ← Empfohlene Extensions fürs Team
│   ├── launch.json                    ← Debug-Profile (Vite, BFF, Cypress)
│   ├── tasks.json                     ← Tasks (dev, test, build, lint, quality gate)
│   └── mcp.json                       ← MCP Server (GitHub, Filesystem)
├── .github/
│   ├── copilot-instructions.md        ← Globale AI-Regeln
│   ├── instructions/
│   │   ├── frontend.instructions.md   ← React/TSX-Regeln
│   │   ├── backend.instructions.md    ← API/Service-Regeln
│   │   └── testing.instructions.md    ← Test-Konventionen
│   └── agents/
│       ├── orchestrator.agent.md      ← Intelligent Model Router
│       ├── review-agent.agent.md      ← PR-Review Agent
│       └── react-agent.agent.md       ← React UI Agent
└── src/                               ← Euer Code
```

---

## Updates holen

Wenn jemand im Team die shared-instructions aktualisiert hat:

### Mit Symlink (Option A)

```bash
cd ~/Projects/shared-instructions
git pull
```

Fertig — dein Projekt hat automatisch die neuen Dateien. ✅

### Mit kopierten Dateien (Option B)

```bash
cd ~/Projects/shared-instructions
git pull

# Dann erneut kopieren
cp -r .vscode/ ~/Projects/mein-projekt/.vscode/
cp -r .github/ ~/Projects/mein-projekt/.github/
cp .editorconfig ~/Projects/mein-projekt/.editorconfig
```

---

## Hilfe & Ansprechpartner

Wenn etwas nicht funktioniert:

1. **Lies die Fehlermeldung** — oft steht die Lösung direkt darin
2. **Frage Copilot** — öffne den Chat und beschreibe dein Problem
3. **Frage im Team** — im Slack/Teams-Channel posten
4. **Erstelle ein Issue** — auf GitHub unter `larson-frontend/shared-instructions`

---

> **Geschafft!** 🎉
> Du hast jetzt die gleiche Entwicklungsumgebung wie das ganze Team.
> Alle Settings, Agents und Extensions sind konfiguriert.
