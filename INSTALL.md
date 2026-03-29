# Shared Instructions — Installation

> **Null Ahnung von Terminal oder Git?** Kein Problem.
> Diese Anleitung erklärt jeden einzelnen Klick. Lies einfach Schritt für Schritt.

---

## Wie es funktioniert (30 Sekunden lesen)

Unser Team nutzt **eine zentrale Sammlung** von Einstellungen, Regeln und AI-Agents.
Die liegt in einem eigenen Repository namens `shared-instructions`.

Du klonst dieses Repo einmal auf deinen Computer.
Dann öffnest du eine `.code-workspace`-Datei — und alles funktioniert automatisch.

**Kein Kopieren, kein Symlink, keine Scripts.** Nur klonen und öffnen.

---

## Was du brauchst

Bevor du loslegst — prüfe diese 3 Dinge:

### 1. VS Code installiert?

Noch nicht? → https://code.visualstudio.com/ herunterladen und installieren.

### 2. Git installiert?

Öffne ein Terminal und tippe:

```bash
git --version
```

Kommt eine Versionsnummer (z.B. `git version 2.43.0`)? → Alles gut.

Kommt ein Fehler?
- **Linux:** `sudo apt install git`
- **macOS:** `xcode-select --install`
- **Windows:** https://git-scm.com/download/win herunterladen und installieren

### 3. GitHub Copilot Extension installiert?

1. Öffne VS Code
2. Links auf das **Extensions-Symbol** klicken (sieht aus wie vier Quadrate)
3. Suche: `GitHub Copilot`
4. **Install** klicken bei "GitHub Copilot" und "GitHub Copilot Chat"

> Noch keinen GitHub-Account? Erstelle einen auf https://github.com
> Copilot braucht einen bezahlten Plan oder eine kostenlose Testversion.

---

## Schritt 1: Terminal öffnen

Das Terminal ist das schwarze Fenster, in dem du Befehle eingibst.

**In VS Code:**
1. VS Code öffnen
2. Tastenkürzel drücken:
   - Windows/Linux: `Strg + ö`
   - macOS: `Cmd + ö`
3. Unten erscheint das Terminal

**Ohne VS Code:**
- Windows: Startmenü → "PowerShell" eintippen → Enter
- macOS: `Cmd + Leertaste` → "Terminal" eintippen → Enter
- Linux: `Strg + Alt + T`

---

## Schritt 2: In den Projektordner navigieren

Tippe im Terminal:

```bash
cd ~/Projects
```

> **Windows (PowerShell):**
> ```powershell
> cd C:\Users\DEIN_NAME\Projects
> ```

> **Kein "Projects"-Ordner?** Erstelle einen:
> ```bash
> mkdir ~/Projects && cd ~/Projects
> ```

---

## Schritt 3: shared-instructions klonen

Tippe:

```bash
git clone https://github.com/larson-frontend/shared-instructions.git
```

**Was passiert:** Git lädt den Ordner `shared-instructions/` auf deinen Computer.
Darin sind alle Team-Settings, Copilot-Regeln und AI-Agents.

> **Fehler "Permission denied"?**
> Du nutzt wahrscheinlich SSH. Der Befehl oben nutzt HTTPS — das funktioniert ohne SSH-Key.

**Prüfe ob es geklappt hat:**

```bash
ls shared-instructions/
```

Du siehst Ordner wie `.vscode/`, `.github/`, `scripts/`? → Perfekt.

---

## Schritt 4: Dein Projekt klonen

Falls du das Projekt noch nicht hast:

```bash
git clone https://github.com/LunjaAris/article-docs.git Docs-Article
git clone https://github.com/LunjaAris/board-bff.git board-bff
```

> Du hast die Projekte schon? Dann überspringe diesen Schritt.

---

## Schritt 5: Workspace-Datei öffnen

Im Projekt gibt es eine `.code-workspace`-Datei. Die öffnet alle Repos zusammen in VS Code.

**Variante A — Vom Terminal:**

```bash
code Docs-Article.code-workspace
```

> **`code` wird nicht gefunden?**
> 1. Öffne VS Code
> 2. `Strg + Shift + P` (oder `Cmd + Shift + P` auf macOS)
> 3. Tippe: `Shell Command: Install 'code' command in PATH`
> 4. Enter drücken
> 5. Terminal neu starten, dann nochmal versuchen

**Variante B — Per Mausklick:**

1. Öffne deinen Datei-Explorer
2. Navigiere zum Projektordner (z.B. `~/Projects/organized-chaos/`)
3. Doppelklicke auf `Docs-Article.code-workspace`
4. VS Code öffnet sich mit allen Projekten

---

## Schritt 6: Workspace vertrauen

Beim ersten Öffnen fragt VS Code:

> "Do you trust the authors of the files in this folder?"

Klicke **"Yes, I trust the authors"**.

Das ist wichtig — ohne Trust werden Settings, Tasks und Extensions blockiert.

---

## Schritt 7: Empfohlene Extensions installieren

VS Code zeigt rechts unten ein Popup:

> "This workspace has extension recommendations."

Klicke **"Install All"**.

