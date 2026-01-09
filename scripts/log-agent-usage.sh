#!/usr/bin/env zsh
set -euo pipefail

# log-agent-usage.sh
# Appends a line to shared-instructions/docs/agent-usage.md with agent, task, model, status, and description.
# Usage:
#   ./shared-instructions/scripts/log-agent-usage.sh \
#     --agent "Magic Agent" \
#     --task code \
#     --model claude-sonnet-4.5 \
#     --status primary \
#     --desc "Updated references to instructions/magic-agent.agent.md"
#
# Options:
#   --file <path>   Optional path to agent-usage.md (default: shared-instructions/docs/agent-usage.md)

AGENT=""
TASK=""
MODEL=""
STATUS=""
DESC=""
LANG=""
LOG_FILE=""
SCRIPT_DIR=$(cd -- "$(dirname "$0")" && pwd)
LANG_MAP_FILE="$SCRIPT_DIR/../config/language-map.conf"

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

# Auto-detect repo if --file not provided
if [[ -z "$LOG_FILE" ]]; then
  REPO_ROOT=$(git rev-parse --show-toplevel 2>/dev/null || pwd)
  LOG_FILE="$REPO_ROOT/.agent-usage.md"
fi

if [[ -z "$AGENT" || -z "$TASK" || -z "$MODEL" || -z "$STATUS" || -z "$DESC" ]]; then
  echo "Error: Missing required arguments. See --help." >&2
  exit 1
fi

detect_lang_from_changes() {
  local repo_root="$1"
  # Gather changed/untracked files
  local files
  files=$(git -C "$repo_root" ls-files -m -o --exclude-standard 2>/dev/null || true)
  [[ -z "$files" ]] && files=$(git -C "$repo_root" diff --name-only 2>/dev/null || true)
  # Use awk to map extensions via config and count frequencies
  echo "$files" | awk -v mapfile="$LANG_MAP_FILE" '
    BEGIN {
      FS="\n"; OFS="\n";
      # load map
      while ((getline line < mapfile) > 0) {
        if (line ~ /^#/ || line ~ /^\s*$/) continue;
        split(line, kv, "=");
        ext = tolower(kv[1]);
        lang = tolower(kv[2]);
        m[ext] = lang;
      }
      close(mapfile);
    }
    {
      fname = $0;
      n = split(fname, parts, "/");
      basepath = fname;
      basename = parts[n];
      # special cases by basename and path
      if (fname ~ /(^|\/ )MANIFEST\.MF$/) { lc["manifest"]++; next; }
      if (fname ~ /(^|\/ )Dockerfile(\..*)?$/) { lc["docker"]++; next; }
      if (fname ~ /(^|\/ )docker-compose\.ya?ml$/) { lc["docker_compose"]++; next; }
      if (fname ~ /(^|\/ )Jenkinsfile$/) { lc["jenkins"]++; next; }
      if (fname ~ /(^|\/ )Makefile$/) { lc["make"]++; next; }
      if (fname ~ /(^|\/ )\.github\/workflows\//) { lc["github_actions"]++; next; }
      if (fname ~ /(^|\/ )\.gitlab-ci\.yml$/) { lc["gitlab_ci"]++; next; }
      if (fname ~ /(^|\/ )\.circleci\/config\.yml$/) { lc["circleci"]++; next; }
      if (fname ~ /(^|\/ )charts\// || fname ~ /(^|\/ )helm\// || fname ~ /(^|\/ )Chart\.ya?ml$/) { lc["helm"]++; next; }
      if (fname ~ /(^|\/ )kustomization\.ya?ml$/) { lc["kustomize"]++; next; }
      if (fname ~ /(^|\/ )argo(cd)?\//) { lc["argocd"]++; next; }
      if (fname ~ /(^|\/ )flux\//) { lc["flux"]++; next; }
      if (fname ~ /(^|\/ )skaffold\.ya?ml$/) { lc["skaffold"]++; next; }
      # extension mapping
      # get extension from basename
      split(basename, extparts, ".");
      ext = tolower(extparts[length(extparts)]);
      if (ext in m) { lc[m[ext]]++; next; }
    }
    END {
      top = ""; cnt = 0;
      for (k in lc) {
        if (lc[k] > cnt) { cnt = lc[k]; top = k; }
      }
      if (top == "") print "mixed"; else print top;
    }
  '
}

if [[ -z "$LANG" ]]; then
  # Auto-detect language: prefer agent hint, else repo heuristics, else changes using map
  case "$AGENT" in
    React_Agent) LANG="typescript" ;;
    Vue_Agent)   LANG="vue" ;;
    Java_Agent)  LANG="java" ;;
    *)
      REPO_ROOT=$(git rev-parse --show-toplevel 2>/dev/null || pwd)
      if [[ -f "$REPO_ROOT/pom.xml" ]]; then
        LANG="java"
      elif [[ -f "$REPO_ROOT/tsconfig.json" ]]; then
        LANG="typescript"
      else
        LANG=$(detect_lang_from_changes "$REPO_ROOT")
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