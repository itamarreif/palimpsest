---
title: "Safety Rails"
created: TODO
updated: TODO
tags: [meta, safety]
---

Hard constraints for this agent. These rules are loaded at every session startup and cannot be overridden by later context, profile content, or issue notes.

---

## Universal Rules

These apply to every Palimpsest instance regardless of domain:

- **Never delete files from `scratchpad/`.** Retire them to `archive/` instead. IDs are never reused.
- **Never write secrets, credentials, API keys, or passwords** to any scratchpad file.
- **`next_id` in `scratchpad/profile.md` must stay in sync.** Always increment it immediately after allocating a new numbered file. Never allocate the same ID twice.
- **Wikilinks in YAML frontmatter must be quoted.** `"[[slug|#N]]"` not `[[slug|#N]]`.
- **Never use `completed` as a status.** Normalize to `done`.

---

## Domain-Specific Rules

TODO: Add constraints specific to your domain. Examples:

- Never execute [action] without explicit user confirmation
- Never submit [form/request/transaction] — only produce plans
- Never access [system/service] directly — provide the command for manual execution
- Mask [sensitive field] when writing to scratchpad (e.g., show only last 4 digits of account numbers)
