# Palimpsest Initialization

You are helping complete the setup of a new Palimpsest agent memory system. The scaffolding has been created by `scripts/init.sh` in the palimpsest repo. Your job is to walk the user through an interview, install the right set of skills for their use case, fill in placeholders, and populate domain-specific TODOs.

When you are done, this file (`INIT_PROMPT.md`) can be deleted — it is a one-time setup document.

---

## What was created

- `MASTER_PROMPT.md` — agent role, startup sequence, skill index.
- `scratchpad/docs/1-safety-rails.md` — safety constraints.
- `scratchpad/docs/2-workflow.md` — how the scratchpad system works.
- `scratchpad/profile.md` — user facts singleton with a `## Config` section and `next_id: 3`.
- `skills/` — **all** core and optional skills pre-populated. You will prune the ones the user doesn't need and fill placeholders in the ones they do.

Skills fall into two tiers:

- **Core** (always kept): `issue`, `doc`, `archive-issues`, `scratchpad-maintenance`, `obsidian-cli`, `diagrams`.
- **Optional** (kept only if selected by the interview): `git`, `gh-cli`, `worktree-cleanup`, `rfc`, `master-issue`, `slack-summary`, `weekly-summary`.

---

## Session Plan

Work through these phases in order. Ask only the questions listed. Do not skip the skill-install phase — the scaffold is not usable until placeholders are substituted and unused skills are pruned.

---

### Phase 1 — Agent identity

Ask the user:

- What is this agent for? (domain, primary use case — e.g., "personal finance", "software engineering at Acme Corp", "research assistant")
- What should the agent be named?
- What should the agent **never** do? (domain-specific hard constraints — captured in `MASTER_PROMPT.md` Scope and `scratchpad/docs/1-safety-rails.md`)
- What should the agent **always** do? (mandatory behaviors, accuracy requirements)

Fill in the matching TODOs in `MASTER_PROMPT.md` (`# TODO: Agent Name`, `## Scope`, `## Accuracy Rules`). Keep the pre-filled startup sequence, design philosophy, and skill index intact.

---

### Phase 2 — Scratchpad on GitHub

Ask:

> **Is this agent's scratchpad managed via a GitHub repository?** [Y/N]

- If **yes**: ask for the `owner/repo` (e.g., `alice/my-agent`). Record in profile's `## Config` as **Scratchpad GitHub repo**.
- If **no**: set **Scratchpad GitHub repo** to `none`.

This question is independent of whether the agent operates on code hosted on GitHub. A scratchpad can be versioned via GitHub even for non-coding agents.

---

### Phase 3 — Bundle selection

Ask each bundle question in order. Record which bundles the user accepts.

**Bundle A — `github` (target: `git`, `gh-cli`, `worktree-cleanup`)**

> Will this agent work on code hosted on GitHub? [Y/N]

**Bundle B — `structured-design` (target: `rfc`, `master-issue`)**

> Will you write design documents or track multi-PR workstreams? [Y/N]

**Bundle C — `reporting` (target: `slack-summary`, `weekly-summary`)**

> Will you need Slack-ready updates or weekly summaries? [Y/N]

After asking all three, offer the escape hatch:

> Any skills from the accepted bundles you'd like to drop, or any skills from rejected bundles you'd like to add anyway?

Accept the user's overrides. Compute the final **installed skills** set = core skills + selected optional skills.

**Cross-skill dependency note**: `rfc`, `master-issue`, and `weekly-summary` have sections that depend on `gh-cli`. The skill text already gates those sections with a "requires gh-cli" note, so it's safe to install them without `gh-cli`. If the user has picked any of these without `gh-cli`, mention it:

> `<skill>` has some sections that depend on `gh-cli`. Those sections are gated with a "requires gh-cli" note; they'll be skipped at runtime. Proceed?

---

### Phase 4 — Per-vault config

Ask these questions **only if** `github` bundle was accepted (directly or via override).

