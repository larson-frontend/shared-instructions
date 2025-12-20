#!/usr/bin/env zsh

set -euo pipefail

# init-shared-instructions-jetbrains
# Sets up symlinks and optional JetBrains (IntelliJ IDEA) project settings
# to leverage shared-instructions across projects.

usage() {
  cat <<'USAGE'
Usage: ./scripts/init-shared-instructions-jetbrains.sh [--shared-path <path>] [--non-interactive]

Options:
  --shared-path <path>   Path to shared-instructions directory (default: ../shared-instructions)
  --non-interactive      Assume defaults: create/overwrite symlinks; apply optional settings if available

Run from your project root (contains `.idea/`). This script will:
  1) Create/refresh `shared-instructions` symlink
  2) If present in shared-instructions, link JetBrains code style and inspection profiles
     - shared-instructions/jetbrains/codeStyles/Project.xml -> .idea/codeStyles/Project.xml
     - shared-instructions/jetbrains/inspectionProfiles/Project_Default.xml -> .idea/inspectionProfiles/Project_Default.xml
USAGE
}

SHARED_PATH="../shared-instructions"
NON_INTERACTIVE=false

while [[ $# -gt 0 ]]; do
  case "$1" in
    --shared-path)
      SHARED_PATH="$2"; shift 2;;
    --non-interactive)
      NON_INTERACTIVE=true; shift;;
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

# Agent usage logging guidance
echo "\nTip: Log this setup in agent-usage.md (optional):"
echo "  ./shared-instructions/scripts/log-agent-usage.sh \\
  --agent \"Custom Auto\" \\
  --task setup \\
  --model <model> \\
  --status primary \\
  --desc \"Linked JetBrains settings to shared-instructions\""
