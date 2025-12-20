# 🚀 Team Setup Guide: Automatic VS Code Configuration & Copilot Agent Selection

**Last Updated:** December 13, 2025

---

## 📋 Overview

This guide explains how the **shared-instructions** submodule and workspace settings work together to provide automatic Copilot agent configuration for your entire team.

**The Goal:** No manual setup needed. Clone, open in VS Code, and Copilot automatically uses the right agent and model. ✨

---

## 🎯 What Gets Configured Automatically

When you open the workspace, these settings load automatically:

1. **Copilot Instructions** → Load from `shared-instructions/copilot.instructions.md`
2. **Agent Selection** → Custom Auto agent with optimized model routing
3. **Code Formatting** → Prettier for all file types
4. **ESLint Integration** → Automatic code quality fixes

**No VS Code extension settings to configure. No manual agent selection. Everything is automatic.**

---

## 📦 How It Works (3 Parts)

### Part 1: Shared Instructions Submodule

```
Repository Structure (example):
├── .github/
├── .vscode/
│   └── settings.json          ← Workspace settings (shared by all)
├── shared-instructions/       ← Git submodule (shared repo)
│   ├── copilot.instructions.md
│   ├── agents/
│   │   └── custom-agent.agent.md
│   └── agent-usage.md
├── <backend-project>/         ← Backend service
├── <frontend-project>/        ← Frontend service
└── [other folders]
```

**Submodule is a Git-managed link to the shared repo** — changes push/pull automatically.

### Part 2: Workspace Settings (.vscode/settings.json)

```json
{
  "copilot.instructions": [
    "shared-instructions/copilot.instructions.md"
  ],
  "editor.formatOnSave": true,
  "[typescript]": { "editor.defaultFormatter": "esbenp.prettier-vscode" }
}
```

**This file tells Copilot where to find instructions** — relative path works for all team members.

### Part 3: Copilot Instructions File

```markdown
# Global Copilot Instructions

**Always use the Custom Auto agent** for all interactions...

## Model Selection Rules (Priority Order)
- Primary: Claude Sonnet 4.5
- Fallback 1: GPT-4o
- Fallback 2: GPT-5.1-Codex
- Fallback 3: Claude Haiku 4.5

## Task Classification & Model Assignment
| Task Type | Model | Reasoning |
```

**This file defines which model to use for which task** — updated once, applies to everyone.

---

## 🔄 Team Workflow

### For Team Members: First Time Setup (SSH Recommended)

**Step 1: Clone with Submodules**
```bash
git clone --recurse-submodules <YOUR_REPO_URL>
cd <YOUR_PROJECT_DIR>
```

**Step 2: Open in VS Code**
```bash
code .
```

**Step 3: Trust Workspace**
- VS Code will prompt: "This workspace contains settings from `copilot.instructions`"
- Click "Trust Workspace"

**Step 4: Done! ✅**
- Copilot instructions auto-loaded
- Agent automatically selects best model
- No manual configuration needed

### For Existing Clones

```bash
# If you already cloned without submodules:
git submodule update --init --recursive

# Get latest shared instructions:
git pull origin
git submodule update --remote

# If you see username/password prompts (forcing SSH for the submodule):
git config submodule.shared-instructions.url git@github.com:<owner>/<shared-repo>.git
git submodule sync --recursive
git submodule update --init --recursive
```

---

## 📊 Model Selection Explained

**When you ask Copilot something, it auto-selects the right model:**

### Example 1: Complex Refactoring
```
Your Question: "Refactor the service to use async/await instead of callbacks"

Copilot Reasoning:
- Task: Code (complex refactoring)
- Complexity: High (multi-file, architecture changes)
- Selected: Claude Sonnet 4.5 ← Best for deep reasoning
```

### Example 2: Quick Question
```
Your Question: "What's the difference between @Component and @Service in Spring?"

Copilot Reasoning:
- Task: Chat (quick Q&A)
- Complexity: Low (single concept)
- Selected: GPT-4o ← Fast, efficient
```

### Example 3: Analysis
```
Your Question: "Analyze our API endpoints and suggest improvements"

Copilot Reasoning:
- Task: Analysis (complex reasoning)
- Complexity: High (multiple files, synthesis)
- Selected: Claude Sonnet 4.5 ← Superior reasoning
```

---

## 🔧 Updating Shared Instructions

**All team members use the same instructions automatically.**

### Update Instructions (You as Lead)

**1. Edit the instructions file:**
```bash
cd shared-instructions
vim copilot.instructions.md
# Make your changes
```

**2. Commit & Push**
```bash
git add copilot.instructions.md
git commit -m "chore: update Copilot model selection rules"
git push origin main
```

### Team Gets Updates Automatically

**1. Pull latest from main repo:**
```bash
git pull origin main
```

**2. Update submodule:**
```bash
git submodule update --remote
```

**3. VS Code reloads instructions** ← No restart needed!

**Everyone now uses the new instructions.** ✅

---

## 📁 File Structure Explained

