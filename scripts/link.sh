#!/usr/bin/env bash
# link.sh — symlink this vault's MASTER_PROMPT.md into agent config locations.
#
# Usage: ./scripts/link.sh [-f] <agent...>
#
# Available agents: claude, codex, opencode
#
# Options:
#   -f    Force — overwrite existing symlinks or files at the destination.
#         Without -f, the script errors and skips any destination that already exists.
#
# Examples:
#   ./scripts/link.sh claude
#   ./scripts/link.sh claude opencode
#   ./scripts/link.sh -f claude codex opencode
#
# Run this from anywhere — paths are resolved relative to this script's location.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
VAULT_DIR="$(dirname "$SCRIPT_DIR")"
MASTER_PROMPT="$VAULT_DIR/MASTER_PROMPT.md"

# Symlink destinations for each supported agent.
declare -A AGENT_DEST=(
  [claude]="$HOME/.claude/CLAUDE.md"
  [codex]="$HOME/.codex/AGENTS.md"
  [opencode]="$HOME/.config/opencode/AGENTS.md"
)

usage() {
  echo "Usage: ./scripts/link.sh [-f] <agent...>" >&2
  echo "       Agents: claude, codex, opencode" >&2
  echo "       -f  overwrite existing destinations" >&2
  exit 1
}

FORCE=0
if [[ "${1:-}" == "-f" ]]; then
  FORCE=1
  shift
fi

[[ $# -ge 1 ]] || usage

if [[ ! -f "$MASTER_PROMPT" ]]; then
  echo "Error: MASTER_PROMPT.md not found at $MASTER_PROMPT" >&2
  echo "       Is this script inside a Palimpsest vault?" >&2
  exit 1
fi

errors=0

for agent in "$@"; do
  if [[ -z "${AGENT_DEST[$agent]:-}" ]]; then
    echo "Error: unknown agent '$agent'. Choose from: ${!AGENT_DEST[*]}" >&2
    errors=$((errors + 1))
    continue
  fi

  dest="${AGENT_DEST[$agent]}"

  if [[ -e "$dest" || -L "$dest" ]]; then
    if [[ $FORCE -eq 0 ]]; then
      echo "Error: $dest already exists (use -f to overwrite)" >&2
      errors=$((errors + 1))
      continue
    fi
  fi

  mkdir -p "$(dirname "$dest")"
  ln -sfn "$MASTER_PROMPT" "$dest"
  echo "Linked $agent → $dest"
done

if [[ $errors -gt 0 ]]; then
  exit 1
fi
