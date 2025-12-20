#!/usr/bin/env zsh
set -euo pipefail

# log-agent-usage.sh
# Appends a line to shared-instructions/docs/agent-usage.md with agent, task, model, status, and description.
# Usage:
#   ./shared-instructions/scripts/log-agent-usage.sh \
#     --agent "Custom Auto" \
#     --task code \
#     --model claude-sonnet-4.5 \
#     --status primary \
#     --desc "Updated references to instructions/custom-agent.agent.md"
#
# Options:
#   --file <path>   Optional path to agent-usage.md (default: shared-instructions/docs/agent-usage.md)

AGENT=""
TASK=""
MODEL=""
STATUS=""
DESC=""
LOG_FILE="shared-instructions/docs/agent-usage.md"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --agent) AGENT="$2"; shift 2;;
    --task) TASK="$2"; shift 2;;
    --model) MODEL="$2"; shift 2;;
    --status) STATUS="$2"; shift 2;;
    --desc) DESC="$2"; shift 2;;
    --file) LOG_FILE="$2"; shift 2;;
    -h|--help)
      grep '^# ' "$0" -n | sed -n '1,20p' | sed 's/^# //'
      exit 0;;
    *) echo "Unknown argument: $1" >&2; exit 1;;
  esac
done

if [[ -z "$AGENT" || -z "$TASK" || -z "$MODEL" || -z "$STATUS" || -z "$DESC" ]]; then
  echo "Error: Missing required arguments. See --help." >&2
  exit 1
fi

TS=$(date -u +"%Y-%m-%d %H:%M")
LINE="- [${TS}] agent=${AGENT} task=${TASK} model=${MODEL} status=${STATUS} desc=${DESC}"

# Ensure file exists with header
if [[ ! -f "$LOG_FILE" ]]; then
  mkdir -p "$(dirname "$LOG_FILE")"
  printf "# Agent Usage History\n\n" > "$LOG_FILE"
fi

echo "$LINE" >> "$LOG_FILE"
echo "Logged: $LINE"

# Count entries and prompt every 20 uses
count=$(grep -c "^- \[" "$LOG_FILE" 2>/dev/null || echo 0)
if (( count % 20 == 0 )); then
  echo ""
  printf "📊 You've used the agent %d times. View stats? [y/N]: " "$count"
  read -r ans
  if [[ "$ans" == [yY] ]]; then
    SCRIPT_DIR=$(cd -- "$(dirname "$0")" && pwd)
    "$SCRIPT_DIR/stats-agent-usage.sh" "$LOG_FILE" || true
  fi
fi