#!/usr/bin/env bash
# init.sh — scaffold a new Palimpsest vault from the bundled templates.
#
# Usage: ./scripts/init.sh <directory>
#
# Creates the full scratchpad + skills directory structure in <directory>,
# then replaces TODO date placeholders in all .md files with today's date.
# Safe to run against a new directory; refuses to overwrite an existing vault.
set -euo pipefail

# Resolve paths relative to this script so it works from any working directory.
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TEMPLATES_DIR="$SCRIPT_DIR/../templates"

usage() {
  echo "📜 Usage: ./scripts/init.sh <directory>" >&2
  echo "       Scaffold a new Palimpsest vault in <directory>." >&2
  exit 1
}

[[ $# -eq 1 ]] || usage

# Create the directory before resolving its real path (realpath requires it to exist on macOS).
mkdir -p "$1"
TARGET="$(realpath "$1")"

# Guard: refuse to reinitialize an existing vault.
if [[ -f "$TARGET/scratchpad/profile.md" ]]; then
  echo "Error: $TARGET is already a Palimpsest vault (scratchpad/profile.md exists)" >&2
  exit 1
fi

# Copy the full templates tree into the target directory.
cp -r "$TEMPLATES_DIR/." "$TARGET/"

# Replace TODO date sentinels with today's date (ISO 8601).
# The .bak dance is required for sed -i portability on macOS.
TODAY="$(date +%Y-%m-%d)"
while IFS= read -r -d '' file; do
  sed -i.bak "s/TODO/$TODAY/g" "$file" && rm "${file}.bak"
done < <(find "$TARGET" -name "*.md" -print0)

echo "📜 Initialized Palimpsest vault in $TARGET"
echo ""
echo "Next steps:"
echo "  1. Open INIT_PROMPT.md and follow the setup conversation:"
echo "       cd $TARGET && claude INIT_PROMPT.md"
echo "  2. Link your agent tools (run from the palimpsest repo):"
echo "       ./scripts/link.sh claude"
echo "     or for multiple agent tools:"
echo "       ./scripts/link.sh claude codex opencode"