1. **Target GitHub repos**: "What GitHub repo(s) does this agent operate on? Enter one or more `owner/repo` values separated by commas. Type `same` to reuse the scratchpad repo if one was set."
   - Parse comma-separated; trim whitespace.
   - Store ordered list in profile's `## Config` as **Target GitHub repos**.
   - First repo in the list becomes the **primary repo** for substitution.

2. **Branch prefix**: "What branch prefix do you use? (e.g., `alice/`, or type `none`)"
   - Store in `skills/git/SKILL.md` `## Config` as **Branch prefix**.

3. **Worktree dir**: "Worktree directory? (default `.worktrees/`)"
   - Store in `skills/git/SKILL.md` and `skills/worktree-cleanup/SKILL.md` `## Config` as **Worktree dir**.

4. **Stack**: "What's the stack for this project? Describe it freeform — e.g., `Rust + axum + Postgres`, `TypeScript + Next.js + Vercel`, `Python + FastAPI + pytest`."
   - Store in profile's `## Config` as **Stack**.

If the `github` bundle was rejected, also ask the **Stack** question independently if any installed skill references it (currently: `git`, `gh-cli` — both require the bundle, so in practice this only matters if the user overrode one in).

---

### Phase 5 — Install skills

Do the following in order. Report each step briefly.

#### 5a. Prune unselected optional skills

For each optional skill **not** in the installed set, delete its directory:

```bash
rm -rf skills/git
rm -rf skills/gh-cli
rm -rf skills/worktree-cleanup
rm -rf skills/rfc
rm -rf skills/master-issue
rm -rf skills/slack-summary
rm -rf skills/weekly-summary
```

Only run the lines for skills that were rejected. Do not touch core skills (`issue`, `doc`, `archive-issues`, `scratchpad-maintenance`, `obsidian-cli`, `diagrams`).

#### 5b. Substitute placeholders

For each installed skill that contains placeholders, substitute them with the values collected in Phase 4.

Placeholders and their targets:

| Placeholder | Value source | Files to substitute (if installed) |
|-------------|--------------|------------------------------------|
| `{{TARGET_REPOS}}` | Comma-separated target repos | `skills/gh-cli/SKILL.md`, `skills/weekly-summary/SKILL.md` |
| `{{PRIMARY_REPO}}` | First target repo | `skills/gh-cli/SKILL.md`, `skills/rfc/SKILL.md` |
| `{{BRANCH_PREFIX}}` | Branch prefix | `skills/git/SKILL.md` |
| `{{WORKTREE_DIR}}` | Worktree dir | `skills/git/SKILL.md`, `skills/worktree-cleanup/SKILL.md` |
| `{{STACK}}` | Stack | `skills/git/SKILL.md`, `skills/gh-cli/SKILL.md` |

Use direct text replacement. After substitution, verify with a grep pass:

```bash
grep -rn '{{' skills/ && echo "WARNING: unsubstituted placeholders remaining" || echo "placeholders clean"
```

If any `{{...}}` tokens remain in installed skills, report them and offer to re-fill.

**Empty-value handling**: if a value is empty (e.g., Stack is "none"), substitute the placeholder with an empty string. Where that leaves an awkward sentence fragment, trim the sentence or rephrase inline.

#### 5c. Record values in profile.md's `## Config`

Replace the TODO markers in the `## Config` section of `scratchpad/profile.md`:

- **Scratchpad GitHub repo**: value from Phase 2
- **Target GitHub repos**: comma-separated from Phase 4 (or `none`)
- **Stack**: value from Phase 4 (or `none`)

Branch prefix and worktree dir are skill-specific and live in the git/worktree-cleanup `## Config` sections, not profile.

#### 5d. Update MASTER_PROMPT.md skill index

Inside the `<!-- SKILL_INDEX_START -->` / `<!-- SKILL_INDEX_END -->` markers, add a row for each installed optional skill:

