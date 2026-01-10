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
  
  # Setup statistics before linking
  setup_stats "$(pwd)"
  
  if ln -s "$SHARED_PATH" shared-instructions; then
    print_success "Symlink created"
  else
    print_error "Failed to create symlink"
    exit 1
  fi
  
  # Verify
setup_stats() {
  local PROJECT_DIR="$1"
  
  print_info "Setting up agent usage tracking..."
  
  # Create .agent-usage.md in project root
  cat > "$PROJECT_DIR/.agent-usage.md" << 'EOF'
# Agent Usage Statistics

This file tracks Magic Agent usage in your project.
Auto-generated and managed by shared-instructions.

## Log Format
[YYYY-MM-DD HH:MM] agent=AGENT_NAME task=TASK_TYPE model=MODEL_NAME status=STATUS lang=LANGUAGE desc=DESCRIPTION

EOF
  
  # Update .gitignore to exclude stats
  if [[ -f "$PROJECT_DIR/.gitignore" ]]; then
    if ! grep -q "\.agent-usage" "$PROJECT_DIR/.gitignore"; then
      echo "" >> "$PROJECT_DIR/.gitignore"
      echo "# Magic Agent Usage Tracking (local only)" >> "$PROJECT_DIR/.gitignore"
      echo ".agent-usage.md" >> "$PROJECT_DIR/.gitignore"
      print_success "Updated .gitignore for agent usage tracking"
    fi
  else
    cat > "$PROJECT_DIR/.gitignore" << 'EOF'
# Magic Agent Usage Tracking (local only)
.agent-usage.md
EOF
    print_success "Created .gitignore with agent usage tracking"
  fi
}

main "$@"
