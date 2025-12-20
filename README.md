# 📚 Shared Instructions Hub

> Centralized documentation, guidelines, and workflows for development teams
>
> **Note:** This is a template hub for shared project documentation. Customize for your team's needs.

---

## 📖 Documentation Map

| Document | Purpose | Read Time | Audience |
|----------|---------|-----------|----------|
| **GETTING_STARTED.md** | Complete setup from clone to running | 15-20 min | New developers, onboarding |
| **TEAM_SETUP_GUIDE.md** | Team workflows, standards, collaboration | 10-15 min | All team members |
| **copilot.instructions.md** | AI agent instructions & behavior | 5 min | Developers using agents |
| **agent-usage.md** | Agent usage history & patterns | 5-10 min | Reference for past solutions |

**Total onboarding time: ~30-50 minutes** (depending on experience)

---

## 🚀 Quick Start (3 Steps, ~20 min)

1. **Clone & Setup**
   ```bash
   git clone <YOUR_REPO>
   cd <YOUR_PROJECT>
   git submodule update --init --recursive
   ```
   → See `GETTING_STARTED.md` for detailed setup

2. **Read Team Standards**
   → See `TEAM_SETUP_GUIDE.md` for workflows and guidelines

3. **Start Development**
   ```bash
   # Follow GETTING_STARTED.md step-by-step
   # You'll have a running local development environment
   ```

---

## 📁 How Symlinks Work

This repository uses **symlinks** for shared documentation:

```
root/
├── shared-instructions/          ← Central source of truth
│   ├── GETTING_STARTED.md
│   ├── TEAM_SETUP_GUIDE.md
│   ├── copilot.instructions.md
│   └── ...
├── project-1/
│   └── shared-instructions/ → ../shared-instructions  (symlink)
└── project-2/
    └── shared-instructions/ → ../shared-instructions  (symlink)
```

**Benefits:**
- 🎯 Single source of truth (updates auto-sync to all projects)
- 🔄 No duplicate files to maintain
- 📚 Consistent documentation across team
- 🚀 Easy to reference from any project

**Verify symlinks are working:**
```bash
# From any project
cat shared-instructions/GETTING_STARTED.md | head -3
# Should show content from root shared-instructions/
```

---

## 🤖 Using AI Agents (Copilot, etc.)

Each project includes `.vscode/settings.json` that configures AI agents:

```json
{
  "copilot.instructions": [
    "shared-instructions/copilot.instructions.md"
  ]
}
```

**How to use:**
1. Open any file in your project
2. Press `⌘ + I` (Mac) or `Ctrl + I` (Linux/Windows)
3. Ask a question about your code
4. Agent reads instructions from `shared-instructions/copilot.instructions.md`

**Agent context:**
- Reads all `copilot.instructions.md` files
- Understands team standards from `TEAM_SETUP_GUIDE.md`
- References usage patterns from `agent-usage.md`
- Provides consistent guidance across team

---

## 🔄 Daily Workflow

### 1. Pull Latest Changes
```bash
git pull origin main
git submodule update --recursive  # Update shared docs
```

### 2. Create Feature Branch
```bash
git checkout -b feature/description-of-change
```

### 3. Make Changes & Commit
```bash
git add .
git commit -m "type: short description"
# See TEAM_SETUP_GUIDE.md for commit conventions
```

### 4. Push & Create Pull Request
```bash
git push origin feature/description-of-change
# Create PR for code review
```

### 5. Ask for Help
```
Press ⌘ + I (or Ctrl + I)
"Help me with [task]"
Agent provides context-aware guidance
```

**See `TEAM_SETUP_GUIDE.md` for detailed workflow & standards**

---

## 📍 Project Locations

Your projects are organized as submodules or separate directories:

```
workspace/
├── shared-instructions/     ← You are here
│   ├── GETTING_STARTED.md   ← START HERE
│   ├── TEAM_SETUP_GUIDE.md
│   ├── copilot.instructions.md
│   └── README.md            ← This file
├── <project-1>/
│   ├── src/
│   ├── package.json (or pom.xml)
│   └── shared-instructions/ → ../shared-instructions
└── <project-2>/
    ├── src/
    ├── package.json (or pom.xml)
    └── shared-instructions/ → ../shared-instructions
```

Replace `<project-1>` and `<project-2>` with your actual project names.

---

## 📚 Detailed Guides Index

### For New Team Members
1. **GETTING_STARTED.md** - Complete setup guide (15-20 min)
2. **TEAM_SETUP_GUIDE.md** - Team standards and workflow (10 min)
3. **copilot.instructions.md** - How to use AI agent effectively (5 min)

### For Ongoing Development
- **TEAM_SETUP_GUIDE.md** - Git workflow, commit conventions, PR process
- **agent-usage.md** - Reference previous solutions and patterns
- Project-specific README - Check your project's README for tech-specific details

### For Different Roles
- **Frontend developers** - Read project-specific README in frontend directory
- **Backend developers** - Read project-specific README in backend directory
- **Mobile developers** - Check for `android/`, `ios/`, or mobile-specific docs
- **DevOps/Deployment** - Check for deployment guides in project directories

---

## ❓ FAQ

### Q: Where do I start?
**A:** Read `GETTING_STARTED.md` (15-20 minutes) for complete setup from scratch.

### Q: How do I get AI agent help?
**A:** Press `⌘ + I` (Mac) or `Ctrl + I` (Windows/Linux) in VS Code.

### Q: What are the team coding standards?
**A:** See `TEAM_SETUP_GUIDE.md` for conventions, commit messages, and PR workflow.

### Q: I'm working on X, where's the documentation?
**A:** Check the README.md in your specific project directory for tech-specific guides.

### Q: Symlinks aren't working on Windows
**A:** Run Git with `git config core.symlinks true` before cloning.

### Q: Can I edit shared docs?
**A:** Yes, edit them from the root `shared-instructions/` directory. All projects auto-sync via symlink.

### Q: How do I know if my changes broke something?
**A:** Run tests: `npm test` (frontend) or `mvn test` (backend/maven projects).

### Q: Where's the agent instruction file?
**A:** `shared-instructions/copilot.instructions.md` - automatically referenced by `.vscode/settings.json`

---

## 🛠️ Maintenance & Updates

### Updating Shared Documentation

1. Edit files in `shared-instructions/` directory
2. Commit and push changes
3. All projects auto-see updates via symlink
4. No manual sync needed

### Adding New Guides

1. Create new markdown file in `shared-instructions/`
2. Update this README with reference to new file
3. Commit and push
4. All projects have access immediately

### Keeping Documentation Current

- Review quarterly for outdated information
- Update with new team decisions
- Archive old patterns in `agent-usage.md`
- Solicit team feedback on clarity

---

**Last Updated:** December 20, 2025  
**Version:** 1.0.0  
**Type:** Abstract Template (Customize for your team)

> 💡 This is a template hub. Customize all project names, URLs, tech stacks, and workflows to match your team's actual setup and processes.
