# Magic Agent — Installation Guide

Choose the installation method that fits your workflow:

---

## ⚡ Method 1: Remote Install with curl (Fastest)

Download and execute the installer in **one command** — no need to clone shared-instructions first!

### Usage

```bash
curl -fsSL https://raw.githubusercontent.com/larson-frontend/shared-instructions/main/scripts/install.sh | zsh -s -- --clone <PROJECT_REPO_URL> [TARGET_PATH]
```

### Examples

```bash
# Clone and setup in one remote command
curl -fsSL https://raw.githubusercontent.com/larson-frontend/shared-instructions/main/scripts/install.sh | zsh -s -- --clone https://github.com/user/my-project

# Clone to custom location
curl -fsSL https://raw.githubusercontent.com/larson-frontend/shared-instructions/main/scripts/install.sh | zsh -s -- --clone https://github.com/user/my-project ~/projects/my-app
```

### What it does

1. ✅ Downloads install script from GitHub
2. ✅ Clones your repository
3. ✅ Clones shared-instructions (if needed)
4. ✅ Creates symlink automatically
5. ✅ Verifies installation
6. ✅ Shows next steps

⚠️ **Note:** Make sure the `main` branch contains the install.sh script. If using a different branch (e.g., `feature/stack-specific-agents`), replace `main` with your branch name.

---

## 🚀 Method 2: Local One-Command Install

Clone a repository and auto-link Magic Agent in **one command** (requires shared-instructions already cloned).

### Usage

```bash
/path/to/shared-instructions/scripts/install.sh --clone <REPO_URL> [TARGET_PATH]
```

### Examples

```bash
# Clone to auto-generated directory name
./scripts/install.sh --clone https://github.com/user/my-project

# Clone to custom location
./scripts/install.sh --clone https://github.com/user/my-project ~/projects/my-app

# Link existing project (no clone)
./scripts/install.sh --link /path/to/existing/project
```

### What it does

1. ✅ Clones the repository
2. ✅ Creates symlink `shared-instructions` → Magic Agent
3. ✅ Verifies installation
4. ✅ Shows next steps

---

## 🔧 Method 3: Interactive Setup (After Manual Clone)

If you've **already cloned** a repository manually, use the interactive setup:

### Usage

```bash
cd /path/to/shared-instructions
./scripts/setup-shared-instructions.sh
```

### Interactive Flow

The script will ask:
1. 📁 **Enter project path** — Where to create the symlink
2. ✅ **Confirm** — Review summary and proceed

### What it does

1. ✅ Asks for project path interactively
2. ✅ Creates project directory if needed
3. ✅ Creates symlink `shared-instructions` → Magic Agent
4. ✅ Verifies installation
5. ✅ Shows next steps

---

## 📊 Comparison

| Feature | Method 1: curl | Method 2: `install.sh` | Method 3: `setup-*.sh` |
|---------|----------------|------------------------|------------------------|
| **Requires shared-instructions** | ❌ No | ✅ Yes | ✅ Yes |
| **Clone repo** | ✅ Yes | ✅ Yes | ❌ No (manual) |
| **Interactive** | ❌ No | ❌ No | ✅ Yes |
| **Use case** | First-time setup | Team with shared-instructions | Existing projects |
| **Speed** | ⚡⚡⚡ Fastest | ⚡⚡ Fast | 🐢 Slower |

---

## 🔗 What Gets Installed?

Both methods create a **symbolic link** in your project:

```
your-project/
├── shared-instructions → /path/to/shared-instructions
├── .vscode/
│   └── settings.json (auto-configured)
└── ... your project files
```

This link gives your project access to:
- ✨ **Magic Agent** instructions
- 🤖 Model priorities (Claude Opus 4.5, Sonnet, GPT)
- 📋 Transparency header format
- 🥋 Chuck Norris quotes
- 📊 Agent usage tracking

---

## 🔧 Next Steps After Installation

1. **Open in VS Code:**
   ```bash
   code /path/to/your-project
   ```

2. **Reload VS Code:**
   - Press `Ctrl+Shift+P`
   - Type "Reload Window"
   - Press Enter

3. **Start using Magic Agent:**
   - Press `Ctrl+I` in any file
   - Magic Agent is now active!

4. **View statistics:**
   ```bash
   cd /path/to/your-project
   ./shared-instructions/scripts/stats-agent-usage.sh .agent-usage.md
   ```

---

## 🆘 Troubleshooting

### Symlink not working?

```bash
# Check if symlink exists
ls -la your-project/shared-instructions

# Re-create symlink (from project root)
ln -sf /absolute/path/to/shared-instructions shared-instructions
```

### VS Code not detecting Magic Agent?

1. Reload VS Code window (`Ctrl+Shift+P` → "Reload Window")
2. Check `.vscode/settings.json` exists
3. Verify symlink points to correct location

---

## 📚 More Documentation

- [Quick Setup Guide](docs/QUICK_SETUP.md)
- [Team Setup Guide](docs/TEAM_SETUP_GUIDE.md)
- [Username Personalization](docs/USERNAME_PERSONALIZATION.md)
- [Full Documentation](docs/INSTALLATION.md)

---

**Happy coding with Magic Agent! 🚀**
