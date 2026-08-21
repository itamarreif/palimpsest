---
name: weekly-scratchpad-triage
description: Use for weekly scratchpad issue triage: identify stale work, update lifecycle state, and archive confirmed historical issues.
user-invocable: true
persona: collaborator
created: TODO
---

# Weekly Scratchpad Triage

Run a recurring maintenance pass so `scratchpad/issues/` contains active work, deliberate backlog, and genuine blockers only.

## Procedure

1. Inventory active issues with Obsidian Bases or direct file reads.
2. Produce a candidate report before changing unnamed issues.
3. Classify each candidate as archive-ready, likely done, likely cancelled, backlog, blocked, needs body cleanup, or needs user decision.
4. Read issue frontmatter, current status, parent/master references, and linked GitHub state before changing a status.
5. Set `done` only for completed work. Use `cancelled` for abandoned work, `backlog` for parked work, and `blocked` for work awaiting an external condition.
6. Route long or decayed bodies to `revise-issue`.
7. Archive only confirmed `done` or `cancelled` issues through `archive-issues`.
8. Re-run the active inventory and verify new unresolved links were not introduced.

## Quality Bar

- Do not classify work from age alone.
- Prefer a few high-confidence changes over broad speculative churn.
- Do not archive an issue that remains the source of truth for active work.
- Report issues that need a user decision separately.
