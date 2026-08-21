---
name: asd-ste100
description: Use ASD-STE100 principles for agent-authored technical prose, including instructions, status updates, artifacts, and error messages.
user-invocable: true
created: TODO
---

# ASD-STE100

Write agent-authored technical prose in a clear, controlled style. This skill uses ASD-STE100 principles. It does not certify formal ASD-STE100 compliance.

## Use This When

- Writing an instruction, status update, issue, RFC, review, tool description, or error message.
- Rewriting technical prose that is dense or ambiguous.
- Writing prose for another agent or a reader who cannot ask the author for clarification.

Do not apply this skill to code, verbatim quotes, user-provided text, creative copy, or marketing copy.

## Rules

- Name the actor for each action. Use active voice unless the actor is unknown or irrelevant.
- Use one stable term for one concept.
- State conditions and limits explicitly.
- Use one action per instruction sentence.
- Target 20 words for instructions and 25 words for descriptions when precision permits.
- Use lists for sequences with three or more steps or conditions.
- Preserve every required fact, exception, scope limit, and safety condition.

## Rewrite Process

1. Read the text for meaning before rewriting it.
2. Identify unclear actors, unstable terms, implied conditions, and combined instructions.
3. Rewrite the text without removing facts or conditions.
4. Keep necessary technical terms. Define uncommon terms when readers need them.

## Boundary

The skill guides clear technical writing. The official ASD-STE100 standard and dictionary define certified compliance.
