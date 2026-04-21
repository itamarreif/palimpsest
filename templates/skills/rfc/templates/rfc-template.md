---
title: <short descriptive title>
status: Draft
created: YYYY-MM-DD
updated: YYYY-MM-DD
contributors: []
related: []
gh-prs: []
gh-issues: []
tags: []
---

<!--
  Template guidance: This is a starting point, not a binding structure.
  Adapt sections to fit the RFC's scope.

  For implementation-focused RFCs, consider:
  - "What this document is" — reader-oriented framing (who should read this, when)
  - Current state walkthrough with code context (numbered steps + bullet points,
    not raw file:line references in prose)
  - Proposed implementation with call trees and method signatures
  - Reviewer checklist for the implementing PR
  - Design decisions as a resolved table (Decision | Resolution | Rationale)
  - Open questions split by scope (current work vs broader follow-ups)
  - Future context (e.g. migration path) separated from the main proposal
  - In-flight work section for related PRs/proposals that affect the design

  Style:
  - Keep code snippets focused — show the key call or invariant, not full method bodies
  - Use prose + bullet points over large code blocks for explaining behavior
  - Separate "what exists today" from "what we propose" from "future context"
-->

# RFC: <title>

---

## Summary

[1-2 sentence high-level description of what this RFC proposes]

---

## Motivation/Goals

[Why does this change need to happen? What problem does it solve? What are the specific goals?]

---

## Current State

[Document the existing behavior, architecture, or code paths that are relevant. Include code references with file paths and line numbers where helpful.]

### [Subsection: Relevant Component 1]

[Description of current behavior, with code snippets if helpful]

```
// Example code showing current behavior
// path/to/file:123-145
```

---

## Proposed Solution

[High-level description of the approach]

### 1. [First Major Change]

[Detailed description]

**Migration/Schema Changes** (if applicable):

```sql
-- migrations/YYYYMMDDHHMMSS_description.up.sql
```

**Code Changes**:

```
// path/to/file
```

---

## Design Decisions

### [Decision 1: Why X Instead of Y]

[Explain the tradeoffs considered and why this approach was chosen]

---

## Migration/Rollout Plan

1. **Phase 1**: [Description]
2. **Phase 2**: [Description]
3. **Verification**: [How to verify success]

---

## Open Questions

- [ ] [Question 1]

---

## Appendix

### Related Files

| File | Purpose |
|------|---------|
| `path/to/file` | [Description] |
