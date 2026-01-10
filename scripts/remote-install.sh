#!/usr/bin/env zsh
#
# Magic Agent — Remote Install Script
#
# One-command remote installation: Clone shared-instructions + project + link
#
# Usage:
#   curl -fsSL https://raw.githubusercontent.com/larson-frontend/shared-instructions/main/scripts/remote-install.sh | zsh -s -- <PROJECT_REPO_URL> [PROJECT_NAME] [INSTALL_DIR]
#
# Examples:
#   curl -fsSL https://...remote-install.sh | zsh -s -- https://github.com/user/my-project
#   curl -fsSL https://...remote-install.sh | zsh -s -- https://github.com/user/my-project my-app ~/projects
#

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

print_header() {
  echo ""
  echo "${BLUE}╔════════════════════════════════════════════════════════╗${NC}"
  echo "${BLUE}║  ✨ Magic Agent — Remote Installer                    ║${NC}"
  echo "${BLUE}╚════════════════════════════════════════════════════════╝${NC}"
  echo ""
}

print_success() {
  echo "${GREEN}✓${NC} $1"
}

print_error() {
  echo "${RED}✗${NC} $1"
}

print_info() {
  echo "${BLUE}ℹ${NC} $1"
}

show_usage() {
  echo "${YELLOW}Usage:${NC}"
  echo ""
  echo "  ${BLUE}curl -fsSL https://raw.githubusercontent.com/larson-frontend/shared-instructions/main/scripts/remote-install.sh | zsh -s -- <PROJECT_REPO> [PROJECT_NAME] [INSTALL_DIR]${NC}"
  echo ""
  echo "Examples:"
  echo "  ${BLUE}curl ... | zsh -s -- https://github.com/user/my-project${NC}"
  echo "  ${BLUE}curl ... | zsh -s -- https://github.com/user/my-project my-app ~/projects${NC}"
  echo ""
}

main() {
  print_header
  
  PROJECT_REPO="$1"
  PROJECT_NAME="$2"
  INSTALL_DIR="$3"
  
  if [[ -z "$PROJECT_REPO" ]]; then
    print_error "Project repository URL required"
    show_usage
    exit 1
  fi
  
  # Parse project name from URL if not provided
  if [[ -z "$PROJECT_NAME" ]]; then
    PROJECT_NAME="${PROJECT_REPO##*/}"
    PROJECT_NAME="${PROJECT_NAME%.git}"
  fi
  
  # Default install dir to current directory
  if [[ -z "$INSTALL_DIR" ]]; then
    INSTALL_DIR="$(pwd)"
  fi
  
  # Expand ~
  INSTALL_DIR="${INSTALL_DIR/#\~/$HOME}"
  
  # Create install directory if needed
  mkdir -p "$INSTALL_DIR"
  cd "$INSTALL_DIR"
  
  print_info "Install directory: $INSTALL_DIR"
  echo ""
  
  # Step 1: Clone shared-instructions
  echo "${YELLOW}📦 Step 1/3: Cloning shared-instructions...${NC}"
  SHARED_REPO="https://github.com/larson-frontend/shared-instructions.git"
  
  if [[ -d "shared-instructions" ]]; then
    print_info "shared-instructions already exists, updating..."
    cd shared-instructions
    git pull origin main 2>&1 | head -3
    cd ..
  else
    if git clone "$SHARED_REPO" shared-instructions 2>&1 | head -5; then
      print_success "shared-instructions cloned"
    else
      print_error "Failed to clone shared-instructions"
      exit 1
    fi
  fi
  
  echo ""
  
  # Step 2: Clone project
  echo "${YELLOW}📦 Step 2/3: Cloning project...${NC}"
  
  if [[ -d "$PROJECT_NAME" ]]; then
    print_error "Project directory already exists: $PROJECT_NAME"
    echo ""
    echo "Options:"
    echo "  1. Remove it: ${BLUE}rm -rf $INSTALL_DIR/$PROJECT_NAME${NC}"
    echo "  2. Choose different name"
    exit 1
  fi
  
  if git clone "$PROJECT_REPO" "$PROJECT_NAME" 2>&1 | head -5; then
    print_success "Project cloned: $PROJECT_NAME"
  else
    print_error "Failed to clone project"
    exit 1
  fi
  
  echo ""
  
  # Step 3: Create symlink
  echo "${YELLOW}🔗 Step 3/3: Linking Magic Agent...${NC}"
  
  cd "$PROJECT_NAME"
  
  SHARED_PATH="$INSTALL_DIR/shared-instructions"
  
  if [[ -L shared-instructions ]]; then
    rm shared-instructions
    print_info "Removed existing symlink"
  fi
  
  if ln -s "$SHARED_PATH" shared-instructions; then
    print_success "Symlink created"
  else
    print_error "Failed to create symlink"
    exit 1
  fi
  
  # Verify
  if [[ -d shared-instructions/instructions ]]; then
    print_success "Installation verified"
    
    echo ""
    echo "${GREEN}╔════════════════════════════════════════════════════════╗${NC}"
    echo "${GREEN}║  ✓ Installation Complete!                             ║${NC}"
    echo "${GREEN}╚════════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo "📁 Project: $PROJECT_NAME"
    echo "📂 Location: $(pwd)"
    echo "🔗 Shared Instructions: $SHARED_PATH"
    echo ""
    echo "${YELLOW}🔧 Next Steps:${NC}"
    echo ""
    echo "  1. Open in VS Code:"
    echo "     ${BLUE}code $INSTALL_DIR/$PROJECT_NAME${NC}"
    echo ""
    echo "  2. Reload VS Code:"
    echo "     ${BLUE}Ctrl+Shift+P → 'Reload Window'${NC}"
    echo ""
    echo "  3. Start using Magic Agent:"
    echo "     ${BLUE}Press Ctrl+I in any file${NC}"
    echo ""
    echo "  4. View documentation:"
    echo "     ${BLUE}cat shared-instructions/INSTALL.md${NC}"
    echo ""
    echo "${GREEN}Happy coding! 🚀${NC}"
    echo ""
  else
    print_error "Installation verification failed"
    exit 1
  fi
}

main "$@"
