#!/usr/bin/env bash
# link.sh — symlink this vault's MASTER_PROMPT.md into agent config locations.
#
# Usage: ./scripts/link.sh [-f] [--vault <vault-dir>] [--dir <project-dir>] <agent...>
#
# Available agents: claude, codex, opencode
#
# Options:
#   -f               Force — overwrite existing symlinks or files at the destination.
#                    Without -f, the script errors and skips any destination that already exists.
#   --vault <path>   Path to the Palimpsest vault containing MASTER_PROMPT.md.
#                    Defaults to the parent directory of this script.
#   --dir <path>     Link into a project directory instead of the global agent config.
#                    Destinations become project-scoped:
#                      claude   → <path>/CLAUDE.md
#                      codex    → <path>/AGENTS.md
#                      opencode → <path>/.opencode/AGENTS.md
#                    When omitted, links to the global config (~/.claude/CLAUDE.md, etc.).
#
# Examples:
#   # Link to global agent configs (typical first-time setup)
#   ./scripts/link.sh claude
#   ./scripts/link.sh -f claude codex opencode
#
#   # Link to a project directory so agents load the vault when working in that tree
#   ./scripts/link.sh --vault ~/.agents --dir ~/code/ai claude opencode
#
# Run this from anywhere — paths are resolved relative to this script's location
# unless --vault is provided.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Symlink destination for each supported agent — global or project-scoped.
# Case statement instead of an associative array so this script runs on stock
# macOS bash 3.2 without Homebrew bash. Returns 1 for unknown agents.
agent_dest() {
  local agent="$1" dir="${2:-}"
  if [[ -n "$dir" ]]; then
    case "$agent" in
      claude)   printf '%s\n' "$dir/CLAUDE.md" ;;
      codex)    printf '%s\n' "$dir/AGENTS.md" ;;
      opencode) printf '%s\n' "$dir/.opencode/AGENTS.md" ;;
      *)        return 1 ;;
    esac
  else
    case "$agent" in
      claude)   printf '%s\n' "$HOME/.claude/CLAUDE.md" ;;
      codex)    printf '%s\n' "$HOME/.codex/AGENTS.md" ;;
      opencode) printf '%s\n' "$HOME/.config/opencode/AGENTS.md" ;;
      *)        return 1 ;;
    esac
  fi
}

SUPPORTED_AGENTS="claude codex opencode"

usage() {
  echo "Usage: ./scripts/link.sh [-f] [--vault <vault-dir>] [--dir <project-dir>] <agent...>" >&2
  echo "       Agents: $SUPPORTED_AGENTS" >&2
  echo "       -f               overwrite existing destinations" >&2
  echo "       --vault <path>   vault containing MASTER_PROMPT.md (default: parent of this script)" >&2
  echo "       --dir <path>     link into a project directory instead of the global config" >&2
  exit 1
}

FORCE=0
VAULT_DIR="$(dirname "$SCRIPT_DIR")"
DIR=""

while [[ $# -ge 1 ]]; do
  case "$1" in
    -f)       FORCE=1;          shift ;;
    --vault)  VAULT_DIR="${2%/}"; shift 2 ;;
    --dir)    DIR="${2%/}";       shift 2 ;;
    --)       shift; break ;;
    -*)       echo "Error: unknown flag '$1'" >&2; usage ;;
    *)        break ;;
  esac
done

MASTER_PROMPT="$VAULT_DIR/MASTER_PROMPT.md"

[[ $# -ge 1 ]] || usage

if [[ ! -f "$MASTER_PROMPT" ]]; then
  echo "Error: MASTER_PROMPT.md not found at $MASTER_PROMPT" >&2
  echo "       Use --vault <path> to specify the vault directory, or run this script" >&2
  echo "       from inside a Palimpsest vault." >&2
  exit 1
fi

errors=0

for agent in "$@"; do
  if ! dest="$(agent_dest "$agent" "$DIR")"; then
    echo "Error: unknown agent '$agent'. Choose from: $SUPPORTED_AGENTS" >&2
    errors=$((errors + 1))
    continue
  fi

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
