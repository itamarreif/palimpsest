---
name: code-comments
description: Use when writing source comments, docstrings, TODOs, or migration comments. Keeps rationale in durable artifacts and comments concise.
user-invocable: true
created: TODO
---

# Code Comments

Use comments for non-obvious invariants and external constraints. Use names and types to explain ordinary behavior.

## Rules

- Keep comments to two lines by default. Use up to five only for a non-obvious invariant, external workaround, or complex SQL step.
- Put tradeoffs, historical rationale, and removal conditions in an issue, RFC, or PR description. Link to that artifact when needed.
- Do not restate code behavior that a clearer name can express.
- Every TODO or FIXME needs a tracked issue reference. Use a GitHub issue reference for shared code.
- Keep public API docstrings factual: contract, invariant, inputs, outputs, and errors. Do not explain design history.

## Self-check

1. Can a clearer name replace this comment?
2. Is the reason obvious from nearby code?
3. Does the comment contain a tradeoff or removal condition that belongs in a durable artifact?
4. Does every TODO or FIXME link to tracked work?
