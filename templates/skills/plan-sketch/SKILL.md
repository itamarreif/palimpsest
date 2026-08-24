---
name: plan-sketch
description: Use when a user asks for a detailed implementation plan, plan shape, or a plan that needs more than a checklist.
user-invocable: true
persona: collaborator
created: TODO
---

# Plan Sketch

Use this skill for broad work where a task list alone would hide design choices.

## Procedure

1. Read the owning issue and relevant source, documentation, or external state.
2. State verified existing behavior separately from proposed changes.
3. Add only the planning artifacts that resolve a real ambiguity: shape table, call graph, state diagram, diff sketch, or execution order.
4. Use `diagrams` for flows, state machines, entity relationships, and decision trees.
5. Set `## Plan` state to `not-needed`, `shaping`, `ready`, or `stale`.
6. Add work items and verification that follow from the chosen shape.
7. Add a `## Scope` estimate through `work-estimates` after the plan is concrete.

## Plan States

- `not-needed`: a narrow checklist is sufficient.
- `shaping`: an unresolved decision changes implementation shape.
- `ready`: verified shape can guide implementation.
- `stale`: new evidence contradicts the plan.

## Quality Bar

- The plan identifies what exists, what changes, and why.
- Proposed behavior is labeled as proposed.
- Work items and verification follow from the plan rather than inventing architecture during implementation.
