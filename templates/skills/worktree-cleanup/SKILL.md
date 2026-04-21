---
name: worktree-cleanup
description: Use when asked to inspect or clean up worktrees. Audit registered worktrees by size, last-modified time, branch state, and linked scratchpad issue status before suggesting cleanup.
user-invocable: true
created: TODO
---

# Worktree Cleanup

## Config

- **Worktree dir**: `{{WORKTREE_DIR}}` (should match the `git` skill's Config)

## Use This When

- Inspecting or cleaning up registered git worktrees.
- Finding stale worktrees that are safe to remove after a branch has merged.

## Procedure

Start by auditing the repo's registered worktrees:

```bash
scripts/scan-worktrees.sh
```

Pass a repo path when needed:

```bash
scripts/scan-worktrees.sh /path/to/repo
```

The script reports each worktree's size, last modified date, branch merge state, linked scratchpad issue, and a cleanup recommendation.

The script expects a `PALIMPSEST_VAULT` environment variable pointing at the vault root (so it can correlate worktrees with scratchpad issues). If unset, it falls back to `$HOME` and may not find matches.

```bash
PALIMPSEST_VAULT=/path/to/vault scripts/scan-worktrees.sh /path/to/repo
```

## Recommendations

Recommendations are heuristics only:

- `cleanup-candidate`: merged branch or `status: done`
- `review-large-old`: at least ~5 GiB and untouched for at least 7 days
- `review-stale`: untouched for at least 21 days
- `keep`: everything else

Use scratchpad issue matches to explain likely status, but never remove a worktree automatically. If cleanup is needed, show the exact `git worktree remove <path>` command and ask for explicit confirmation first.

## Quality Bar

- Never delete a worktree without explicit confirmation.
- Explain recommendations in terms of the observable state (merged branch, stale mtime, large size, scratchpad status).
- When a scratchpad issue is linked, include its status so the user sees the context.