```
<backend-project>/
│
├── .vscode/settings.json
│   └── Tells VS Code: "Load instructions from shared-instructions/copilot.instructions.md"
│
├── shared-instructions/ (Git Submodule)
│   │
│   ├── copilot.instructions.md
│   │   └── Model selection rules
│   │   └── Task classification
│   │   └── Workspace context
│   │
│   ├── agents/
│   │   └── custom-agent.agent.md (Detailed agent behavior)
│   │
│   ├── agent-usage.md
│   │   └── Logging of which models are used
│   │
│   ├── copilot/ (folder for internal use)
│   └── .git/ (Submodule repository)
│
├── <backend-project>/ (Your backend)
│   └── Also has .gitmodules pointing to shared-instructions
│
└── <frontend-project>/ (Your frontend)
    └── Also has .gitmodules pointing to shared-instructions
```

---

## ✅ Verification Checklist

**For your team to verify everything is set up correctly:**

### Check 1: Submodule is initialized
```bash
git config --file .gitmodules --get-regexp path
# Should output:
# submodule.shared-instructions.path shared-instructions
```

### Check 2: Copilot instructions are loaded
```bash
cat .vscode/settings.json | grep copilot.instructions
# Should show path to shared-instructions/copilot.instructions.md
```

### Check 3: Instructions file exists and is accessible
```bash
cat shared-instructions/copilot.instructions.md | head -5
# Should show the instructions content
```

### Check 4: In VS Code, verify settings
- Open: File → Preferences → Settings (or Cmd+,)
- Search: `copilot.instructions`
- Should show: `shared-instructions/copilot.instructions.md`

---

## 🚨 Troubleshooting

### Problem: "Copilot instructions not loading"

**Solution 1: Ensure submodule is initialized**
```bash
git submodule update --init --recursive
```

**Solution 2: Reload VS Code**
- Press `Cmd+Shift+P` (or `Ctrl+Shift+P`)
- Search: "Reload Window"
- Press Enter

**Solution 3: Check file path**
```bash
# Verify copilot.instructions.md exists
ls -la shared-instructions/copilot.instructions.md
# If missing, pull latest:
git submodule update --remote
```

---

### Problem: "Copilot asks me to select agent manually"

**Solution: Settings file not loaded**

1. Check `.vscode/settings.json` exists:
   ```bash
   ls -la .vscode/settings.json
   ```

2. Verify it contains `copilot.instructions`:
   ```bash
   cat .vscode/settings.json | grep copilot
   ```

3. Reload VS Code:
   - `Cmd+Shift+P` → "Reload Window"

---

### Problem: "Different team members see different models"

**Solution: Submodules not synced**

```bash
# Update to latest shared-instructions:
git submodule update --remote

# Commit the change:
git add .gitmodules shared-instructions
git commit -m "chore: sync shared-instructions to latest"
git push
```

---

## 🎓 Learning More

**For detailed agent behavior:**
 - Read: `shared-instructions/instructions/custom-agent.agent.md`

**For Copilot instructions in this workspace:**
- Read: `shared-instructions/copilot.instructions.md`

**For deployment/setup docs:**
- Read: `deployment/DEPLOYMENT.md`
- Read: `deployment/BACKEND_HOSTING_DECISION.md`

---

## 🤝 Contributing Changes

### To suggest a new model selection rule:

1. **Create a branch:**
   ```bash
   cd shared-instructions
   git checkout -b feat/update-model-rules
   ```

2. **Edit copilot.instructions.md:**
   ```bash
   vim copilot.instructions.md
   ```

3. **Commit & push:**
   ```bash
   git add copilot.instructions.md
   git commit -m "feat: add GPT-5.1-Codex for syntax-heavy tasks"
   git push origin feat/update-model-rules
   ```

4. **Create Pull Request** in GitHub

5. **Review & merge** into `main`

6. **Other repos update:**
   ```bash
   git submodule update --remote
   ```

---

## 📝 Summary

| What | How | Who | When |
|-----|-----|-----|------|
| **Submodule Setup** | Git submodule configuration | Lead (done) | One-time |
| **Workspace Settings** | `.vscode/settings.json` | Lead (done) | One-time |
| **Copilot Instructions** | `shared-instructions/copilot.instructions.md` | Lead (updates as needed) | As needed |
| **Team Cloning** | `git clone --recurse-submodules` | Team members | Each clone |
| **Team Updates** | `git submodule update --remote` | Team members | Weekly or as needed |
| **Auto-Loading** | VS Code reads settings file | Automatic | On workspace open |

---

## ✨ Benefits

✅ **No manual agent selection** — Automatic based on task type  
✅ **Consistent across team** — Everyone uses same model selection rules  
✅ **Easy to update** — Change once in shared-instructions, everyone gets it  
✅ **No git conflicts** — Submodule points to main repo, not copied  
✅ **Scalable** — Add new repos to organization, same setup applies  

---

## 🎉 You're Ready!

Your team now has:
- ✅ Automatic Copilot agent selection
- ✅ Consistent model routing across all projects
- ✅ Shared instructions managed centrally
- ✅ Zero per-developer configuration

**Enjoy smarter Copilot interactions!** 🚀

---

**Questions?** Open an issue in shared-instructions repo or contact the team lead.
