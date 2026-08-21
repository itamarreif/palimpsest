---
name: rfc
description: Orchestrate an RFC inside a scratchpad issue from discovery through promotion, review, and implementation.
user-invocable: true
created: TODO
---

# RFC

RFCs are scratchpad issues, not standalone files. The issue stays durable through drafting, PR review, implementation, and archival. The PR becomes the canonical RFC text after promotion.

## Use This When

- A user requests an RFC, design proposal, or architecture decision that needs review.
- An existing RFC issue needs research, promotion, review tracking, or implementation follow-up.

Do not create new files in `scratchpad/rfcs/`. That directory holds legacy standalone RFCs only.

## Lifecycle

### 1. Discovery And Research

Use the default `collaborator` persona. Ask focused questions about the problem, existing work, constraints, and success criteria. Research source code, issues, pull requests, and documentation before proposing a design.

Record durable findings in `## Research Findings`. Record unresolved choices in `## Open Questions`.

### 2. Create The RFC Issue

1. Use the `issue` skill to create `scratchpad/issues/<next_id>-<slug>.md`.
2. Add `rfc-draft` to `tags`.
3. Apply `templates/rfc-template.md` to the issue body.
4. Fill `## Context`, `## Goal`, `## Research Findings`, and `## Proposed Design` before drafting the RFC body.

Use the `principal` persona only while writing `## RFC Body`. The body must stand alone for readers outside the scratchpad.

### 3. Promote To A PR

> Requires the `gh-cli` skill. If it is unavailable, stop after preparing the RFC body.

1. Discover the target repository RFC convention and destination path.
2. Extract `## RFC Body` into the repository RFC file. Remove scratchpad-only links and metadata.
3. Open a draft PR through `gh-cli`.
4. Update the RFC issue:
   - Rename `## RFC Body` to `## Draft Archive`.
   - Add `## Review Status` near the top.
   - Add `rfc-promoted` to `tags`.
   - Record the PR number in `gh-prs`.
   - Rewrite `## Status` to reflect review state.
   - Append a promotion entry to `## Log`.

### 4. Review And Implementation

After promotion, the PR is canonical. Do not edit `## Draft Archive`.

Use the issue for review and implementation tracking:

- `## Status` for the current review or delivery state.
- `## Review Status` for blockers and reviewers.
- `## Open Questions` for unresolved design feedback.
- `## Decisions` for resolved feedback.
- `## Plan` for implementation work.
- `## Log` for session updates.

When the PR merges, continue implementation in the RFC issue or create child issues. Mark the RFC issue `done` only after review and implementation work are complete.

## Detecting Phase

| Signal | State | Action |
|---|---|---|
| `rfc-draft`, no `gh-prs` | Drafting | Edit `## RFC Body`. |
| `rfc-draft` and `rfc-promoted`, has `gh-prs` | In review | Update the PR and operational tracker. |
| `rfc-promoted`, `status: done` | Complete | Archive through `archive-issues`. |

## Legacy RFCs

Standalone files in `scratchpad/rfcs/` are read-only historical records. If a legacy RFC needs more work, create a linked issue and use the issue-overlay workflow.
