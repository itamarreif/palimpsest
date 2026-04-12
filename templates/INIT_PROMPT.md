# Palimpsest Initialization

You are helping complete the setup of a new Palimpsest agent memory system. The scaffolding has been created by `palimpsest init`. Your job is to walk through the TODO sections in each template file and help the user populate them with domain-specific content.

When you are done, this file (`INIT_PROMPT.md`) can be deleted — it is a one-time setup document.

---

## What was created

- `MASTER_PROMPT.md` — agent role, startup sequence, skill index. Has TODOs for: agent description, scope, safety rules, accuracy rules, domain skills.
- `scratchpad/docs/1-safety-rails.md` — safety constraints. Has TODOs for domain-specific rules.
- `scratchpad/docs/2-workflow.md` — how the scratchpad system works. Largely pre-filled; has a TODO for domain-specific workflow notes.
- `scratchpad/profile.md` — user facts singleton. Has TODOs for initial domain facts. Contains `next_id: 3`.
- `skills/` — core skills pre-populated with generic procedures. May need light personalization.

---

## Session plan

Work through these in order. For each file: read it, ask the user the relevant questions, fill in the TODOs, write the result.

### 1. MASTER_PROMPT.md

Ask the user:
- What is this agent for? (domain, primary use case — e.g., "personal finance", "software engineering at Acme Corp", "research assistant")
- What should the agent be named?
- What should the agent **never** do? (domain-specific hard constraints)
- What should the agent **always** do? (mandatory behaviors, accuracy requirements)
- Are there any domain-specific skills beyond the core set? List them with a one-line trigger description each.

Fill in all `TODO:` sections. Keep the pre-filled startup sequence, design philosophy, and core skill index intact.

### 2. scratchpad/docs/1-safety-rails.md

Ask the user:
- What are the highest-stakes mistakes this agent could make? (e.g., "move money", "submit a form", "delete production data")
- Are there any categories of information it should never write to disk? (e.g., account numbers, passwords)
- Any external systems it must not interact with without explicit confirmation?

Add these as concrete rules. The universal rules (no deleting files, no secrets, no reusing IDs) are already pre-filled — only ask about domain-specific additions.

### 3. scratchpad/docs/2-workflow.md

This file is largely pre-filled with the standard Palimpsest workflow. Only ask if there are domain-specific workflow variations (e.g., "issues always need a linked external ticket", "docs require a source citation in frontmatter").

Skip if no changes needed.

### 4. scratchpad/profile.md

Ask the user:
- What sections does the profile need? (Suggest based on domain: e.g., for finance: accounts, income sources, tax history; for software: repo list, team conventions, current projects)
- What initial facts should go in each section? Populate what the user provides now; leave the rest for future sessions.
- Update `next_id` if you created any numbered files during this session (IDs 1 and 2 are taken by safety-rails and workflow docs).

### 5. Skills

Read each skill in `skills/`. They are ready to use as-is. Only personalize if:
- A procedure references a specific external system (e.g., a GitHub repo URL)
- The user wants to add domain-specific steps to an existing skill
- A domain-specific skill needs to be created from the `SKILL.md` template

---

## After initialization

1. Delete this file (`INIT_PROMPT.md`).
2. Point your agent tool at `MASTER_PROMPT.md`:
   - **Claude Code**: add a reference in `CLAUDE.md`
   - **OpenCode**: add a reference in `AGENTS.md`
   - **Claude Projects**: add startup files as project files
3. Commit the completed scratchpad: `git add -A && git commit -m "init: palimpsest scratchpad"`
4. Open the vault in Obsidian and verify: Settings → Core plugins → Bases is enabled.
