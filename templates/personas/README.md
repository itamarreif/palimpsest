# Personas

Personas define the agent voice and response budget for a type of work. They do not define workflow steps. Skills and `MASTER_PROMPT.md` define workflow.

## Selection

1. The persona with `default: true` applies to chat and skills without a persona declaration.
2. A skill can set `persona: <name>` in its frontmatter to override the default.
3. A persona name must match a file at `personas/<name>.md`.

The scaffold includes `collaborator` as the default and `principal` for durable artifacts. Add a persona only when its voice or output rules differ from both existing personas.

If a selected persona file is missing, use the default persona and report the configuration error before writing a durable artifact.
