# 📜 Palimpsest

A minimal, portable memory system for AI agents. Plain markdown, YAML frontmatter, git-tracked, human-readable, agent-writable.

## What it is

Palimpsest gives AI agents durable memory across sessions via a structured directory of markdown files — issues, docs, a profile, and skills — that the agent reads at startup and writes to as it works.

## Quick start

```bash
# 1. Create and initialize your repo
mkdir my-agent && cd my-agent && git init

# 2. Scaffold the structure
palimpsest init .

# 3. Open INIT_PROMPT.md with your agent
# The agent will walk you through completing the setup
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

## CLI

```bash
palimpsest init <directory>   # scaffold a new instance
palimpsest new issue "title"  # create a numbered issue
palimpsest new doc "title"    # create a numbered doc
palimpsest done <id>          # mark issue done
palimpsest archive <id>       # move to archive/
palimpsest status             # show open issues
palimpsest lint               # validate frontmatter
```
