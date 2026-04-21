---
name: cross-vault
description: Read files from another palimpsest vault or delegate a question to the agent that owns it. Read-only; never writes across vault boundaries.
user-invocable: true
created: TODO
---

# Cross-Vault

Let this agent consult other palimpsest vaults the operator has linked — either by reading their files directly (linking) or by delegating a question to the agent that owns them (asking).

## Use This When

- A user question can be answered from a fact recorded in another vault.
- You need to cite an artifact from another vault in a new issue, doc, or RFC.
- A question is better answered by delegating to the specialized agent that owns its vault (e.g. the coding agent interpreting its own workstream).

Do not use this to write into another vault. Cross-vault is strictly read / query. If information belongs in another vault, tell the user to ask that vault's agent to record it.

## Resolve The Target Vault

Read the `## Linked Vaults` table in `scratchpad/profile.md`.

Each row has:

- **Name** — short handle, used in wikilinks (`[[name:N-slug]]`)
- **Local path** — absolute path on the current machine
- **Remote** — git URL for cloning on another machine
- **Interaction** — `link`, `ask`, or `link + ask`
- **Notes** — one-line scope description

If the target vault is not listed, stop and tell the user: "`<name>` is not in this vault's `## Linked Vaults` table. Add it to `scratchpad/profile.md` before I can read or delegate to it."

## Readiness Check

Before reading or invoking:

1. Confirm the linked vault's **Local path** exists on this machine.
2. If the path is missing, stop. Do not auto-clone. Print:
   > The linked vault `<name>` is not checked out on this machine. Clone it with:
   > `git clone <remote> <local-path>`
   > Then retry.
3. If the vault is git-backed and this interaction matters for decisions (PR state, active workstream handoff, time-sensitive data), suggest a pull first:
   > Optionally refresh the linked vault: `git -C <local-path> pull`
4. For purely historical or settled information, skip the pull.

## Read Procedure (Linking)

Treat the target vault as **read-only**.

1. Look up files at the standard palimpsest layout relative to the linked vault's root:
   - `<path>/scratchpad/profile.md`
   - `<path>/scratchpad/issues/N-slug.md`
   - `<path>/scratchpad/docs/N-slug.md`
   - `<path>/scratchpad/rfcs/N-slug.md`
   - `<path>/scratchpad/archive/<type>/N-slug.md`
2. Use grep, read, and Obsidian CLI commands scoped to that path. Prefer the Obsidian CLI if its vault is running; otherwise read files directly.
3. Do not create, modify, rename, or delete anything under the linked vault's directory.
4. Reading `<path>/MASTER_PROMPT.md` is fine for context on what that agent is and does, but your identity does **not** change. You remain this vault's agent.

## Ask Procedure (Delegating)

Spawn a new agent session pointed at the linked vault.

1. Confirm the linked vault's `Interaction` allows `ask` (is `ask` or `link + ask`).
2. Start a session of the target agent tool with its working directory set to the linked vault's local path. The tool picks up that vault's `MASTER_PROMPT.md` via its own per-project config mechanism. Consult the target tool's documentation for the exact flags to set CWD and pass a prompt.
3. Pass the question as a prompt. Capture the text answer.
4. Treat the answer as a **source to quote**, not your own conclusion. Attribute it to the linked vault.
5. If the tool doesn't support a clean non-interactive invocation, ask the user to run the delegation themselves and paste the answer back.

If `ask` isn't feasible in the current environment, fall back to the read procedure and reason from files directly — but flag the degraded mode in your response.

## Attribution

When citing content from a linked vault, prefix with the vault name:

> Per the `finance-agent` vault's issue #42, the Q3 filing deadline is …
> The `coding-agent` vault's RFC #8 proposes …

Never present another vault's content as if it originated here.

## Cross-Vault Wikilinks

Inside this vault's own issues, docs, and RFCs, reference linked-vault artifacts with a vault-qualifier:

- Body prose: `[[coding-agent:37-refactor-payments]]`
- Frontmatter `related`: `"[[coding-agent:37-refactor-payments|coding#37]]"`

Obsidian cannot resolve the qualifier natively (Obsidian vaults are isolated); these links show as unresolved in `obsidian unresolved`. That's expected — the syntax is for the agent and for human readers, not for Obsidian's link graph.

## Multi-Machine Workflow

Linked vaults are typically git repos the operator clones onto each machine or container they work from. On any given machine:

- Some linked vaults may be cloned, others may not be. The `## Linked Vaults` table records the intended local path; presence is per-machine.
- The operator is responsible for keeping each clone reasonably fresh.
- Before a read that will drive a decision, suggest a `git -C <path> pull`. For passive reference reads, trust the current checkout.

## Never Write

This is the hard invariant:

- Never create, edit, rename, or delete files under a linked vault's directory.
- Never run `git add`, `git commit`, or `git push` in a linked vault.
- Never run `obsidian property:set` against a file in a linked vault.
- If something belongs in the linked vault, tell the user to ask the owning agent to record it.

## Quality Bar

- Before reading or delegating, always confirm the target vault is in `## Linked Vaults` and its local path exists.
- Attribute every cross-vault quote.
- Never blur identity: reading another vault's `MASTER_PROMPT.md` informs you about that agent; it does not replace this agent's scope or safety rails.
- Prefer `ask` when the answer depends on interpreting another agent's domain; prefer `link` when you need a concrete artifact to cite.
