#!/usr/bin/env zsh

set -euo pipefail

# init-shared-instructions-eclipse
# Sets up symlinks and optional Eclipse project settings from shared-instructions.

usage() {
  cat <<'USAGE'
Usage: ./scripts/init-shared-instructions-eclipse.sh [--shared-path <path>] [--non-interactive] [--username <name>]

Options:
  --shared-path <path>   Path to shared-instructions directory (default: ../shared-instructions)
  --non-interactive      Assume defaults: create/overwrite symlinks and Eclipse settings
  --username <name>      Optional username prefix for agent name (e.g., "mario" → "mario-custom_agent")

Run from your project root. This script will:
  1) Create/refresh `shared-instructions` symlink
  2) If present, offer to link Eclipse settings from shared-instructions/eclipse/
     - shared-instructions/eclipse/.settings -> ./.settings (symlink)
     - shared-instructions/eclipse/.project -> ./.project (symlink)
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
    *) echo "Unknown argument: $1" >&2; usage; exit 1;;
  esac
done

SHARED_ABS=$(realpath "$SHARED_PATH" 2>/dev/null || true)
if [[ -z "$SHARED_ABS" || ! -d "$SHARED_ABS" ]]; then
  echo "Error: shared-instructions not found at $SHARED_PATH" >&2
  exit 1
fi
echo "Using shared-instructions at: $SHARED_ABS"

# 1) shared-instructions symlink
LINK_TARGET="shared-instructions"
if [[ -L "$LINK_TARGET" ]]; then
  CUR=$(realpath "$LINK_TARGET")
  if [[ "$CUR" != "$SHARED_ABS" ]]; then
    if [[ "$NON_INTERACTIVE" == true ]]; then
      rm -f "$LINK_TARGET" && ln -s "$SHARED_ABS" "$LINK_TARGET"
    else
      printf "Update symlink %s -> %s? [y/N]: " "$CUR" "$SHARED_ABS"; read -r ans
      [[ "$ans" == [yY] ]] && rm -f "$LINK_TARGET" && ln -s "$SHARED_ABS" "$LINK_TARGET"
    fi
    echo "Symlink updated."
  else
    echo "Symlink $LINK_TARGET already correct."
  fi
elif [[ -e "$LINK_TARGET" ]]; then
  echo "Warning: $LINK_TARGET exists (not symlink)."
  if [[ "$NON_INTERACTIVE" == true ]]; then
    rm -rf "$LINK_TARGET" && ln -s "$SHARED_ABS" "$LINK_TARGET"
  else
    printf "Replace with symlink to shared-instructions? [y/N]: "; read -r ans
    [[ "$ans" == [yY] ]] && rm -rf "$LINK_TARGET" && ln -s "$SHARED_ABS" "$LINK_TARGET"
  fi
  echo "Symlink created."
else
  ln -s "$SHARED_ABS" "$LINK_TARGET" && echo "Symlink created: $LINK_TARGET -> $SHARED_ABS"
fi

# 2) Optional Eclipse settings
ECL_DIR="$SHARED_ABS/eclipse"
SETTINGS_SRC="$ECL_DIR/.settings"
PROJECT_SRC="$ECL_DIR/.project"

link_dir() {
  local src="$1" dst="$2" label="$3"
  if [[ -d "$src" ]]; then
    if [[ -e "$dst" && ! -L "$dst" ]]; then
      if [[ "$NON_INTERACTIVE" == true ]]; then
        rm -rf "$dst" && ln -s "$src" "$dst" && echo "Linked $label"
      else
        printf "$label exists. Overwrite with symlink? [y/N]: "; read -r ans
        if [[ "$ans" == [yY] ]]; then
          rm -rf "$dst" && ln -s "$src" "$dst" && echo "Linked $label"
        else
          echo "Skipped linking $label"
        fi
      fi
    else
      ln -sfn "$src" "$dst" && echo "Linked $label"
    fi
  else
    echo "No $label found; skipping."
  fi
}

link_file() {
  local src="$1" dst="$2" label="$3"
  if [[ -f "$src" ]]; then
    if [[ -e "$dst" && ! -L "$dst" ]]; then
      if [[ "$NON_INTERACTIVE" == true ]]; then
        rm -f "$dst" && ln -s "$src" "$dst" && echo "Linked $label"
      else
        printf "$label exists. Overwrite with symlink? [y/N]: "; read -r ans
        if [[ "$ans" == [yY] ]]; then
          rm -f "$dst" && ln -s "$src" "$dst" && echo "Linked $label"
        else
          echo "Skipped linking $label"
        fi
      fi
    else
      ln -sfn "$src" "$dst" && echo "Linked $label"
    fi
  else
    echo "No $label found; skipping."
  fi
}

link_dir  "$SETTINGS_SRC" ".settings" ".settings (Eclipse settings)"
link_file "$PROJECT_SRC" ".project"   ".project (Eclipse project)"

echo "Eclipse setup complete."

# Prompt for username if not provided and not in non-interactive mode
if [ -z "$USERNAME" ] && [ "$NON_INTERACTIVE" = false ]; then
  echo ""
  echo "Optional: Enter your username to personalize the agent name."
  echo "Press Enter to use the default agent name 'Custom_Auto'."
  read -p "Username: " USERNAME
fi

# Normalize username and construct agent name
if [ -n "$USERNAME" ]; then
  USERNAME_NORM=$(echo "$USERNAME" | tr '[:upper:]' '[:lower:]' | tr ' ' '_')
  AGENT_NAME="${USERNAME_NORM}-custom_agent"
  echo "Agent name set to: $AGENT_NAME"
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
  --desc \"Linked Eclipse settings to shared-instructions\""
