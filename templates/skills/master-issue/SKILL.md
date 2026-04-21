---
name: master-issue
description: Create and maintain scratchpad master issues, keeping the rollup current across sub-issues, PRs, and remaining work.
user-invocable: true
created: TODO
---

# Master Issue

Use a master issue as the umbrella artifact for a multi-session, multi-PR workstream.

## Use This When

- A project spans multiple scratchpad issues.
- The user needs an up-to-date rollup of shipped, active, and remaining work.
- A GitHub issue summary needs to be easy to derive from local scratchpad tracking.

## Procedure

### 1. Decide whether a master issue is warranted

- Use a master issue for broad workstreams with multiple PRs, sub-issues, or long-lived tracking needs.
- If the work is still a single focused stream, prefer a normal scratchpad issue.

### 2. Create the master issue from template when needed

- Read `next_id` from `scratchpad/profile.md` frontmatter.
- Read `skills/master-issue/templates/master-issue-template.md`.
- Create `scratchpad/issues/<next_id>-<slug>.md`.
- Increment `next_id`: `obsidian property:set name="next_id" value="<N+1>" file="profile"`.
- Use `gh-prs:` and `gh-issues:` as plain integer arrays (e.g. `gh-prs: [5678]`, `gh-issues: [1234]`).
- Use `children:` as a YAML list of quoted wikilinks: `"[[N-slug|#N]]"`.
- Use `related:` for non-parent/child cross-references, same wikilink format.
- **Obsidian CLI**: After writing the file, verify with `obsidian properties file="N-slug" format=json`. If Obsidian isn't running, write YAML directly and move on.

### 3. Keep the rollup current

- Update the latest meaningful milestone in `## Latest Update`.
- Keep `## In Progress`, `## Remaining Work`, and `## Completed Work` mutually consistent.
- Track PRs in `## PR Summary` and issue relationships in `## Related Issues`.
- **Obsidian CLI**: Use `obsidian backlinks file="N-slug"` to discover which issues reference the master, and validate against the `children:` list. Use `obsidian property:set` for frontmatter updates.

### 4. Sync sub-issues and summaries

- When a child issue changes meaningfully, reflect that change in the master issue.
- When a child issue completes, move it out of active sections and into completed/recently completed sections.
- Do not maintain a dedicated GitHub-only section; derive GitHub updates from the current rollup sections when needed.

### 4b. GitHub master issues with sub-issues

> Requires the `gh-cli` skill. If `gh-cli` is not installed in this vault, skip this section or install `gh-cli` first.

When creating a corresponding GitHub master issue with sub-issues, use GitHub's native sub-issue linking (via GraphQL `addSubIssue`) instead of listing sub-issues in markdown. See the `gh-cli` skill for the exact workflow.

- Create the master issue and all sub-issues with `gh issue create`.
- Link sub-issues to the parent using `addSubIssue` GraphQL mutations.
- Do not duplicate the sub-issue list in the master issue body — the native sidebar tracks them.
- Keep the master issue body focused on context, problem classification, and approach.
- Record the GitHub issue numbers in the scratchpad master issue's `gh-issues:` frontmatter (e.g., `gh-issues: [1234]`).
- Use `obsidian backlinks` to validate the `children:` list against which issues actually reference the master.

### 5. Close out responsibly

- Before declaring the workstream done, make sure completed PRs, remaining work, and related issues all agree.
- If sub-issues are done, pair this with the `archive-issues` skill so the master issue and archive state stay aligned.
- **Obsidian CLI**: Run `obsidian unresolved verbose` after archiving children to verify no links broke. If Obsidian isn't running, skip this check.

## Quality Bar

- A reader should be able to answer "what shipped, what is active, and what is next?" in under a minute.
- Prefer concise deltas and accurate status over exhaustive prose.
- Keep the main rollup clear enough that a GitHub update can be composed quickly without duplicate maintenance.
