#!/usr/bin/env zsh
#
# Clone & Link Script — Clone a repo and link shared-instructions automatically
#
# Usage:
#   ./clone-and-link.sh <REPO_URL> [PROJECT_NAME] [SHARED_PATH]
#
# Examples:
#   ./clone-and-link.sh https://github.com/user/my-project
#   ./clone-and-link.sh https://github.com/user/my-project my-project /path/to/shared-instructions
#

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

print_header() {
  echo ""
  echo "${BLUE}🚀 Clone & Link Script${NC}"
  echo ""
}

print_success() {
  echo "${GREEN}✓${NC} $1"
}

print_error() {
  echo "${RED}✗${NC} $1"
}

# Parse arguments
REPO_URL="$1"
PROJECT_NAME="${2:-$(basename "$REPO_URL" .git)}"
SHARED_PATH="${3:-.../shared-instructions}"

if [[ -z "$REPO_URL" ]]; then
  echo "Usage: $0 <REPO_URL> [PROJECT_NAME] [SHARED_PATH]"
  echo ""
  echo "Examples:"
  echo "  $0 https://github.com/user/my-project"
  echo "  $0 https://github.com/user/my-project my-project /path/to/shared-instructions"
  exit 1
fi

print_header

echo "📋 Configuration:"
echo "  Repo: $REPO_URL"
echo "  Project: $PROJECT_NAME"
echo "  Shared Path: $SHARED_PATH"
echo ""

# Clone repository
echo "🔄 Cloning repository..."
git clone "$REPO_URL" "$PROJECT_NAME" || {
  print_error "Failed to clone repository"
  exit 1
}
print_success "Repository cloned to: $PROJECT_NAME"

# Change into project directory
cd "$PROJECT_NAME"

# Create symlink
echo ""
echo "🔗 Creating symlink..."

# Resolve shared path
if [[ "$SHARED_PATH" == ".."* ]]; then
  # Relative path - use as is
  SYMLINK_TARGET="$SHARED_PATH"
else
  # Absolute path - check if it exists
  if [[ ! -d "$SHARED_PATH" ]]; then
    print_error "Shared path does not exist: $SHARED_PATH"
    exit 1
  fi
  SYMLINK_TARGET="$SHARED_PATH"
fi

# Remove existing symlink if any
if [[ -L shared-instructions ]]; then
  rm shared-instructions
fi

# Create symlink
ln -s "$SYMLINK_TARGET" shared-instructions
print_success "Symlink created: shared-instructions → $SYMLINK_TARGET"

echo ""
echo "${GREEN}╔════════════════════════════════════════════════════════╗${NC}"
echo "${GREEN}║  ✓ Setup Complete!                                     ║${NC}"
echo "${GREEN}╚════════════════════════════════════════════════════════╝${NC}"
echo ""
echo "📁 Project: $PROJECT_NAME"
echo "📂 Location: $(pwd)"
echo ""
echo "Next steps:"
echo "  1. cd $PROJECT_NAME"
echo "  2. VS Code: Ctrl+Shift+P → 'Reload Window'"
echo "  3. Start coding!"
echo ""
