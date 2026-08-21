---
name: work-estimates
description: Use when estimating planned work. Uses T-shirt sizes and observable dimensions instead of calendar time or commit counts.
user-invocable: true
created: TODO
---

# Work Estimates

Estimate scope only after an issue has a plan.

## Rules

- Do not estimate calendar time or commit count.
- State a T-shirt size, confidence, and the dimensions that support it.
- Include files, rough change volume, packages, migrations, public API changes, test surface, and open questions only when applicable.
- State uncertainty explicitly. Open questions reduce confidence.

## Issue Scope Block

```markdown
## Scope

**Initial (YYYY-MM-DD):** Size M, medium confidence.
- Files: ~8 / LoC: ~250 / Packages: 2 / Migrations: 0 / Public API: 1 / Open Qs: 2
- Risk: medium — shared workflow changes.

**Actual (YYYY-MM-DD):**
- Files: 9 / LoC: 280 / Packages: 2 / Migrations: 0 / Public API: 1
```

Append re-estimates when the plan changes. Record actuals before archival when a linked PR or diff can measure them.
