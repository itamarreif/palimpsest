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

# 3. Open INIT_PROMPT.md with your agent
# The agent will walk you through completing the setup
claude
```

## Design

- **Plain text** — Markdown + YAML frontmatter. No database, no API, no vendor lock-in.
- **Human-managed, agent-written** — The agent writes; you review and maintain quality.
- **Obsidian-native** — The directory is a valid Obsidian vault with Bases for dynamic views.
- **Git-tracked** — Every change is versioned and diffable.

## Structure

```
my-agent/
├── MASTER_PROMPT.md        # agent role, startup sequence, skill index
├── INIT_PROMPT.md          # one-time setup prompt (delete after init)
├── scratchpad/
│   ├── profile.md          # domain facts + next_id counter
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

## Scripts

### `scripts/init.sh <directory>`

Scaffolds a new vault from the bundled templates. Creates the full `scratchpad/` and `skills/` directory structure, replaces date placeholders with today's date, and prints next steps.

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
