#!/usr/bin/env bash
# scan-worktrees.sh — audit registered git worktrees by size, mtime, branch
# state, and linked scratchpad issue.
#
# Usage: scripts/scan-worktrees.sh [repo-path]
#
# Environment:
#   PALIMPSEST_VAULT  Path to the palimpsest vault root (for scratchpad issue
#                     correlation). Defaults to $HOME if unset.
set -euo pipefail

repo_root=$(git -C "${1:-.}" rev-parse --show-toplevel)
vault_root="${PALIMPSEST_VAULT:-$HOME}"
issues_root="$vault_root/scratchpad/issues"
archive_root="$vault_root/scratchpad/archive/issues"
now=$(date +%s)

mtime() { stat -f %m "$1" 2>/dev/null || stat -c %Y "$1"; }
stamp() { date -r "$1" +%F 2>/dev/null || date -d "@$1" +%F; }
issue_status() { rg -m1 '^status: ' "$1" 2>/dev/null | cut -d: -f2- | xargs; }
issue_ref() { printf 'scratchpad#%s' "$(basename "$1" | cut -d- -f1)"; }

find_issue() {
  local branch=$1 name=${2##*/} match=''
  [[ ! -d "$issues_root" ]] && { printf ''; return; }
  if [[ -n "$branch" && "$branch" == */* ]]; then
    match=$(rg -l -F "\`$branch\`" "$issues_root" "$archive_root" 2>/dev/null | sed -n '1p' || true)
  fi
  if [[ -z "$match" ]]; then
    match=$(rg -l "Worktree: .*${name}|worktree \`[^\`]*${name}[^\`]*\`|/${name}[\`.]" "$issues_root" "$archive_root" 2>/dev/null | sed -n '1p' || true)
  fi
  printf '%s' "$match"
}

branch_state() {
  [[ -z "$1" ]] && { printf 'detached\n'; return; }
  [[ "$1" == main || "$1" == master ]] && { printf 'base\n'; return; }
  git -C "$repo_root" merge-base --is-ancestor "$1" main 2>/dev/null || git -C "$repo_root" merge-base --is-ancestor "$1" master 2>/dev/null && { printf 'merged\n'; return; }
  printf 'open\n'
}

recommend() {
  [[ $3 == merged || $4 == "done" ]] && { printf 'cleanup-candidate\n'; return; }
  [[ $3 == base ]] && { printf 'keep\n'; return; }
  (( $1 >= 5242880 && $2 >= 7 )) && { printf 'review-large-old\n'; return; }
  (( $2 >= 21 )) && { printf 'review-stale\n'; return; }
  printf 'keep\n'
}

print_row() {
  local path=$1 branch=$2 size_kb size_h ts age issue ref status merged rec
  size_kb=$(du -sk "$path" | cut -f1)
  size_h=$(du -sh "$path" | cut -f1)
  ts=$(mtime "$path")
  age=$(( (now - ts) / 86400 ))
  merged=$(branch_state "$branch")
  issue=$(find_issue "$branch" "$path")
  ref=- status=-
  [[ -n "$issue" ]] && { ref=$(issue_ref "$issue"); status=$(issue_status "$issue"); }
  rec=$(recommend "$size_kb" "$age" "$merged" "$status")
  printf '%s\t%s\t%s\t%sd\t%s\t%s\t%s\t%s\t%s\n' "$path" "$size_h" "$(stamp "$ts")" "$age" "${branch:-DETACHED}" "$merged" "$ref" "$status" "$rec"
}

printf 'Repo: %s\n' "$repo_root"
printf 'Vault: %s\n\n' "$vault_root"
{
  printf 'Path\tSize\tModified\tAge\tBranch\tBranchStatus\tIssue\tIssueStatus\tRecommendation\n'
  git -C "$repo_root" worktree list --porcelain | while IFS= read -r line; do
    case "$line" in
      worktree\ *) path=${line#worktree } ;;
      branch\ refs/heads/*) branch=${line#branch refs/heads/} ;;
      detached) branch='' ;;
      '') print_row "$path" "${branch:-}"; path=''; branch='' ;;
    esac
  done
  [[ -n ${path:-} ]] && print_row "$path" "${branch:-}"
} | column -ts $'\t'
