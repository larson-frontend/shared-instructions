#!/usr/bin/env zsh
#
# Link Project to Magic Agent — Run from shared-instructions/scripts/
#
# Usage:
#   cd ~/Projects/Fasting-Service/shared-instructions
#   ./scripts/link-project.sh
#
# The script will ask:
#   1. Enter path where the new project should be linked
#   2. Confirm and create symlink
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
  echo "${BLUE}║  ✨ Magic Agent — Link Project                        ║${NC}"
  echo "${BLUE}╚════════════════════════════════════════════════════════╝${NC}"
  echo ""
}

print_success() {
  echo "${GREEN}✓${NC} $1"
}

print_error() {
  echo "${RED}✗${NC} $1"
}

print_warning() {
  echo "${YELLOW}⚠${NC} $1"
}

get_shared_instructions_path() {
  # Walk up from script location to find shared-instructions
  local current_dir="$(pwd)"
  
  # Check if instructions exists in current directory
  if [[ -d "instructions" ]]; then
    echo "$(pwd)"
    return 0
  fi
  
  # Check if we're inside shared-instructions/scripts/
  if [[ -d "scripts" && -d "instructions" ]]; then
    echo "$(pwd)"
    return 0
  fi
  
  # If called from scripts/, go up one level
  if [[ "$(basename "$current_dir")" == "scripts" && -d "../instructions" ]]; then
    echo "$(cd .. && pwd)"
    return 0
  fi
  
  # Fallback: return pwd
  echo "$(pwd)"
}

main() {
  print_header

  # Get shared-instructions path
  SHARED_PATH=$(get_shared_instructions_path)
  
  # Debug: Show what path we detected
  # echo "DEBUG: SHARED_PATH=$SHARED_PATH"
  # echo "DEBUG: checking $SHARED_PATH/instructions"
  
  if [[ ! -d "$SHARED_PATH/instructions" ]]; then
    print_error "Not in shared-instructions directory"
    echo ""
    echo "DEBUG INFO:"
    echo "  Script: $0"
    echo "  Detected path: $SHARED_PATH"
    echo "  Check: $SHARED_PATH/instructions"
    echo "  Exists: $(test -d "$SHARED_PATH/instructions" && echo YES || echo NO)"
    echo ""
    echo "Usage:"
    echo "  ${BLUE}cd ~/Projects/Fasting-Service/shared-instructions${NC}"
    echo "  ${BLUE}./scripts/link-project.sh${NC}"
    exit 1
  fi
  
  print_success "Using shared-instructions: $SHARED_PATH"
  echo ""

  # Ask for project path
  echo "${YELLOW}📁 Project Path:${NC}"
  echo ""
  echo -n "Enter project path (absolute or relative): "
  read PROJECT_PATH
  
  if [[ -z "$PROJECT_PATH" ]]; then
    print_error "Project path cannot be empty"
    exit 1
  fi

  # Expand ~ to home directory
  PROJECT_PATH="${PROJECT_PATH/#\~/$HOME}"

  # Create parent directory if needed
  PROJECT_DIR="$(dirname "$PROJECT_PATH")"
  if [[ ! -d "$PROJECT_DIR" ]]; then
    echo ""
    echo -n "Parent directory does not exist. Create it? (y/n): "
    read CREATE_DIR
    if [[ "$CREATE_DIR" == "y" || "$CREATE_DIR" == "Y" ]]; then
      mkdir -p "$PROJECT_DIR"
      print_success "Created directory: $PROJECT_DIR"
    else
      print_error "Aborted"
      exit 1
    fi
  fi

  # Create project directory if needed
  if [[ ! -d "$PROJECT_PATH" ]]; then
    mkdir -p "$PROJECT_PATH"
    print_success "Created project directory: $PROJECT_PATH"
  fi

  PROJECT_NAME="$(basename "$PROJECT_PATH")"
  
  echo ""
  echo "${BLUE}📊 Summary:${NC}"
  echo "  Project: $PROJECT_NAME"
  echo "  Location: $PROJECT_PATH"
  echo "  Shared Instructions: $SHARED_PATH"
  echo ""
  
  echo -n "Proceed with linking? (y/n): "
  read CONFIRM
  
  if [[ "$CONFIRM" != "y" && "$CONFIRM" != "Y" ]]; then
    print_warning "Linking cancelled"
    exit 0
  fi

  cd "$PROJECT_PATH"
  
  echo ""
  echo "${BLUE}Linking shared-instructions...${NC}"
  
  # Remove existing symlink if any
  if [[ -L shared-instructions ]]; then
    rm shared-instructions
    print_warning "Removed existing symlink"
  fi
  
  # Create symlink (absolute path)
  if ln -s "$SHARED_PATH" shared-instructions; then
    print_success "Symlink created: shared-instructions"
  else
    print_error "Failed to create symlink"
    exit 1
  fi
  
  # Verification
  if [[ -d shared-instructions/instructions ]]; then
    print_success "Linking verified successfully!"
    
    echo ""
    echo "${GREEN}╔════════════════════════════════════════════════════════╗${NC}"
    echo "${GREEN}║  ✓ Project Linked!                                    ║${NC}"
    echo "${GREEN}╚════════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo "📁 Project: $PROJECT_NAME"
    echo "📂 Location: $PROJECT_PATH"
    echo "🔗 Symlink: shared-instructions → $SHARED_PATH"
    echo ""
    echo "${YELLOW}🔧 Next Steps:${NC}"
    echo ""
    echo "  1. Open project in VS Code:"
    echo "     ${BLUE}code $PROJECT_PATH${NC}"
    echo ""
    echo "  2. Reload VS Code:"
    echo "     ${BLUE}Ctrl+Shift+P → 'Reload Window'${NC}"
    echo ""
    echo "  3. Start using Magic Agent:"
    echo "     ${BLUE}Press Ctrl+I in any file${NC}"
    echo ""
    echo "  4. View documentation:"
    echo "     ${BLUE}cat shared-instructions/docs/QUICK_SETUP.md${NC}"
    echo ""
    echo "${GREEN}Happy coding! 🚀${NC}"
    echo ""
  else
    print_error "Linking verification failed"
    exit 1
  fi
}

# Run main
main
