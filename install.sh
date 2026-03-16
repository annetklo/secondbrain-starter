#!/bin/bash
# Second Brain Starter Kit Installer
# by Mission Relearn (https://missionrelearn.com)
#
# Usage: curl -sL https://lab.missionrelearn.com/install.sh | bash
#
set -e

VERSION="1.0.0"
REPO_TARBALL="https://github.com/annetklo/secondbrain-starter/archive/refs/heads/main.tar.gz"
CLAUDE_DIR="$HOME/.claude"

# Colors
CORAL='\033[38;2;243;110;89m'
BOLD='\033[1m'
DIM='\033[2m'
RESET='\033[0m'

print_banner() {
  echo ""
  echo -e "${CORAL}${BOLD}  Second Brain Starter Kit${RESET}"
  echo -e "${DIM}  by Mission Relearn | v${VERSION}${RESET}"
  echo ""
}

print_step() {
  echo -e "${CORAL}>>>${RESET} $1"
}

print_skip() {
  echo -e "${DIM}    skip: $1 (already exists)${RESET}"
}

print_create() {
  echo -e "    ${BOLD}+${RESET} $1"
}

# Safe copy: never overwrite existing files
safe_copy() {
  local src="$1"
  local dest="$2"
  if [ -e "$dest" ]; then
    print_skip "$dest"
    return
  fi
  mkdir -p "$(dirname "$dest")"
  cp "$src" "$dest"
  print_create "$dest"
}

# Safe copy directory: copy files inside, never overwrite existing
safe_copy_dir() {
  local src="$1"
  local dest="$2"
  find "$src" -type f | while read -r file; do
    local rel="${file#$src/}"
    safe_copy "$file" "$dest/$rel"
  done
}

print_banner

echo "This will install the Second Brain starter kit to ~/.claude/"
echo ""
echo "What gets installed:"
echo "  - CLAUDE.md template (your master configuration)"
echo "  - 3 skills: meeting-prep, morning-briefing, skill-creator"
echo "  - Memory templates (voice, style preferences)"
echo "  - Knowledge templates (brand guidelines)"
echo "  - Session start hook"
echo "  - Growth log for tracking progress"
echo "  - Full methodology guide"
echo ""
echo -e "${DIM}Existing files will NOT be overwritten.${RESET}"
echo ""

# Check if running interactively
if [ -t 0 ]; then
  read -p "Continue? [Y/n] " confirm
  if [[ "$confirm" =~ ^[Nn] ]]; then
    echo "Cancelled."
    exit 0
  fi
fi

# Download and extract
print_step "Downloading starter kit..."
tmp=$(mktemp -d)
trap "rm -rf $tmp" EXIT

curl -sL "$REPO_TARBALL" -o "$tmp/starter.tar.gz"
tar xzf "$tmp/starter.tar.gz" -C "$tmp"

# Find the extracted directory (github adds branch name)
STARTER_DIR=$(find "$tmp" -maxdepth 1 -type d -name "secondbrain-starter-*" | head -1)
if [ -z "$STARTER_DIR" ]; then
  echo "Error: could not extract starter kit."
  exit 1
fi

SRC="$STARTER_DIR/starter"

# Install CLAUDE.md
print_step "Setting up CLAUDE.md..."
safe_copy "$SRC/CLAUDE.md" "$CLAUDE_DIR/CLAUDE.md"

# Install skills
print_step "Installing skills..."
safe_copy_dir "$SRC/.claude/skills/meeting-prep" "$CLAUDE_DIR/skills/meeting-prep"
safe_copy_dir "$SRC/.claude/skills/morning-briefing" "$CLAUDE_DIR/skills/morning-briefing"
safe_copy_dir "$SRC/.claude/skills/skill-creator" "$CLAUDE_DIR/skills/skill-creator"

# Install memory templates
print_step "Setting up memory system..."
safe_copy_dir "$SRC/.claude/memory" "$CLAUDE_DIR/memory"

# Install knowledge templates
print_step "Setting up knowledge base..."
safe_copy_dir "$SRC/.claude/knowledge" "$CLAUDE_DIR/knowledge"

# Install hooks
print_step "Installing hooks..."
safe_copy_dir "$SRC/.claude/hooks" "$CLAUDE_DIR/hooks"
chmod +x "$CLAUDE_DIR/hooks/session-start.sh" 2>/dev/null || true

# Install brain-health
print_step "Setting up growth tracking..."
safe_copy_dir "$SRC/.claude/brain-health" "$CLAUDE_DIR/brain-health"

# Install examples
print_step "Adding examples..."
safe_copy_dir "$SRC/.claude/examples" "$CLAUDE_DIR/examples"

# Install guide
print_step "Installing guide..."
mkdir -p "$CLAUDE_DIR/docs"
safe_copy "$SRC/docs/guide.md" "$CLAUDE_DIR/docs/guide.md"

# Done
echo ""
echo -e "${CORAL}${BOLD}  Done! Your Second Brain starter kit is installed.${RESET}"
echo ""
echo "  Next steps:"
echo "  1. Open ~/.claude/CLAUDE.md and personalize it"
echo "  2. Start Claude Code and type: /morning-briefing"
echo "  3. Build your first custom skill: /skill-creator"
echo "  4. Read the guide: ~/.claude/docs/guide.md"
echo ""
echo -e "  ${DIM}Want 22+ skills, agents, and full automation?${RESET}"
echo -e "  ${CORAL}https://secondbrain.missionrelearn.com/#pricing${RESET}"
echo ""
