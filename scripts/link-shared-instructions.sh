#!/usr/bin/env zsh
set -euo pipefail

# link-shared-instructions.sh
# Creates a `shared-instructions` symlink inside a repo.
# Can be run interactively (select from list) or non-interactively (auto-detect).
# Optionally runs the VS Code init script after linking.
#
# Usage:
#   # Interactive: select repo from list
#   ./shared-instructions/scripts/link-shared-instructions.sh
#
#   # One-liner: auto-detect current repo
#   ./shared-instructions/scripts/link-shared-instructions.sh --auto
#
#   # One-liner with VS Code init
#   ./shared-instructions/scripts/link-shared-instructions.sh --auto --init-vscode
#
# Options:
#   --auto          Auto-detect current repo and create symlink (one-liner)
#   --workspace     Parent folder containing repos (default: workspace root)
#   --shared-path   Path to shared-instructions (default: script's parent directory)
#   --non-interactive  Skip all prompts; requires --target or --auto
#   --target        Repo directory to install symlink into
#   --init-vscode   Run VS Code init script after linking

WORKSPACE=""
SHARED_PATH=""
NON_INTERACTIVE=false
TARGET_REPO=""
INIT_VSCODE=false
AUTO_DETECT=false

# Resolve script dir
SCRIPT_DIR=$(cd -- "$(dirname "$0")" && pwd)
DEFAULT_SHARED=$(realpath "$SCRIPT_DIR/..")
DEFAULT_WORKSPACE=$(realpath "$DEFAULT_SHARED/..")

while [[ $# -gt 0 ]]; do
  case "$1" in
    --workspace) WORKSPACE="$2"; shift 2;;
    --shared-path) SHARED_PATH="$2"; shift 2;;
    --non-interactive) NON_INTERACTIVE=true; shift;;
    --target) TARGET_REPO="$2"; shift 2;;
    --auto) AUTO_DETECT=true; NON_INTERACTIVE=true; shift;;
    --init-vscode) INIT_VSCODE=true; shift;;
    -h|--help)
      cat <<'USAGE'
Create shared-instructions symlink in a repo (interactive or one-liner mode).

Options:
  --auto                  Auto-detect current repo and create symlink (one-liner)
  --workspace <path>      Root directory containing project repos (default: parent of shared-instructions)
  --shared-path <path>    Path to shared-instructions (default: this script's parent)
  --non-interactive       Skip all prompts (requires --target or --auto)
  --target <repo-path>    Repo directory to install symlink into
  --init-vscode           Also run VS Code init script after linking

Examples:
  # Interactive: select repo from list
  ./shared-instructions/scripts/link-shared-instructions.sh

  # One-liner: auto-detect current repo
  ./shared-instructions/scripts/link-shared-instructions.sh --auto

  # One-liner with VS Code init
  ./shared-instructions/scripts/link-shared-instructions.sh --auto --init-vscode

  # Non-interactive with explicit path
  ./shared-instructions/scripts/link-shared-instructions.sh --non-interactive --target ./fasting-frontend
USAGE
      exit 0;;
    *) echo "Unknown argument: $1" >&2; exit 1;;
  esac
done

# Defaults
[[ -z "$SHARED_PATH" ]] && SHARED_PATH="$DEFAULT_SHARED"
[[ -z "$WORKSPACE" ]] && WORKSPACE="$DEFAULT_WORKSPACE"

# Validate paths
SHARED_ABS=$(realpath "$SHARED_PATH" 2>/dev/null || true)
WORKSPACE_ABS=$(realpath "$WORKSPACE" 2>/dev/null || true)

if [[ -z "$SHARED_ABS" || ! -d "$SHARED_ABS" ]]; then
  echo "Error: shared-instructions path not found: $SHARED_PATH" >&2
  exit 1
fi
if [[ -z "$WORKSPACE_ABS" || ! -d "$WORKSPACE_ABS" ]]; then
  echo "Error: workspace path not found: $WORKSPACE" >&2
  exit 1
fi

echo "Using shared-instructions: $SHARED_ABS"
echo "Scanning workspace:       $WORKSPACE_ABS"

