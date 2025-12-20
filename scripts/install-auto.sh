#!/usr/bin/env zsh
set -euo pipefail

# install-auto.sh
# Auto-detect OS/shell and run the appropriate installer.
# Falls back to asking the user which terminal to use.
#
# Forwards common flags to the underlying installer:
#   --workspace <path>
#   --shared-path <path>
#   --target <repo-path>
#   --ide <vscode|jetbrains|eclipse>
#   --non-interactive

SCRIPT_DIR=$(cd -- "$(dirname "$0")" && pwd)
PS_SCRIPT="$SCRIPT_DIR/install-shared-instructions.ps1"
SH_SCRIPT="$SCRIPT_DIR/install-shared-instructions.sh"

# Collect and forward args
ARGS=("$@")

exists() { command -v "$1" >/dev/null 2>&1 }

os_name=$(uname -s 2>/dev/null || echo "unknown")

# Windows-like environments (Git Bash/MINGW/MSYS/Cygwin)
if [[ "$os_name" == MINGW* || "$os_name" == MSYS* || "$os_name" == CYGWIN* ]]; then
  if exists powershell.exe && [[ -f "$PS_SCRIPT" ]]; then
    echo "Detected Windows environment; using PowerShell installer."
    powershell.exe -NoProfile -ExecutionPolicy Bypass -File "$PS_SCRIPT" $ARGS
    exit 0
  fi
  echo "Windows environment detected but PowerShell not found."
  echo "Which terminal are you using?"
  echo "  1) bash/zsh (Git Bash/MSYS)"
  echo "  2) PowerShell (provide path)"
  printf "Enter choice [1/2]: "
  read -r choice
  case "$choice" in
    1)
      [[ -f "$SH_SCRIPT" ]] || { echo "Error: $SH_SCRIPT missing" >&2; exit 1; }
      "$SH_SCRIPT" "$@"
      ;;
    2)
      printf "Enter full path to powershell.exe: "
      read -r pspath
      [[ -x "$pspath" ]] || { echo "Error: powershell.exe not executable: $pspath" >&2; exit 1; }
      "$pspath" -NoProfile -ExecutionPolicy Bypass -File "$PS_SCRIPT" $ARGS
      ;;
    *)
      echo "Invalid choice" >&2; exit 1;;
  esac
  exit 0
fi

# Non-Windows (Linux/macOS)
if [[ -f "$SH_SCRIPT" ]]; then
  "$SH_SCRIPT" "$@"
  exit 0
fi

# Fallback prompt
echo "Could not auto-detect environment."
echo "Which terminal are you using?"
echo "  1) bash/zsh (Linux/macOS)"
echo "  2) PowerShell (Windows)"
printf "Enter choice [1/2]: "
read -r choice
case "$choice" in
  1)
    [[ -f "$SH_SCRIPT" ]] || { echo "Error: $SH_SCRIPT missing" >&2; exit 1; }
    "$SH_SCRIPT" "$@"
    ;;
  2)
    if exists powershell || exists pwsh; then
      psbin=$(exists pwsh && echo pwsh || echo powershell)
      "$psbin" -ExecutionPolicy Bypass -File "$PS_SCRIPT" $ARGS
    else
      echo "PowerShell not found. Please run:"
      echo "powershell -ExecutionPolicy Bypass -File shared-instructions/scripts/install-shared-instructions.ps1"
      exit 1
    fi
    ;;
  *)
    echo "Invalid choice" >&2; exit 1;;
}
