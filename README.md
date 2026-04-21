# 📜 Palimpsest

A minimal, portable memory system for AI agents. Plain markdown, YAML frontmatter, git-tracked, human-readable, agent-writable.

## What it is

Palimpsest gives AI agents durable memory across sessions via a structured directory of markdown files — issues, docs, a profile, and skills — that the agent reads at startup and writes to as it works.

## Quick start

```bash
# 1. Clone this repo, then scaffold a new vault in a target directory
./scripts/init.sh ~/my-agent

# 2. Link MASTER_PROMPT.md into your agent's config location
./scripts/link.sh claude codex opencode

# 3. Start your agent inside the new vault and walk through INIT_PROMPT.md.
# The agent will interview you, install the right skills, substitute
# placeholders, and populate domain TODOs.
cd ~/my-agent
claude INIT_PROMPT.md     # or: opencode INIT_PROMPT.md, codex INIT_PROMPT.md
```

## Dependencies

### Always required

- **bash, git** — any modern version. Scripts target stock macOS bash 3.2.
- **[Obsidian](https://obsidian.md)** — the vault is a valid Obsidian vault.
- **Obsidian's built-in CLI** — enable inside Obsidian per https://obsidian.md/help/cli. Core skills (`issue`, `doc`, `archive-issues`, `obsidian-cli`) prefer it for frontmatter and search; they fall back to direct YAML editing if it's not available.

### Required by optional skills

| Skill | Tool | Install |
|-------|------|---------|
| `gh-cli` (+ gh-gated sections in `rfc`, `master-issue`, `weekly-summary`) | `gh` | macOS: `brew install gh` · Debian/Ubuntu: `apt install gh` · otherwise https://cli.github.com. Then run `gh auth login`. |
| `worktree-cleanup` | `rg` (ripgrep) | macOS: `brew install ripgrep` · Debian/Ubuntu: `apt install ripgrep` |
| `diagrams` | Mermaid-capable viewer | Obsidian, GitHub preview, or VS Code with a Mermaid extension |

INIT_PROMPT will print a tailored dependency checklist for your installed skill set after it finishes setup.

## Design

- **Plain text** — Markdown + YAML frontmatter. No database, no API, no vendor lock-in.
- **Human-managed, agent-written** — The agent writes; you review and maintain quality.
- **Obsidian-native** — The directory is a valid Obsidian vault with Bases for dynamic views.
- **Git-tracked** — Every change is versioned and diffable.
- **Portable across domains** — Core skills extend the scratchpad system; optional skills adapt it to specific workflows (coding, status reporting, design documents).

## Structure

```
my-agent/
├── MASTER_PROMPT.md        # agent role, startup sequence, skill index
├── INIT_PROMPT.md          # one-time setup prompt (delete after init)
├── scratchpad/
│   ├── profile.md          # domain facts + ## Config section + next_id counter
│   ├── actives.base        # Obsidian Bases: open issues
│   ├── recents.base        # Obsidian Bases: recent activity
│   ├── docs/               # durable knowledge
│   ├── issues/             # active workstreams
│   ├── rfcs/               # design documents (optional)
│   └── archive/            # retired content, preserved
│       ├── issues/
│       ├── docs/
│       └── rfcs/
└── skills/                 # agent procedures (SKILL.md per skill)
```

## Skills

Skills are procedural guides loaded on demand. They fall into two tiers.

### Core (always installed)

| Skill | What it does |
|-------|--------------|
| `issue` | Create and maintain scratchpad issues |
| `doc` | Create and maintain durable docs |
| `archive-issues` | Move done/cancelled issues to archive |
| `scratchpad-maintenance` | Route scratchpad hygiene tasks to the right skill |
| `obsidian-cli` | Frontmatter, search, backlinks, Bases via the `obsidian` CLI |
| `diagrams` | Produce Mermaid / D2 / ASCII diagrams inside scratchpad artifacts |
| `cross-vault` | Read or delegate to another palimpsest vault (see Composing vaults below) |

### Optional (selected during INIT_PROMPT)

| Skill | Bundle | What it does |
|-------|--------|--------------|
| `git` | `github` | Local git workflows, branch naming, conflict resolution |
| `gh-cli` | `github` | GitHub PRs, issues, checks, comments, sub-issues via `gh` |
| `worktree-cleanup` | `github` | Audit and clean up registered git worktrees |
| `rfc` | `structured-design` | Orchestrate RFC drafting, research, and PR handoff |
| `master-issue` | `structured-design` | Rollup tracking for multi-PR, multi-session workstreams |
| `slack-summary` | `reporting` | Draft Slack-ready status updates and standup blurbs |
| `weekly-summary` | `reporting` | Cross-reference GitHub PRs with scratchpad state; produce a weekly summary |

During `INIT_PROMPT.md`, the agent interviews you with three bundle questions and an escape hatch, then:

1. Prunes optional skills you didn't select.
2. Substitutes per-vault placeholders (target repos, branch prefix, worktree dir, stack) into the retained skills.
3. Records scratchpad-wide config values in `scratchpad/profile.md`'s `## Config` section.
4. Appends the installed optional skills to `MASTER_PROMPT.md`'s skill index.

## Per-vault config

Values collected during init live in two places:

- **`scratchpad/profile.md` `## Config`** — cross-cutting: scratchpad GitHub repo, target GitHub repos, stack.
- **Each skill's `## Config` section** — skill-specific: branch prefix and worktree dir (in `git` and `worktree-cleanup`).

Update these files directly if your values change later. Skills reference them by name; the agent reads them on demand.

## Composing vaults

A palimpsest vault can read from or delegate questions to other palimpsest vaults the same operator maintains. This makes it easy to have specialized agents — one for coding, one for finance, one for research — that can cross-reference each other when a question spans their domains.

Composability is **trust-based** (any linked vault is fully readable, no public/private boundary) and assumes all linked vaults follow the same palimpsest structure.

### How linking works

Each vault declares the others it knows about in its `profile.md`:

```markdown
## Linked Vaults

| Name | Local path | Remote | Interaction | Notes |
|------|-----------|--------|-------------|-------|
| coding-agent | `~/vaults/coding-agent` | `github.com:alice/coding-agent` | link + ask | Engineering work |
| finance-agent | `~/vaults/finance-agent` | `github.com:alice/finance-agent` | link + ask | Personal finance |
```

The `cross-vault` core skill uses this table to look up linked vaults on demand.

### Two modes

- **Linking** — read another vault's issues, docs, RFCs directly. Good for citing a specific artifact or looking up a fact. Cross-vault wikilinks use a qualifier: `[[coding-agent:37-refactor-payments]]`.
- **Asking** — spawn a new agent session pointed at the linked vault and delegate a question. Good when the answer depends on interpretation the owning agent is better positioned to do.

Both modes are **read-only**. Cross-vault is never used to write into another vault.

### Multi-machine setup

Each vault is typically its own git repo. On each machine or container you work from, clone the vaults you need. The `cross-vault` skill fails clearly when a linked vault isn't cloned locally, printing the exact `git clone` command — it never auto-clones.

For questions that drive decisions (PR state, active handoffs, time-sensitive data), the skill suggests `git -C <linked-vault> pull` before reading to ensure freshness. For passive reference reads, it trusts the current checkout.

### Adding a link

During INIT_PROMPT, the agent asks whether you want to link existing vaults and records them in the `## Linked Vaults` table. You can also add entries later by editing the table directly in `scratchpad/profile.md`.

To add a new specialized agent to your setup, run `scripts/init.sh` for that new vault separately, then add each vault as a link in the other's `## Linked Vaults` table.

## Scripts

### `scripts/init.sh <directory>`

Scaffolds a new vault from the bundled templates. Copies the full `scratchpad/` and `skills/` directory structure, replaces `created:` / `updated:` frontmatter date sentinels with today's date, and prints next steps.

Refuses to run if `scratchpad/profile.md` already exists in the target.

```bash
./scripts/init.sh ~/my-agent
```

### `scripts/link.sh [-f] <agent...>`

Symlinks `MASTER_PROMPT.md` into each agent's expected config location.

| Agent | Destination |
|-------|-------------|
| `claude` | `~/.claude/CLAUDE.md` |
| `codex` | `~/.codex/AGENTS.md` |
| `opencode` | `~/.config/opencode/AGENTS.md` |

Pass `-f` to overwrite an existing file or symlink at the destination. Without `-f`, the script errors and skips any destination that already exists.

```bash
./scripts/link.sh claude opencode        # link two agents
./scripts/link.sh -f claude              # overwrite existing
```