| Skill | Suggested "When to load" |
|-------|--------------------------|
| `git` | Local repo inspection, branching, staging, commits |
| `gh-cli` | GitHub-hosted operations: PRs, issues, checks, comments |
| `worktree-cleanup` | Auditing or cleaning up local worktrees |
| `rfc` | Writing or promoting design documents |
| `master-issue` | Multi-PR, multi-session workstream rollups |
| `slack-summary` | Drafting Slack-ready updates or standup blurbs |
| `weekly-summary` | End-of-week PR + scratchpad reconciliation |

Preserve the existing core rows. Do not remove the anchor comments.

#### 5e. Report required dependencies

Inspect the installed skill set from step 5a and print a tailored dependency summary so the user can install anything missing before using the vault.

Always include:

- **Obsidian with its built-in CLI enabled** — https://obsidian.md/help/cli

Then include **only** the lines that apply to the installed optional skills:

- If `gh-cli`, `rfc`, `master-issue`, or `weekly-summary` is installed:
  > `gh` CLI — install on macOS with `brew install gh`, Debian/Ubuntu with `apt install gh`, otherwise see https://cli.github.com. After install, run `gh auth login`.
- If `worktree-cleanup` is installed:
  > `rg` (ripgrep) — install on macOS with `brew install ripgrep`, Debian/Ubuntu with `apt install ripgrep`.

`diagrams` is always installed and needs no separate CLI — diagrams render in Obsidian, GitHub previews, and VS Code with the Mermaid extension.

Skip lines for skills that aren't installed. If the user confirms all listed tools are already present, note that and move on.

---

### Phase 6 — Safety rails

Ask the user:

- What are the highest-stakes mistakes this agent could make? (e.g., "move money", "submit a form", "delete production data")
- Are there any categories of information it should never write to disk? (e.g., account numbers, passwords)
- Any external systems it must not interact with without explicit confirmation?

Add these as concrete rules in `scratchpad/docs/1-safety-rails.md` under **Domain-Specific Rules**. The universal rules (no deleting files, no secrets, no reusing IDs) are already pre-filled — only ask about domain-specific additions.

---

### Phase 7 — Workflow notes

`scratchpad/docs/2-workflow.md` is largely pre-filled with the standard Palimpsest workflow. Only ask if there are domain-specific workflow variations (e.g., "issues always need a linked external ticket", "docs require a source citation in frontmatter"). Skip if no changes needed.

---

### Phase 8 — Profile

Ask the user:

- What sections does the profile need? (Suggest based on domain: finance → Accounts, Income Sources, Tax History; software → Repos, Team Conventions, Current Projects; research → Subject Matter, Prior Work, Key Sources)
- What initial facts should go in each section? Populate what the user provides now; leave the rest for future sessions.
- Update `next_id` if you created any numbered files beyond the pre-existing docs (IDs 1 and 2 are taken by safety-rails and workflow docs).

Replace the `TODO: Section N` placeholders with real sections. Add a dated entry to `## Change Log` summarizing what was added.

---

### Phase 9 — Self-cleanup

1. Delete this file: `rm INIT_PROMPT.md`.
2. Remind the user to link `MASTER_PROMPT.md` to their agent tools:

   ```bash
   bash scripts/link.sh claude                    # Claude Code only
   bash scripts/link.sh claude opencode           # multiple agents
   bash scripts/link.sh claude codex opencode     # all three
   bash scripts/link.sh -f claude                 # overwrite existing
   ```

   For Claude Projects: add `MASTER_PROMPT.md` as a project file manually.

3. Remind the user to commit the completed scratchpad:

   ```bash
   git add -A && git commit -m "init: palimpsest scratchpad"
   ```

4. Remind the user to open the vault in Obsidian and verify: Settings → Core plugins → Bases is enabled.

---

## Quality Bar

- Do not skip Phase 5. A scaffolded vault with unsubstituted `{{PLACEHOLDERS}}` or unused skills is not usable.
- Prefer incremental, interactive confirmation over batching up all questions then executing.
- After Phase 5, run `grep -rn '{{' skills/` and confirm no placeholders remain in installed skills.
- After pruning, run `ls skills/` and confirm the directory matches the installed set.
