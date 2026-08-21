---
name: pr-scope-analysis
description: Use when analyzing why a GitHub PR is large, where change volume is concentrated, or how to split an oversized PR.
user-invocable: true
persona: collaborator
created: TODO
---

# PR Scope Analysis

Use this skill with `gh-cli` to explain PR scope by review concept rather than raw file count.

## Procedure

1. Fetch file statistics with `gh pr view <PR> --json files`.
2. Report files, additions, deletions, and changed lines. Changed lines equal additions plus deletions.
3. Rank the largest changed files.
4. Group files into repository-specific subsystems after inspecting their paths.
5. Show a changed-line histogram with each bucket's percentage.
6. Explain which review concepts caused the scope and which files are mechanical fanout.
7. If a split is needed, recommend boundaries by independently reviewable behavior.

## Rules

- Calculate percentages from changed lines, not additions alone.
- Do not treat generated files or caches as primary design scope.
- Keep small supporting changes separate from the dominant review concept.
- Do not suggest a split that leaves either branch behaviorally incomplete.

## Output

1. One-line totals.
2. `text` histogram by subsystem.
3. `text` list of largest files.
4. Direct explanation of scope drivers.
5. Optional split recommendation.
