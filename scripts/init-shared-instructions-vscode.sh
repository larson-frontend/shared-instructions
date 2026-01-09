#!/usr/bin/env zsh

set -euo pipefail

# init-shared-instructions-vscode
# Sets up symlinks and VS Code settings to use shared-instructions.
# - Creates/updates `shared-instructions` symlink in project root
# - Creates or merges `.vscode/settings.json` to include copilot instructions
# - Optionally symlinks `.github` to shared-instructions/.github

usage() {
  cat <<'USAGE'
Usage: ./scripts/init-shared-instructions-vscode.sh [--shared-path <path>] [--non-interactive] [--username <name>]

Options:
  --shared-path <path>   Path to shared-instructions directory (default: ../shared-instructions)
  --non-interactive      Assume defaults: create/overwrite symlinks and settings
  --username <name>      Optional username prefix for agent name (e.g., "mario" → "mario-magic_agent")

This script should be run from your project root (the directory that should contain the symlink
`shared-instructions/` and `.vscode/settings.json`).
USAGE
}

SHARED_PATH="../shared-instructions"
NON_INTERACTIVE=false
USERNAME=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --shared-path)
      SHARED_PATH="$2"; shift 2;;
    --non-interactive)
      NON_INTERACTIVE=true; shift;;
    --username)
      USERNAME="$2"; shift 2;;
    -h|--help)
      usage; exit 0;;
    *)
      echo "Unknown argument: $1" >&2; usage; exit 1;;
  esac
done

# Resolve SHARED_PATH to absolute path
SHARED_ABS=$(realpath "$SHARED_PATH" 2>/dev/null || true)
if [[ -z "$SHARED_ABS" || ! -d "$SHARED_ABS" ]]; then
  echo "Error: shared-instructions path not found: $SHARED_PATH" >&2
  echo "Tip: pass the correct path via --shared-path <path>" >&2
  exit 1
fi

echo "Using shared-instructions at: $SHARED_ABS"

# 1) Create/Update shared-instructions symlink in project root
LINK_TARGET="shared-instructions"
if [[ -L "$LINK_TARGET" ]]; then
  CURRENT_TARGET=$(realpath "$LINK_TARGET")
  if [[ "$CURRENT_TARGET" == "$SHARED_ABS" ]]; then
    echo "Symlink $LINK_TARGET already points to shared-instructions."
  else
    if [[ "$NON_INTERACTIVE" == true ]]; then
      rm -f "$LINK_TARGET" && ln -s "$SHARED_ABS" "$LINK_TARGET"
      echo "Updated symlink $LINK_TARGET -> $SHARED_ABS"
    else
      printf "Symlink exists to %s. Overwrite to %s? [y/N]: " "$CURRENT_TARGET" "$SHARED_ABS"
      read -r ans
      if [[ "$ans" == "y" || "$ans" == "Y" ]]; then
        rm -f "$LINK_TARGET" && ln -s "$SHARED_ABS" "$LINK_TARGET"
        echo "Updated symlink $LINK_TARGET -> $SHARED_ABS"
      else
        echo "Keeping existing symlink."
      fi
    fi
  fi
elif [[ -e "$LINK_TARGET" ]]; then
  echo "Warning: $LINK_TARGET exists and is not a symlink."
  if [[ "$NON_INTERACTIVE" == true ]]; then
    rm -rf "$LINK_TARGET" && ln -s "$SHARED_ABS" "$LINK_TARGET"
    echo "Replaced directory/file with symlink $LINK_TARGET -> $SHARED_ABS"
  else
    printf "Replace existing $LINK_TARGET with symlink to shared-instructions? [y/N]: "
    read -r ans
    if [[ "$ans" == "y" || "$ans" == "Y" ]]; then
      rm -rf "$LINK_TARGET" && ln -s "$SHARED_ABS" "$LINK_TARGET"
      echo "Created symlink $LINK_TARGET -> $SHARED_ABS"
    else
      echo "Skipping symlink creation."
    fi
  fi
else
  ln -s "$SHARED_ABS" "$LINK_TARGET"
  echo "Created symlink $LINK_TARGET -> $SHARED_ABS"
fi

# 2) Create or merge .vscode/settings.json
mkdir -p .vscode
SETTINGS_FILE=".vscode/settings.json"
TMP_SETTINGS=".vscode/settings.tmp.json"

ensure_copilot_instruction() {
  # Merge or create JSON ensuring copilot.instructions includes shared path
  python3 - "$SETTINGS_FILE" "$TMP_SETTINGS" <<'PY'
import json, os, sys
src = sys.argv[1]
dst = sys.argv[2]

existing = {}
if os.path.exists(src):
    try:
        with open(src, 'r', encoding='utf-8') as f:
            existing = json.load(f)
    except Exception:
        existing = {}

instructions = existing.get('copilot.instructions')
if isinstance(instructions, list):
    paths = set(instructions)
    paths.add('shared-instructions/instructions/copilot.instructions.md')
    existing['copilot.instructions'] = list(paths)
else:
    existing['copilot.instructions'] = ['shared-instructions/instructions/copilot.instructions.md']

with open(dst, 'w', encoding='utf-8') as f:
    json.dump(existing, f, indent=2)
PY
}

