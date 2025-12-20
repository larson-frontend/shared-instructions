#!/usr/bin/env zsh
set -euo pipefail

# link-shared-instructions.sh
# Interactively creates a `shared-instructions` symlink inside a selected repo.
# Optionally runs the VS Code init script in that repo.
#
# Usage:
#   ./shared-instructions/scripts/link-shared-instructions.sh \
#     [--workspace <path>] [--shared-path <path>] [--non-interactive] [--target <repo-path>] [--init-vscode]
#
# Defaults:
#   --workspace     Parent folder containing repos (default: workspace root = parent of shared-instructions)
#   --shared-path   Path to shared-instructions (default: script's parent directory)
#   --non-interactive  Skip prompts; requires --target
#   --target        Repo directory to install symlink into (used with --non-interactive)
#   --init-vscode   Run VS Code init script after linking (non-interactive)

WORKSPACE=""
SHARED_PATH=""
NON_INTERACTIVE=false
TARGET_REPO=""
INIT_VSCODE=false

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
    --init-vscode) INIT_VSCODE=true; shift;;
    -h|--help)
      cat <<'USAGE'
Interactively link shared-instructions into a selected repo.
Options:
  --workspace <path>      Root directory containing project repos (default: parent of shared-instructions)
  --shared-path <path>    Path to shared-instructions (default: this script's parent)
  --non-interactive       Skip prompts (requires --target). Also respects --init-vscode
  --target <repo-path>    Repo directory to install symlink into
  --init-vscode           Run VS Code init script after linking (non-interactive)
Examples:
  ./shared-instructions/scripts/link-shared-instructions.sh
  ./shared-instructions/scripts/link-shared-instructions.sh --init-vscode
  ./shared-instructions/scripts/link-shared-instructions.sh --non-interactive --target ./fasting-frontend --init-vscode
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
  if [[ -z "$TARGET_REPO" ]]; then
    echo "Error: --non-interactive requires --target <repo-path>" >&2
    exit 1
  fi
  TARGET_ABS=$(realpath "$TARGET_REPO" 2>/dev/null || true)
  if [[ -z "$TARGET_ABS" || ! -d "$TARGET_ABS" ]]; then
    echo "Error: target repo not found: $TARGET_REPO" >&2
    exit 1
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
