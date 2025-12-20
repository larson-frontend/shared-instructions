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
LANG=""
LOG_FILE="shared-instructions/docs/agent-usage.md"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --agent) AGENT="$2"; shift 2;;
    --task) TASK="$2"; shift 2;;
    --model) MODEL="$2"; shift 2;;
    --status) STATUS="$2"; shift 2;;
    --desc) DESC="$2"; shift 2;;
    --lang) LANG="$2"; shift 2;;
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

if [[ -z "$LANG" ]]; then
  # Auto-detect language from agent name or repo indicators
  case "$AGENT" in
    React_Agent)
      LANG="typescript";;
    Vue_Agent)
      LANG="vue";;
    Java_Agent)
      LANG="java";;
    *)
      # Detect from repo root
      REPO_ROOT=$(git rev-parse --show-toplevel 2>/dev/null || pwd)
      if [[ -f "$REPO_ROOT/pom.xml" ]]; then
        LANG="java"
      elif [[ -f "$REPO_ROOT/tsconfig.json" ]]; then
        LANG="typescript"
      elif [[ -n "$(git ls-files '*.vue' 2>/dev/null)" ]]; then
        LANG="vue"
      elif [[ -n "$(git ls-files '*.tsx' 2>/dev/null)" || -n "$(git ls-files '*.ts' 2>/dev/null)" ]]; then
        LANG="typescript"
      elif [[ -n "$(git ls-files '*.jsx' 2>/dev/null)" || -n "$(git ls-files '*.js' 2>/dev/null)" ]]; then
        LANG="javascript"
      elif [[ -n "$(git ls-files '*.go' 2>/dev/null)" ]]; then
        LANG="go"
      elif [[ -n "$(git ls-files '*.py' 2>/dev/null)" ]]; then
        LANG="python"
      elif [[ -n "$(git ls-files '*.rs' 2>/dev/null)" ]]; then
        LANG="rust"
      elif [[ -n "$(git ls-files '*.kt' 2>/dev/null)" || -n "$(git ls-files '*.kts' 2>/dev/null)" ]]; then
        LANG="kotlin"
      elif [[ -n "$(git ls-files '*.cs' 2>/dev/null)" ]]; then
        LANG="csharp"
      elif [[ -n "$(git ls-files '*.php' 2>/dev/null)" ]]; then
        LANG="php"
      elif [[ -n "$(git ls-files '*.swift' 2>/dev/null)" ]]; then
        LANG="swift"
      elif [[ -n "$(git ls-files '*.dart' 2>/dev/null)" ]]; then
        LANG="dart"
      elif [[ -n "$(git ls-files '*.c' 2>/dev/null)" || -n "$(git ls-files '*.h' 2>/dev/null)" ]]; then
        LANG="c"
      elif [[ -n "$(git ls-files '*.cpp' 2>/dev/null)" || -n "$(git ls-files '*.cc' 2>/dev/null)" || -n "$(git ls-files '*.cxx' 2>/dev/null)" ]]; then
        LANG="cpp"
      else
        LANG="mixed"
      fi
      ;;
  esac
fi

# Normalize values to avoid spaces breaking parsers
AGENT=${AGENT// /_}
TASK=${TASK// /_}
MODEL=${MODEL// /_}
STATUS=${STATUS// /_}
LANG=${LANG// /_}

TS=$(date -u +"%Y-%m-%d %H:%M")
LINE="- [${TS}] agent=${AGENT} task=${TASK} model=${MODEL} status=${STATUS} lang=${LANG} desc=${DESC}"

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