---
name: revise-issue
description: Curate a long or decayed scratchpad issue into current status, decisions, superseded work, and a compact log.
user-invocable: true
persona: collaborator
created: TODO
---

# Revise Issue

Use this skill when an issue is hard to scan because its status is stale, decisions remain in open questions, abandoned approaches remain inline, or logs have become append-only history.

Do not use it for frontmatter-only cleanup, issue completion, or physical archival.

## Procedure

1. Read the complete issue and any linked GitHub state.
2. Identify stale status text, resolved questions, abandoned approaches, obsolete plan items, and legacy sections.
3. For issues with a parent, RFC tags, more than 200 lines, or more than ten moves or deletions, present a revision plan and get approval first.
4. Rewrite `## Status` with current truth.
5. Move resolved questions to `## Decisions` and abandoned work to `## Superseded`.
6. Keep current technical facts in `## Notes`; remove obsolete or duplicated notes.
7. Keep current work in `## Plan`; remove completed mechanical items after preserving durable outcomes.
8. Compact older log entries and add one dated revision entry.
9. Update `updated` and verify Obsidian links.

## Quality Bar

- `## Status` explains current state without reading the log.
- No decision remains in `## Open Questions`.
- No abandoned approach remains inline as current guidance.
- The issue is shorter and easier to scan than before.
