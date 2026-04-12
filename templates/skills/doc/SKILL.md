---
name: doc
description: Create and maintain durable scratchpad docs for settled knowledge, workflows, and reference material.
user-invocable: true
created: TODO
---

# Doc

Own the lifecycle of scratchpad docs.

## Use This When

- Creating a new durable doc in `scratchpad/docs/`.
- Updating an existing doc as understanding evolves.
- Recording knowledge that should outlive the current task.

Do not use this for work-tracking issues.

## Procedure

### 1. Check whether a doc already exists

- Look in `scratchpad/docs/` for an existing home.
- Extend an existing doc when the topic is the same.

### 2. Create a doc when needed

- Read `next_id` from `scratchpad/profile.md` frontmatter.
- Read `skills/doc/templates/doc-template.md`.
- Create `scratchpad/docs/<next_id>-<slug>.md`.
- Increment `next_id`: `obsidian property:set name="next_id" value="<N+1>" file="profile"`.
- Frontmatter fields: `title`, `created`, `updated`, `related`, `tags`. No `status` field.
- **Obsidian CLI**: After writing the file, verify with `obsidian properties file="N-slug" format=json`.

### 3. Keep docs durable

- Update `updated:` when material content changes.
- **Obsidian CLI**: Use `obsidian property:set` for frontmatter updates.
- Prefer explanation and concrete references over execution tracking.
- Add gotchas and cross-links that will help future readers.

### 4. Migrate older docs when touching them

- Normalize any inline metadata to YAML frontmatter.
- Remove duplicate H1 titles when the title already exists in frontmatter.

## Quality Bar

- Write for someone unfamiliar with the local history.
- Keep docs explanatory; keep task tracking in issues.
