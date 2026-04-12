---
name: scratchpad-maintenance
description: Provide high-level scratchpad context and route the task to the right specific scratchpad skill.
user-invocable: true
created: TODO
---

# Scratchpad Maintenance

Provide high-level scratchpad context, then route work to the right focused skill.

## Use This When

- You need a quick scratchpad workflow refresher.
- You are unsure which scratchpad skill owns the task.
- The task spans multiple scratchpad workflows and you need the right handoff.
- A request sounds like "clean up issues" and you first need to determine whether it is issue review, archival, or both.

This is the router skill, not the main execution skill.

## Quick Discovery

Before routing, gather context. **Obsidian CLI** (if running):

```bash
obsidian base:query file="scratchpad/actives.base" view="Active Issues" format=tsv
obsidian search query="<topic>" limit=10
obsidian backlinks file="N-slug"
obsidian tags sort=count counts
obsidian unresolved verbose
```

Fall back to reading files and grep if Obsidian isn't running.

## Routing Table

| Task | Skill |
|------|-------|
| Active issue hygiene, stale review, status normalization | `issue` |
| Scratchpad doc lifecycle | `doc` |
| Moving done/cancelled issues to archive | `archive-issues` |
| Frontmatter mutations, search, Bases queries | `obsidian-cli` |

## Core Rules

- Treat the issue as the durable planning artifact.
- Do not create standalone files in `scratchpad/plans/`. Keep planning inside issues.
- Use skill-local `templates/` as source of truth for file templates.

## Quality Bar

- Keep the routing obvious. Report the chosen downstream skill and why it fits.
- If a request mixes stale review with archival, route review to `issue` first and file-moving to `archive-issues` second.
