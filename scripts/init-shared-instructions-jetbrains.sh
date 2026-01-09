#!/usr/bin/env zsh

set -euo pipefail

# init-shared-instructions-jetbrains
# Sets up symlinks and optional JetBrains (IntelliJ IDEA) project settings
# to leverage shared-instructions across projects.

usage() {
  cat <<'USAGE'
Usage: ./scripts/init-shared-instructions-jetbrains.sh [--shared-path <path>] [--non-interactive] [--username <name>]

Options:
  --shared-path <path>   Path to shared-instructions directory (default: ../shared-instructions)
  --non-interactive      Assume defaults: create/overwrite symlinks; apply optional settings if available
  --username <name>      Optional username prefix for agent name (e.g., "mario" → "mario-magic_agent")

Run from your project root (contains `.idea/`). This script will:
  1) Create/refresh `shared-instructions` symlink
  2) If present in shared-instructions, link JetBrains code style and inspection profiles
     - shared-instructions/jetbrains/codeStyles/Project.xml -> .idea/codeStyles/Project.xml
     - shared-instructions/jetbrains/inspectionProfiles/Project_Default.xml -> .idea/inspectionProfiles/Project_Default.xml
  3) Prompt for optional username to personalize agent name
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

# 1) Create/Update shared-instructions symlink
LINK_TARGET="shared-instructions"
if [[ -L "$LINK_TARGET" ]]; then
  CUR=$(realpath "$LINK_TARGET")
  if [[ "$CUR" == "$SHARED_ABS" ]]; then
    echo "Symlink $LINK_TARGET already correct."
  else
    if [[ "$NON_INTERACTIVE" == true ]]; then
      rm -f "$LINK_TARGET" && ln -s "$SHARED_ABS" "$LINK_TARGET"
    else
      printf "Update symlink %s -> %s? [y/N]: " "$CUR" "$SHARED_ABS"; read -r ans
      [[ "$ans" == [yY] ]] && rm -f "$LINK_TARGET" && ln -s "$SHARED_ABS" "$LINK_TARGET"
    fi
    echo "Symlink updated."
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

# 2) JetBrains settings (optional)
mkdir -p .idea/codeStyles .idea/inspectionProfiles

CS_SRC="$SHARED_ABS/jetbrains/codeStyles/Project.xml"
CS_DST=".idea/codeStyles/Project.xml"
IP_SRC="$SHARED_ABS/jetbrains/inspectionProfiles/Project_Default.xml"
IP_DST=".idea/inspectionProfiles/Project_Default.xml"

link_optional() {
  local src="$1" dst="$2" label="$3"
  if [[ -f "$src" ]]; then
    if [[ -L "$dst" || -f "$dst" ]]; then
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
      ln -s "$src" "$dst" && echo "Linked $label"
    fi
  else
    echo "No $label found in shared-instructions; skipping."
  fi
}

link_optional "$CS_SRC" "$CS_DST" "CodeStyle (Project.xml)"
link_optional "$IP_SRC" "$IP_DST" "InspectionProfile (Project_Default.xml)"

echo "JetBrains setup complete."

# 3) Username prompt and agent name personalization
if [[ -z "$USERNAME" && "$NON_INTERACTIVE" == false ]]; then
  printf "\nOptional: Enter your username to personalize agent name\n"
  printf "  - Enter a custom name (e.g., 'Mario')\n"
  printf "  - Type 'random' for a Mario Bros character\n"
  printf "  - Press Enter to use 'Custom_Auto'\n"
  printf "Username: "
  read -r USERNAME
fi

if [[ -n "$USERNAME" ]]; then
  # Check if user wants random name
  if [[ "$USERNAME" == "random" ]]; then
    MARIO_NAMES_FILE="$SHARED_ABS/config/mario-names.conf"
    if [[ -f "$MARIO_NAMES_FILE" ]]; then
      # Read all names, filter out comments/empty lines, pick random
      USERNAME=$(grep -v '^#' "$MARIO_NAMES_FILE" | grep -v '^[[:space:]]*$' | shuf -n 1)
      echo "🎮 Random character selected: $USERNAME"
    else
      echo "Warning: mario-names.conf not found, using default."
      USERNAME=""
    fi
  fi
  
  if [[ -n "$USERNAME" ]]; then
    # Normalize username: lowercase, replace spaces with underscores
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
echo "\nTip: Log this setup in agent-usage.md:"
echo "  ./shared-instructions/scripts/log-agent-usage.sh \\
  --agent \"$AGENT_NAME\" \\
  --task setup \\
  --model <model> \\
  --status primary \\
  --desc \"Linked JetBrains settings to shared-instructions\""
