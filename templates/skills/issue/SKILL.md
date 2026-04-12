---
name: issue
description: Create, update, and review the lifecycle of scratchpad issues, from initial creation through hygiene and resolution.
user-invocable: true
created: TODO
---

# Issue

Own the full lifecycle of scratchpad issues.

## Use This When

- Creating a new scratchpad issue.
- Updating an existing issue as work evolves.
- Folding ad hoc planning into an issue's `## Plan` section.
- Reviewing issues for staleness or hygiene.
- Reconciling issue status against linked external state before deciding whether the issue is stale.

Do not use this for physical archival — hand off to `archive-issues` for that.

## Status Semantics

- `done` — the issue's intended work is complete.
- `in-progress` — actively being worked.
- `blocked` — active but cannot currently proceed.
- `cancelled` — no longer relevant, superseded, or closed due to staleness.
- Never use `completed`. Normalize to `done`.

## Procedure

### 1. Decide whether to create or update

- Check `scratchpad/issues/` for an existing issue first.
- If one issue already owns the work, update it instead of creating a new file.
- If the work is meaningfully separate, create a new issue.

### 2. Create a new issue when needed

- Read `next_id` from `scratchpad/profile.md` frontmatter.
- Read `skills/issue/templates/issue-template.md`.
- Create `scratchpad/issues/<next_id>-<slug>.md`.
- Increment `next_id`: `obsidian property:set name="next_id" value="<N+1>" file="profile"`.
- Frontmatter fields: `title`, `status`, `created`, `updated`, `parent`, `related`, `gh-prs`, `gh-issues`, `tags`.
- `related` is a YAML block list of quoted wikilinks: `"[[N-slug|#N]]"`.
- `parent` is a single quoted wikilink: `"[[N-slug|#N]]"`.
- `gh-prs` and `gh-issues` are plain integer arrays: `[12361, 12420]`.
- **Obsidian CLI**: After writing the file, verify with `obsidian properties file="N-slug" format=json`.

### 3. Keep the issue current

- Update frontmatter and relevant sections (`## Context`, `## Goal`, `## Approach`, `## Plan`, `## Notes`, `## Open Questions`) as work evolves.
- **Obsidian CLI**: Use `obsidian property:set` for scalar frontmatter updates. Use `obsidian tasks todo file="N-slug"` to inspect plan progress. Use `obsidian task file="N-slug" line=N done` to toggle checkboxes.
- Keep `updated:` accurate on material changes.

### 4. Complete an issue

- Set `status: done` and update `updated`.
- **Obsidian CLI**: `obsidian property:set name="status" value="done" file="N-slug"` then `obsidian property:set name="updated" value="YYYY-MM-DD" file="N-slug"`.
- If the issue has a parent, update the parent to reflect completion.
- Hand off to `archive-issues` for the physical move.

### 5. Review active issues for staleness

- **Obsidian CLI**: `obsidian base:query file="scratchpad/actives.base" view="Active Issues" format=tsv` to get active issues with staleness values.
- Classify each: still active / mark `done` / mark `blocked` / mark `cancelled`.
- Common stale signals: linked work already merged or closed; notes say ownership moved; status text no longer matches external state.
- Print a candidate report before editing anything.

### 6. Maintain issue hygiene

- Normalize frontmatter when older issues predate current conventions.
- Migrate `related:` comma-strings to YAML block lists of quoted wikilinks.
- Normalize legacy `completed` status to `done`.
- **Obsidian CLI**: `obsidian tags sort=count counts` to spot tag inconsistencies. `obsidian unresolved verbose` to detect broken wikilinks.

## Quality Bar

- Treat the issue as the durable source of truth for the work.
- Preserve history while keeping the issue easy to scan.
- `done` for finished work, `cancelled` for stale/superseded work.
