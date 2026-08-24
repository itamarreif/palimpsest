---
name: code-references
description: Use when referring to or quoting source code in chat, scratchpad artifacts, PRs, reviews, or external updates.
user-invocable: true
created: TODO
---

# Code References

Use references that let readers find the source without inventing anchors.

## Rules

- Verify any cited line number in the current session.
- Prefer a stable symbol plus `path:line` when a symbol exists.
- Language-tag every fenced code block.
- Quote only the lines needed to make the point.
- Label pseudocode and illustrative examples clearly.
- Do not quote secrets, environment files, credentials, generated clients, or build artifacts.

## Artifact Formats

- Chat and scratchpad: use repository-relative `path/file:line` references.
- PRs and reviews: use repository-relative references; use permalinks only for code outside the diff.
- External updates: prefer a commit-pinned permalink over a local path.