if [[ -f "$SETTINGS_FILE" ]]; then
  if [[ "$NON_INTERACTIVE" == true ]]; then
    ensure_copilot_instruction
    mv "$TMP_SETTINGS" "$SETTINGS_FILE"
    echo "Merged copilot.instructions into $SETTINGS_FILE"
  else
    printf "settings.json exists. Overwrite or Merge? [o/m/N]: "
    read -r choice
    case "$choice" in
      o|O)
        cp "$SETTINGS_FILE" "$SETTINGS_FILE.bak.$(date +%Y%m%d%H%M%S)"
        cat > "$SETTINGS_FILE" <<'JSON'
{
  "copilot.instructions": [
    "shared-instructions/instructions/copilot.instructions.md"
  ]
}
JSON
        echo "Overwrote $SETTINGS_FILE (backup created)."
        ;;
      m|M)
        ensure_copilot_instruction
        mv "$TMP_SETTINGS" "$SETTINGS_FILE"
        echo "Merged copilot.instructions into $SETTINGS_FILE"
        ;;
      *)
        echo "Skipped modifying $SETTINGS_FILE"
        ;;
    esac
  fi
else
  cat > "$SETTINGS_FILE" <<'JSON'
{
  "copilot.instructions": [
    "shared-instructions/instructions/copilot.instructions.md"
  ]
}
JSON
  echo "Created $SETTINGS_FILE"
fi

# 3) Optionally symlink .github from shared-instructions/.github
if [[ -d "$SHARED_ABS/.github" ]]; then
  if [[ "$NON_INTERACTIVE" == true ]]; then
    if [[ -e .github && ! -L .github ]]; then rm -rf .github; fi
    ln -snf "$SHARED_ABS/.github" .github
    echo "Linked .github -> $SHARED_ABS/.github"
  else
    printf "Symlink project .github to shared-instructions/.github? [y/N]: "
    read -r ans
    if [[ "$ans" == "y" || "$ans" == "Y" ]]; then
      if [[ -e .github && ! -L .github ]]; then
        printf ".github exists. Overwrite with symlink? [y/N]: "
        read -r ow
        if [[ "$ow" == "y" || "$ow" == "Y" ]]; then
          rm -rf .github
        else
          echo "Skipping .github symlink."
          exit 0
        fi
      fi
      ln -sfn "$SHARED_ABS/.github" .github
      echo "Linked .github -> $SHARED_ABS/.github"
    else
      echo "Skipped .github symlink."
    fi
  fi
else
  echo "No .github directory found in shared-instructions; skipping .github symlink."
fi

echo "Setup complete."

# Prompt for username if not provided and not in non-interactive mode
if [ -z "$USERNAME" ] && [ "$NON_INTERACTIVE" = false ]; then
  echo ""
  echo "Optional: Enter your username to personalize the agent name."
  echo "  - Enter a custom name (e.g., 'Mario')"
  echo "  - Type 'random' for a Mario Bros character"
  echo "  - Press Enter to use 'Custom_Auto'"
  read -p "Username: " USERNAME
fi

# Normalize username and construct agent name
if [ -n "$USERNAME" ]; then
  # Check if user wants random name
  if [ "$USERNAME" = "random" ]; then
    MARIO_NAMES_FILE="$SHARED_ABS/config/mario-names.conf"
    if [ -f "$MARIO_NAMES_FILE" ]; then
      # Read all names, filter out comments/empty lines, pick random
      USERNAME=$(grep -v '^#' "$MARIO_NAMES_FILE" | grep -v '^[[:space:]]*$' | shuf -n 1)
      echo "🎮 Random character selected: $USERNAME"
    else
      echo "Warning: mario-names.conf not found, using default."
      USERNAME=""
    fi
  fi
  
  if [ -n "$USERNAME" ]; then
    USERNAME_NORM=$(echo "$USERNAME" | tr '[:upper:]' '[:lower:]' | tr ' ' '_')
    AGENT_NAME="${USERNAME_NORM}-magic_agent"
    echo "Agent name set to: $AGENT_NAME"
  else
    AGENT_NAME="Custom_Auto"
    echo "Agent name: $AGENT_NAME (default)"
  fi
else
  AGENT_NAME="Custom_Auto"
  echo "Agent name: $AGENT_NAME (default)"
fi

# Agent usage logging guidance
echo ""
echo "Tip: Log this setup in agent-usage.md (optional):"
echo "  ./shared-instructions/scripts/log-agent-usage.sh \\
  --agent \"$AGENT_NAME\" \\
  --task setup \\
  --model <model> \\
  --status primary \\
  --desc \"Linked VS Code settings to shared-instructions\""
