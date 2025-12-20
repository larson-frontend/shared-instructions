# Agent Usage History

This file records every agent/model usage with a concise description argument.

Standard entry format:
- `[YYYY-MM-DD HH:MM] agent=<name> task=<type> model=<model> status=<primary|fallback-x> desc=<short description>`

Quick logging command:
- `./shared-instructions/scripts/log-agent-usage.sh --agent "Custom_Auto" --task code --model claude-sonnet-4.5 --status primary --lang typescript --desc "Short action description"`

Visual stats (ASCII ring/pie):
- `./shared-instructions/scripts/stats-agent-usage-pie.sh` (from repo root)
- `./shared-instructions/scripts/stats-agent-usage-pie.sh docs/agent-usage.md` (if you pass a custom log path)

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
