# Magic Agent — Installation

Pick your method:

## 1️⃣ One-Command Remote Install (Recommended)

```bash
curl -fsSL https://raw.githubusercontent.com/larson-frontend/shared-instructions/main/scripts/remote-install.sh | zsh -s -- https://github.com/user/my-project
```

Or with custom location:
```bash
cd ~/my-projects
curl -fsSL https://raw.githubusercontent.com/larson-frontend/shared-instructions/main/scripts/remote-install.sh | zsh -s -- https://github.com/user/my-project
```

**What happens:**
- Clones shared-instructions
- Clones your project
- Creates symlink automatically
- ✅ Done!

---

## 2️⃣ If You Already Have shared-instructions

```bash
/path/to/shared-instructions/scripts/install.sh --clone https://github.com/user/my-project
```

Or just link existing project:
```bash
/path/to/shared-instructions/scripts/install.sh --link /path/to/project
```

---

## 3️⃣ Interactive Setup

```bash
cd /path/to/shared-instructions
./scripts/setup-shared-instructions.sh
```

Script will ask for project path and confirm.

---

## 📊 Quick Comparison

| Method | Speed | Requires shared-instructions | Clone project |
|--------|-------|------------------------------|---------------|
| **1. Remote curl** | ⚡⚡⚡ | ❌ No | ✅ Yes |
| **2. Local install.sh** | ⚡⚡ | ✅ Yes | ✅ Yes |
| **3. Interactive** | 🐢 | ✅ Yes | ❌ Manual |

---

## 🔗 What Gets Installed?

Both methods create a **symbolic link** in your project:

```
your-project/
---

## ✅ What Gets Installed?

A symlink in your project linking to Magic Agent:
```
your-project/shared-instructions → /path/to/shared-instructions
```

Access to:
- ✨ Magic Agent instructions
- 🤖 Claude Opus/Sonnet model priorities
- 📋 Transparency header format
- 🥋 Chuck Norris quotes
- 📊 Agent usage tracking

---

## 🚀 Next Steps

1. Open in VS Code: `code /path/to/project`
2. Reload: `Ctrl+Shift+P` → "Reload Window"
3. Use Magic Agent: Press `Ctrl+I`
4. View stats: `./shared-instructions/scripts/stats-agent-usage.sh .agent-usage.md`

---

**Happy coding! 🚀**
