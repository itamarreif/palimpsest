---
name: weekly-summary
description: Generate a weekly summary of work done — PRs merged/opened, scratchpad issues updated, and a team-ready standup blurb.
user-invocable: true
created: TODO
---

# Weekly Summary

Produce a concise weekly work summary by cross-referencing GitHub PR activity with scratchpad issue state.

## Use This When

- The user asks for a weekly summary, standup update, or "what did I do this week".
- End-of-week reporting or prep for a team sync.

## Procedure

### 1. Determine the time window

- Default: Monday of the current week through today.
- Use `date` to find the current day, then compute the Monday date.
- The user may override with a specific date range.

### 2. Gather GitHub PR activity

> Requires the `gh-cli` skill. If `gh-cli` is not installed in this vault, skip this step and produce a scratchpad-only summary from step 3.

Use `gh` against each target repo configured for this vault: **{{TARGET_REPOS}}**.

```bash
# For each target repo, fetch merged and open PRs for the author this week.
for repo in {{TARGET_REPOS}}; do
  # Merged PRs this week
  gh search prs --repo "$repo" --author @me --state closed --merged --merged-at ">YYYY-MM-DD" --json number,title,closedAt,url --jq '.[] | "[\(.number)] \(.title) — \(.url)"'

  # Open PRs
  gh search prs --repo "$repo" --author @me --state open --json number,title,url --jq '.[] | "[\(.number)] \(.title) — \(.url)"'
done
```

Aggregate results across repos; annotate each PR with the repo it came from so repo-spanning summaries stay readable.

### 3. Gather scratchpad issue activity

- Read all active issues in `scratchpad/issues/`.
- Also check recently archived issues in `scratchpad/archive/issues/` — use file modification times (`ls -lt`) to find issues archived during the time window.
- For each, check frontmatter `updated:` date and `status:` field.
- Identify issues created, updated, completed, or archived this week.
- Cross-reference linked `gh-prs:` / `gh-issues:` against the GH data from step 2 (if `gh-cli` is installed).

### 4. Reconcile and update stale scratchpad issues

> The reconciliation steps below depend on `gh-cli`. If `gh-cli` is not installed, skip the GitHub-derived reconciliation and apply only local scratchpad hygiene.

Scratchpad issues frequently fall behind GitHub state — PRs merge or issues close but the scratchpad status stays `in-progress` or `review`. This step is **mandatory**, not optional.

For every active scratchpad issue with a linked `gh-prs:` PR or `gh-issues:` issue:

1. Check each linked PR's merge state and each linked issue's open/closed state via `gh`.
2. Compare against the scratchpad `status:` field.
3. If a scratchpad issue's primary PR has merged and all completion criteria are met, update it to `done`.
4. If a scratchpad issue's PR is open but was previously marked `in-progress`, check if it's now in review and update accordingly.
5. Update the `updated:` date in frontmatter.
6. Add a `## Status` note or update the existing one with the current GH state (e.g., "PR #NNNN merged YYYY-MM-DD").
7. Remove stale references (e.g., `pr#TBD-*` placeholders that were never opened).

Apply these edits directly — do not just flag them. The summary is not complete until scratchpad state matches GitHub.

### 5. Produce the summary

Generate three outputs in order. Each has a specific format documented below.

---

#### Output 1: Team-ready blurb

Shown first — this is the most commonly needed output and should be copy-pasteable into Slack without editing.

**Format rules:**

- 4-8 lines, plain English, no PR numbers, no issue numbers
- Each line: `theme — brief elaboration`
- Group related PRs into a single theme line
- Mention items still in review with "(in review)" at the end
- No bullet markers — just plain lines separated by newlines
- No headers or labels — just the lines

**Example:**

```
Test coverage expansion — reconciliation invariants, error paths, aggregation, E2E suite, holiday/weekend boundaries
Service extractions — pulled two standalone services out of the monolith with dedicated tests
E2E weekday lifecycle scenario — multi-entity, multi-service, two-day coverage
Lifecycle implementation for daily activities
Report diff tool improvements — hierarchical profiling and Makefile date presets (in review)
Mock email recipient validation + E2E assertion coverage
Agent skills and style guide — new skills, tracing/readability rules
```

---

#### Output 2: PR breakdown

Grouped by category. Only include categories that have PRs.

**Format rules:**

- Category header: `### Category name (count)`
- Each PR: `- #NNNNN — short title` (strip the conventional commit prefix, keep it readable). If the summary spans multiple target repos, prefix with `owner/repo#NNNNN` instead of `#NNNNN`.
- No dates
- Open PRs marked with `*(open)*` at the end
- Categories in this order (skip empty ones):
  1. Test coverage — new tests, test infrastructure, coverage expansion
  2. Service extractions / refactors — architectural changes, code reorganization
  3. Features — new user-facing or developer-facing functionality
  4. Bug fixes — production or test fixes
  5. Docs & skills — documentation, agent skills, style guide
  6. Chore — dependency bumps, renames, cleanup

**Example:**

```
### Test coverage (8)
- #10923 — forward-dated reconciliation test
- #10974 — holiday and weekend tests for activity and cash needs
- #11052 — balance reconciliation and total outstanding invariant tests
- #11233 — USDC sweep coverage and fix wire-limit deduction *(open)*

### Service extractions / refactors (2)
- #11050 — extract NAV polling into standalone service
- #11043 — extract USDC sweep into standalone service

### Features (1)
- #11160 — implement effective_at lifecycle for daily activities

### Docs & skills (3)
- #11051 — tracing, readability, and antipattern rules in style guide
- #11235 — domain-types skill and style guide *(open)*
- #11234 — cli-tools skill *(open)*

### Chore (1)
- #11014 — bump dependency version
```

---

#### Output 3: Scratchpad issue reconciliation

Report what was updated during step 4, plus a status snapshot of all issues touched this week (including those archived during the window).

**Format rules:**

- First: list of stale issues that were fixed, with what changed
- Then: table of all issues touched this week, including archived ones (mark archived issues with "done (archived)")

**Example:**

```
Stale issues updated:
- #44 Extract NAV polling service: review -> done (PR #11050 merged 3/11)
- #48 Mock email API validation: in-progress -> done (PR #11027 merged 3/10)

| # | Title | Status |
|---|-------|--------|
| 44 | Extract NAV polling service | done |
| 48 | Mock email API validation | done |
| 51 | E2E test matrix | in-progress |
| 55 | Report tool improvements | in-progress |
| 56 | Domain-types skill | in-review |
```

---

### 6. Present results

- Show outputs in order: blurb, then PR breakdown, then issue reconciliation.
- Ask if the user wants adjustments before sharing the blurb externally.

## Quality Bar

- PR lists must come from `gh` — never guess PR numbers or titles.
- **Stale scratchpad issues must be fixed before presenting the summary.** The summary is only valid if scratchpad state matches GitHub.
- The team blurb should be copy-pasteable into Slack without editing.
- Keep the blurb concise — group related PRs into themes, don't enumerate every PR.
