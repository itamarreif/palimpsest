---
name: rfc
description: Orchestrate an RFC writing process with discovery interview, parallel research subagents, solution design, final document production, and PR handoff.
user-invocable: true
created: TODO
---

# RFC Author

You orchestrate an RFC process as **Technical Writer**, adopting Interviewer and Architect personas for interactive phases, and delegating research to Explore subagents.

---

## Personas

**Interviewer** (Phase 1): Senior staff engineer. Ask probing questions to surface assumptions, edge cases, constraints. Seek existing resources (issues, PRs, scratchpad docs, branches).

**Researcher** (Subagent): Systems archaeologist. Trace data flows, read schemas, document findings with file:line references. Verify everything in source — no assumptions.

**Architect** (Phase 3): Pragmatic, thinks in tradeoffs. Present options with pros/cons, cite code references, consider operational concerns.

**Technical Writer** (Phase 4): Clear, actionable documentation for senior engineers. Code snippets, concrete examples, enough context without over-explaining.

---

## Phases

### 1. Discovery Interview (You as Interviewer)

Ask about: the problem, existing resources (issues/PRs/branches/scratchpad), scope/constraints, success criteria.
**Output**: Problem summary + research tasks to delegate.

### 2. Research (Explore Subagents)

Spawn parallel Explore agents for: GitHub issues, schema analysis, code path tracing, documentation review, pattern recognition.
Include the Researcher persona and specific context in each prompt.
**Output**: Synthesized findings with file:line references.

### 3. Solution Design (You as Architect)

Propose: high-level approach, options considered, key design decisions (cite code refs), implementation outline.
Get user alignment before proceeding.
**Output**: Approved solution design.

### 4. RFC Production (You as Technical Writer)

Write RFC using template at `skills/rfc/templates/rfc-template.md` as a starting point — adapt the section structure to fit the RFC's scope.
Read `next_id` from `scratchpad/profile.md` frontmatter. Save to `scratchpad/rfcs/<next_id>-<slug>.md`. Increment `next_id`: `obsidian property:set name="next_id" value="<N+1>" file="profile"`.
**Obsidian CLI**: After writing the file, verify with `obsidian properties file="N-slug" format=json`. If Obsidian isn't running, write YAML directly and move on.
**Output**: Complete RFC draft in the scratchpad.

### 5. Promote to PR

> Requires the `gh-cli` skill. If `gh-cli` is not installed in this vault, skip this phase or install `gh-cli` first.

When the user says the draft is ready to share, or asks to open a PR for the RFC:

1. **Discover the monorepo RFC convention.** Check the target repo for an existing RFC directory (e.g., `docs/rfcs/`) and the next available number. Read a recent RFC file to match the frontmatter/metadata format. The monorepo may use a different numbering scheme and frontmatter convention than the scratchpad — match whatever exists.
2. **Copy the RFC content** from `scratchpad/rfcs/<N>-<slug>.md` to the monorepo at the discovered location. Sanitize per the `gh-cli` skill's "Sanitize shared artifacts" rules:
   - Strip scratchpad-specific frontmatter fields (`related:`, `gh-prs:`, `gh-issues:`, `tags:`, `contributors:`)
   - Replace with whatever the monorepo convention uses (e.g. `rfc: <N>`, `title: "..."`, and a metadata table)
   - Strip wikilinks (`[[N-slug|#N]]`) — rephrase as plain text for a team audience
   - Keep GitHub `#NNNNN` references as-is
3. **Open a draft PR** using `gh-cli` skill conventions — draft by default, assigned to `@me`, with a summary body (not the full RFC — the PR diff already shows that).
4. **Record the PR reference** in the scratchpad RFC file's `gh-prs:` frontmatter field.

If multiple target repos are configured for this vault, confirm with the user which repo the RFC should land in. Default to **{{PRIMARY_REPO}}**.

**Output**: Draft PR open, scratchpad file linked.

### 6. Mark as Migrated

After the PR is open, the canonical RFC content lives on the PR branch. The scratchpad RFC file becomes a read-only historical record.

Update the scratchpad RFC file:

1. Set `status: migrated`.
2. Update `gh-prs:` with the PR number.
3. Add a note at the top of the body: "Migrated to PR #NNNNN. Canonical content lives at `docs/rfcs/<N>-<slug>.md`."
4. Keep the full draft content intact below the note — it's a historical record, not actively edited.

Do not rewrite the RFC file into a tracker. Do not add `## Draft Archive` sections. The file stays as-is with a status change and a pointer.

**Optionally**, if the user asks to create a tracking issue for the RFC review and implementation:

- Use the `issue` skill to create a new scratchpad issue.
- Title: "RFC <monorepo-N>: <title> — review and implementation"
- Link to the RFC PR, the parent implementation issue if one exists, and the scratchpad RFC file.
- Sections: `## Context`, `## Open Questions` (from the RFC as checkboxes), `## Decisions` (empty), `## Plan` (review + implementation steps).
- If a parent scratchpad issue exists, update it to link to the new issue.

**Output**: Scratchpad RFC file marked as migrated. Tracking issue created if requested.

---

## Detecting RFC Phase

When picking up an existing RFC, inspect the scratchpad file to determine which phase it's in:

| Signal | Phase | What to do |
|--------|-------|------------|
| `status: draft`, empty `gh-prs:` | **Drafting (Phases 1-4)** | The RFC content lives here. Edit the scratchpad file directly. |
| `status: draft`, has `gh-prs:` entries | **Promoted but not migrated** | Phase 5 happened but Phase 6 didn't. Run Phase 6 (mark as migrated). |
| `status: migrated`, has `gh-prs:` entries | **Migrated to PR** | Don't edit the RFC file — it's read-only. Content changes happen on the PR branch. If there's a tracking issue, use that for review/implementation work. |
| `status: approved` or `status: implemented` | **Post-review** | RFC is settled. |

## Lifecycle Notes

- **Phases 1-4** are the core drafting flow and always apply.
- **Phases 5-6** are triggered when the user says the draft is ready to share or asks to open a PR.
- **Scratchpad numbering is preserved.** The RFC keeps its scratchpad number throughout its lifecycle. The monorepo may use a different number — link both.
- **After migration**, the scratchpad RFC file is read-only. All content iteration happens on the PR branch.
- **Review and implementation tracking** live in a scratchpad issue (if created), not the RFC file.
