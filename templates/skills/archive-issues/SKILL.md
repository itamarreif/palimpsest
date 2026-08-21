---
name: archive-issues
description: Move done or cancelled scratchpad issues into archive/issues/ and keep parent issue tracking aligned.
user-invocable: true
created: TODO
---

# Archive Issues

Archive `done` or `cancelled` scratchpad issues so active work stays separate from historical records.

## Use This When

- A scratchpad issue is done and no longer active.
- Several done or cancelled issues have accumulated in `scratchpad/issues/`.
- A workstream cleanup needs the archive state brought up to date.

## Procedure

### 1. Inventory active issues first

- Bucket files into: `done` / `cancelled` / active `draft`, `in-progress`, `backlog`, or `blocked`.
- Normalize any legacy `completed` status to `done` before archiving.

### 2. Print a candidate report before editing

- Show archive-ready issues, suspected stale issues that need review first, and metadata-only cleanups.
- Do not batch-archive without user confirmation.
- Prefer incremental interaction: let the user say which specific issues to archive.

### 3. Check parent issue impact

- Read any parent issue before moving files.
- Update parent references if the archive move would leave stale status.

### 4. Normalize archive semantics

- `done` — work actually finished.
- `cancelled` — stale, superseded, or no longer relevant.
- Never archive a stale issue as `done`.
- Archive a cancelled `rfc-draft` issue when it has no active work. Archive a `done` RFC issue only when it has `rfc-promoted` and no active implementation work.

### 5. Archive the files

- When an issue has `## Scope` and an accessible linked PR diff, append measured actuals before moving it. Skip actuals when no diff is available; do not block archival.
- Move files to `scratchpad/archive/issues/`.
- Preserve filenames and IDs.

### 6. Verify the result

- Confirm moved files are present in `archive/issues/` and absent from `issues/`.
- **Obsidian CLI**: `obsidian open file="N-slug" silent` to refresh cache. `obsidian unresolved verbose` to check for broken links introduced by the move.

## Quality Bar

- Archival makes the active directory cleaner without losing history.
- Never archive an issue that still serves as the active source of truth.
- Prefer interactive confirmation over batch mutation.