**Kein Popup gesehen?**
1. `Strg + Shift + P` → tippe: `Extensions: Show Recommended Extensions`
2. Klicke oben auf das Wolken-Symbol ("Install Workspace Recommended Extensions")

---

## Schritt 8: VS Code neu laden

Damit alles greift:

1. `Strg + Shift + P` (oder `Cmd + Shift + P`)
2. Tippe: `Reload Window`
3. Enter drücken

VS Code startet kurz neu. Fertig.

---

## Prüfen ob alles funktioniert

Mach diese 4 schnellen Checks:

### Check 1: Mehrere Projekte sichtbar?

Schaue links in die **Seitenleiste** (Explorer).
Du solltest mehrere Ordner sehen:
- Docs-Article
- board-bff
- shared-instructions
- (evtl. weitere)

Siehst du nur einen Ordner? → Du hast wahrscheinlich den Ordner statt die `.code-workspace`-Datei geöffnet. Geh zurück zu Schritt 5.

### Check 2: Copilot kennt die Team-Regeln?

1. Öffne Copilot Chat: `Strg + Shift + I`
2. Frage: `Was sind deine Instructions?`
3. Copilot sollte etwas über Conventional Commits, TypeScript strict o.ä. antworten

### Check 3: Agents sichtbar?

1. Im Copilot Chat tippe `@`
2. Du siehst Agents wie: **Orchestrator**, **React Agent**, **Review Agent**

### Check 4: Format-on-Save funktioniert?

1. Öffne eine `.ts`- oder `.tsx`-Datei
2. Mache eine kleine Änderung (z.B. Leerzeichen hinzufügen)
3. Speichere mit `Strg + S`
4. Die Datei wird automatisch formatiert

---

## Updates holen

Wenn jemand die shared-instructions aktualisiert hat:

```bash
cd ~/Projects/shared-instructions
git pull
```

Dann VS Code neu laden (`Strg + Shift + P` → `Reload Window`).

Das war's. Die neuen Einstellungen gelten sofort für alle Projekte im Workspace.

---

## Was steckt im Workspace?

Nach der Installation hast du dieses Setup:

```
~/Projects/
├── shared-instructions/               ← Team-Regeln (1x klonen, nie anfassen)
│   ├── .vscode/
│   │   ├── settings.json              ← Editor-Settings (Format, Lint, Copilot)
│   │   ├── extensions.json            ← Empfohlene Extensions
│   │   ├── tasks.json                 ← Tasks (dev, test, build, lint)
│   │   ├── launch.json                ← Debug-Profile
│   │   └── mcp.json                   ← MCP Server (GitHub, Filesystem)
│   └── .github/
│       ├── copilot-instructions.md    ← Globale AI-Regeln
│       ├── instructions/              ← Kontext-Regeln (Frontend, Backend, Tests)
│       └── agents/                    ← Custom Agents (Orchestrator, Review, React)
│
├── organized-chaos/
│   ├── Docs-Article/                  ← Frontend (React + Vite)
│   ├── board-bff/                     ← Backend (Express + TypeScript)
│   └── Docs-Article.code-workspace    ← Diese Datei öffnen!
```

**So funktioniert es:**
Die `.code-workspace`-Datei listet alle Ordner als "Workspace Folders".
VS Code lädt die `.github/copilot-instructions.md` aus **jedem** Folder automatisch.
→ Die Regeln aus `shared-instructions` gelten für alle Projekte, ohne Kopie oder Symlink.

---

## Fehlerbehebung

### "Permission denied" beim Klonen

Nutze HTTPS statt SSH:
```bash
git clone https://github.com/larson-frontend/shared-instructions.git
```

Falls du SSH bevorzugst, richte einen SSH-Key ein:
1. `ssh-keygen -t ed25519 -C "deine-email@example.com"` → 3x Enter
2. `cat ~/.ssh/id_ed25519.pub` → Key kopieren
3. GitHub → Settings → SSH and GPG Keys → New SSH Key → einfügen und speichern

---

### Copilot ignoriert die Instructions

1. `Strg + Shift + P` → `Preferences: Open Settings (JSON)`
2. Prüfe ob diese Zeile existiert:
   ```json
   "github.copilot.chat.codeGeneration.useInstructionFiles": true
   ```
3. Falls nicht → einfügen, speichern, VS Code neu laden

---

### Keine Agents sichtbar

Prüfe ob `shared-instructions` als Workspace-Folder geladen ist (links in der Seitenleiste sichtbar).
Falls nicht → `.code-workspace`-Datei öffnen statt den Ordner direkt.

---

### Format-on-Save funktioniert nicht

1. Extensions → suche "Prettier - Code formatter" → Install
2. VS Code neu laden

---

### "command 'code' not found"

1. Öffne VS Code
2. `Strg + Shift + P` → `Shell Command: Install 'code' command in PATH`
3. Terminal neu starten

---

## Hilfe

1. **Lies die Fehlermeldung** — oft steht die Lösung direkt darin
2. **Frag Copilot** — im Chat dein Problem beschreiben
3. **Frag im Team** — Slack/Teams-Channel
4. **GitHub Issue** — `larson-frontend/shared-instructions`
