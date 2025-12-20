# Agent Usage Logging & Statistics

## Per-Repository Stats

Each project tracks its own agent usage in a **local `.agent-usage.md`** file at the repo root:
- `shared-instructions/.agent-usage.md` — Instructions meta-work (docs, scripts, config).
- `fasting-frontend/.agent-usage.md` — Frontend React/Vue tasks.
- `fasting-service/.agent-usage.md` — Backend Java/DevOps tasks.

This allows each developer to see their work breakdown **per repo**, not a global merged view.

## Logging Usage

From any repo root, the logger auto-detects your repo and writes to its local stats file:

```bash
./shared-instructions/scripts/log-agent-usage.sh \
  --agent "React_Agent" \
  --task code \
  --model claude-sonnet-4.5 \
  --status primary \
  --lang typescript \
  --desc "Update button component"
```

Standard entry format:
- `[YYYY-MM-DD HH:MM] agent=<name> task=<type> model=<model> status=<primary|fallback-x> lang=<language> desc=<short description>`

## View Statistics

From your repo root, view your local stats:

```bash
# Box-style breakdown
./shared-instructions/scripts/stats-agent-usage.sh .agent-usage.md

# ASCII pie view
./shared-instructions/scripts/stats-agent-usage-pie.sh .agent-usage.md
```

## Language Auto-Detection

The logger infers language from:
1. **Agent hint** (React_Agent → typescript, Vue_Agent → vue, Java_Agent → java).
2. **Repo heuristics** (pom.xml → java, tsconfig.json → typescript).
3. **Changed files** using `shared-instructions/config/language-map.conf`:
   - Extensions: `.ts` → typescript, `.vue` → vue, `.py` → python, etc.
   - GitOps/DevOps special cases: `Dockerfile` → docker, `Jenkinsfile` → jenkins, `.github/workflows/*` → github_actions, `helm/` → helm, `kustomization.yaml` → kustomize, `skaffold.yaml` → skaffold, `terraform/*.tf` → terraform, etc.

Fallback: `mixed` (if no matching files or extensions).

## Example Workflow

You edited `src/components/Button.vue` in fasting-frontend and want to log it:

```bash
cd ~/Projects/Fasting-Service/fasting-frontend
./shared-instructions/scripts/log-agent-usage.sh \
  --agent "Vue_Agent" \
  --task code \
  --model claude-sonnet-4.5 \
  --status primary \
  --desc "Refactor Button component logic"
# → Auto-detects lang=vue and writes to .agent-usage.md
```

View your frontend stats:

```bash
./shared-instructions/scripts/stats-agent-usage.sh .agent-usage.md
```

Output shows YOUR frontend work only—no backend or meta-work pollution.

---

## Reference

- **Language map:** `shared-instructions/config/language-map.conf`
- **Logging script:** `shared-instructions/scripts/log-agent-usage.sh`
- **Stats display:** `scripts/stats-agent-usage.sh`, `stats-agent-usage-pie.sh`

Recent entries:
- [2025-12-06 21:30] agent=Custom_Auto task=setup model=claude-sonnet-4.5 status=primary desc=initial logging file bootstrap
- [2025-12-06 21:42] agent=Custom_Auto task=code model=claude-sonnet-4.5 status=primary desc=Create Docker testing doc
- [2025-12-06 21:43] agent=Custom_Auto task=code model=claude-sonnet-4.5 status=primary desc=Commit and push Docker doc
- [2025-12-06 21:48] agent=Custom_Auto task=code model=claude-sonnet-4.5 status=primary desc=Explain run-local port and next steps
- [2025-12-06 21:50] agent=Custom_Auto task=chat model=gpt-4o status=primary desc=Quick Swagger access info
- [2025-12-06 21:57] agent=Custom_Auto task=code model=gpt-4o status=primary desc=Start backend in background with nohup
- [2025-12-06 22:00] agent=Custom_Auto task=chat model=gpt-4o status=primary desc=Display agent usage statistics
- [2025-12-06 22:24] agent=Custom_Auto task=code model=claude-sonnet-4.5 status=primary desc=Align Swagger 2FA TOTP env handling
- [2025-12-06 22:26] agent=Custom_Auto task=code model=claude-sonnet-4.5 status=primary desc=Clarify agent usage logging flow
- [2025-12-06 22:28] agent=Custom_Auto task=code model=claude-sonnet-4.5 status=primary desc=Expose swagger 2FA env in docker-compose
- [2025-12-06 22:31] agent=Custom_Auto task=code model=claude-sonnet-4.5 status=primary desc=Add swagger 2FA TOTP static fallback
- [2025-12-06 22:36] agent=Custom_Auto task=code model=claude-sonnet-4.5 status=primary desc=Implement swagger 2FA with BasicAuth
- [2025-12-06 22:46] agent=Custom_Auto task=code model=claude-sonnet-4.5 status=primary desc=Fix TOTP env var and enable Google Auth
- [2025-12-20 14:15] agent=Custom_Auto task=code model=claude-sonnet-4.5 status=primary desc=Enabled scripted agent usage logging
- [2025-12-20 16:33] agent=React_Agent task=code model=gpt-4o status=primary lang=typescript desc=Demo log for language/agent stats
- [2025-12-20 16:40] agent=Vue_Agent task=code model=gpt-4o status=primary lang=vue desc=Demo auto-detect language from agent
- [2025-12-20 16:44] agent=Custom_Auto task=analysis model=claude-sonnet-4.5 status=primary lang=shell desc=Detect xml/manifest via changes
- [2025-12-20 16:44] agent=Custom_Auto task=analysis model=claude-sonnet-4.5 status=primary lang=xml desc=XML dominates changes
- [2025-12-20 16:47] agent=Custom_Auto task=analysis model=claude-sonnet-4.5 status=primary lang=xml desc=Detect GitOps/DevOps files