# Gather candidate repos (top-level directories with common markers)
local -a candidates
for d in "$WORKSPACE_ABS"/*; do
  [[ ! -d "$d" ]] && continue
  base=$(basename "$d")
  [[ "$base" == ".git" || "$base" == "shared-instructions" ]] && continue
  if [[ -d "$d/.git" || -f "$d/package.json" || -f "$d/pom.xml" || -d "$d/src" ]]; then
    candidates+="$d"
  fi
done

if [[ "$NON_INTERACTIVE" == true ]]; then
  if [[ "$AUTO_DETECT" == true ]]; then
    # Auto-detect: use current working directory
    TARGET_ABS=$(pwd)
    if [[ ! -d "$TARGET_ABS" ]]; then
      echo "Error: current directory not found" >&2
      exit 1
    fi
  else
    # Explicit target required
    if [[ -z "$TARGET_REPO" ]]; then
      echo "Error: --non-interactive requires either --auto or --target <repo-path>" >&2
      exit 1
    fi
    TARGET_ABS=$(realpath "$TARGET_REPO" 2>/dev/null || true)
    if [[ -z "$TARGET_ABS" || ! -d "$TARGET_ABS" ]]; then
      echo "Error: target repo not found: $TARGET_REPO" >&2
      exit 1
    fi
  fi
else
  echo "Found repos:" 
  i=1
  for c in $candidates; do
    echo "  [$i] $(basename "$c")  -> $c"
    (( i++ ))
  done
  echo "  [C] Custom path"
  printf "Select a repo number or 'C': "
  read -r choice
  if [[ "$choice" == "C" || "$choice" == "c" ]]; then
    printf "Enter absolute path to repo: "
    read -r custom
    TARGET_ABS=$(realpath "$custom" 2>/dev/null || true)
    if [[ -z "$TARGET_ABS" || ! -d "$TARGET_ABS" ]]; then
      echo "Error: path not found: $custom" >&2
      exit 1
    fi
  else
    # numeric selection
    if [[ "$choice" != <-> ]]; then
      echo "Error: invalid selection" >&2
      exit 1
    fi
    idx=$choice
    count=${#candidates[@]}
    if (( idx < 1 || idx > count )); then
      echo "Error: selection out of range" >&2
      exit 1
    fi
    # zsh arrays are 1-based if referenced like candidates[idx]
    TARGET_ABS=${candidates[$idx]}
  fi
fi

REPO_NAME=$(basename "$TARGET_ABS")
LINK_TARGET="$TARGET_ABS/shared-instructions"

# Create/refresh symlink
if [[ -L "$LINK_TARGET" ]]; then
  CUR=$(realpath "$LINK_TARGET")
  if [[ "$CUR" == "$SHARED_ABS" ]]; then
    echo "Symlink already correct in $REPO_NAME."
  else
    if [[ "$NON_INTERACTIVE" == true ]]; then
      rm -f "$LINK_TARGET" && ln -s "$SHARED_ABS" "$LINK_TARGET"
      echo "Updated symlink in $REPO_NAME -> $SHARED_ABS"
    else
      printf "Update symlink to shared-instructions? [%s -> %s] [y/N]: " "$CUR" "$SHARED_ABS"
      read -r ans
      if [[ "$ans" == [yY] ]]; then
        rm -f "$LINK_TARGET" && ln -s "$SHARED_ABS" "$LINK_TARGET"
        echo "Symlink updated in $REPO_NAME"
      else
        echo "Kept existing symlink in $REPO_NAME"
      fi
    fi
  fi
elif [[ -e "$LINK_TARGET" ]]; then
  echo "Warning: $LINK_TARGET exists and is not a symlink."
  if [[ "$NON_INTERACTIVE" == true ]]; then
    rm -rf "$LINK_TARGET" && ln -s "$SHARED_ABS" "$LINK_TARGET"
    echo "Replaced with symlink in $REPO_NAME"
  else
    printf "Replace with symlink to shared-instructions? [y/N]: "
    read -r ans
    if [[ "$ans" == [yY] ]]; then
      rm -rf "$LINK_TARGET" && ln -s "$SHARED_ABS" "$LINK_TARGET"
      echo "Created symlink in $REPO_NAME"
    else
      echo "Skipped creating symlink in $REPO_NAME"
    fi
  fi
else
  ln -s "$SHARED_ABS" "$LINK_TARGET"
  echo "Created symlink in $REPO_NAME -> $SHARED_ABS"
fi

# Optional VS Code init
if [[ "$INIT_VSCODE" == true ]]; then
  if [[ -x "$SHARED_ABS/scripts/init-shared-instructions-vscode.sh" ]]; then
    echo "Running VS Code init in $REPO_NAME (non-interactive)..."
    (cd "$TARGET_ABS" && "$SHARED_ABS/scripts/init-shared-instructions-vscode.sh" --shared-path "$SHARED_ABS" --non-interactive)
  else
    echo "Init script not found/executable: $SHARED_ABS/scripts/init-shared-instructions-vscode.sh"
  fi
fi

echo "Done."
