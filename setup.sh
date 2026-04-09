#!/usr/bin/env bash
# ============================================================
# AI Dev Boilerplate — Setup Script
#
# Copies engineering standards, skills, agents, commands, and
# provider instruction files into your project.
#
# Usage:
#   ./setup.sh /path/to/your-project
#
# Supports: Claude Code, Codex, Cursor, Windsurf, Cline,
#           GitHub Copilot, Kimi, DeepSeek, and any AI tool
#           that reads markdown instruction files.
# ============================================================

set -euo pipefail

BOILERPLATE_DIR="$(cd "$(dirname "$0")" && pwd)"
TARGET_DIR="${1:-.}"

if [ "$TARGET_DIR" = "." ]; then
  echo "Usage: ./setup.sh /path/to/your-project"
  echo ""
  echo "This will copy all engineering standards and AI provider"
  echo "instruction files into the target project."
  exit 1
fi

if [ ! -d "$TARGET_DIR" ]; then
  echo "Error: Target directory '$TARGET_DIR' does not exist."
  exit 1
fi

echo "Setting up AI dev boilerplate in: $TARGET_DIR"
echo ""

# Core engineering standards
cp "$BOILERPLATE_DIR/CLAUDE.md" "$TARGET_DIR/"
echo "  Copied CLAUDE.md (engineering standards)"

# Provider instruction files
cp "$BOILERPLATE_DIR/AGENTS.md" "$TARGET_DIR/"
echo "  Copied AGENTS.md (Codex)"

cp "$BOILERPLATE_DIR/.cursorrules" "$TARGET_DIR/"
echo "  Copied .cursorrules (Cursor)"

cp "$BOILERPLATE_DIR/.windsurfrules" "$TARGET_DIR/"
echo "  Copied .windsurfrules (Windsurf)"

cp "$BOILERPLATE_DIR/.clinerules" "$TARGET_DIR/"
echo "  Copied .clinerules (Cline)"

cp "$BOILERPLATE_DIR/.kimi" "$TARGET_DIR/"
echo "  Copied .kimi (Kimi)"

cp "$BOILERPLATE_DIR/.deepseek" "$TARGET_DIR/"
echo "  Copied .deepseek (DeepSeek)"

mkdir -p "$TARGET_DIR/.github"
cp "$BOILERPLATE_DIR/.github/copilot-instructions.md" "$TARGET_DIR/.github/"
echo "  Copied .github/copilot-instructions.md (GitHub Copilot)"

# Claude Code specific (skills, commands, agents, plugins, hooks)
cp -r "$BOILERPLATE_DIR/.claude" "$TARGET_DIR/"
echo "  Copied .claude/ (skills, commands, agents, plugins, hooks)"

# Create .ai symlink for provider-agnostic paths
if [ ! -e "$TARGET_DIR/.ai" ]; then
  ln -s .claude "$TARGET_DIR/.ai"
  echo "  Created .ai -> .claude symlink"
fi

# Handoff templates
mkdir -p "$TARGET_DIR/handoff"
cp "$BOILERPLATE_DIR/handoff/HANDOFF_TEMPLATE.md" "$TARGET_DIR/handoff/"
cp "$BOILERPLATE_DIR/handoff/SESSION_MEMORY.md" "$TARGET_DIR/handoff/"
cp "$BOILERPLATE_DIR/handoff/E2E_TESTING_GUIDE.md" "$TARGET_DIR/handoff/"
echo "  Copied handoff/ templates"

# Docs and contracts
mkdir -p "$TARGET_DIR/docs/contracts"
cp "$BOILERPLATE_DIR/docs/AGENT_COORDINATION.md" "$TARGET_DIR/docs/"
cp "$BOILERPLATE_DIR/docs/contracts/_enums.contract.ts" "$TARGET_DIR/docs/contracts/"
echo "  Copied docs/ (agent coordination + enum contract template)"

echo ""
echo "Done! Next steps:"
echo "  1. Open CLAUDE.md and replace [Project Name], [Your Name], etc."
echo "  2. Update docs/contracts/_enums.contract.ts with your project's enums"
echo "  3. Fill in handoff/SESSION_MEMORY.md with architecture decisions"
echo "  4. Start building with any AI coding tool"
