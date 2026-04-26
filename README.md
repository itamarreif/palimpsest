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
# The agent will walk you through completing the setup,
# including selecting which optional skills to keep.
claude
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

## Scripts

### `scripts/init.sh <directory>`

Scaffolds a new vault from the bundled templates. Copies the full `scratchpad/` and `skills/` directory structure, replaces `created:` / `updated:` frontmatter date sentinels with today's date, and prints next steps.

Refuses to run if `scratchpad/profile.md` already exists in the target.

```bash
./scripts/init.sh ~/my-agent
```

### `scripts/link.sh [-f] [--vault <vault-dir>] [--dir <project-dir>] <agent...>`

Symlinks `MASTER_PROMPT.md` into each agent's expected config location.

**Global destinations (default):**

| Agent | Destination |
|-------|-------------|
| `claude` | `~/.claude/CLAUDE.md` |
| `codex` | `~/.codex/AGENTS.md` |
| `opencode` | `~/.config/opencode/AGENTS.md` |

**Options:**

- `-f` — overwrite an existing file or symlink at the destination (default: error and skip)
- `--vault <path>` — path to the vault containing `MASTER_PROMPT.md`. Defaults to the parent directory of the script. Use this when running `link.sh` from the palimpsest repo against a vault installed elsewhere.
- `--dir <path>` — link into a project directory instead of the global config, so agents load the vault automatically when working anywhere under that directory tree:

  | Agent | Destination |
  |-------|-------------|
  | `claude` | `<path>/CLAUDE.md` |
  | `codex` | `<path>/AGENTS.md` |
  | `opencode` | `<path>/.opencode/AGENTS.md` |

```bash
# Link to global agent configs (typical first-time setup)
./scripts/link.sh claude opencode

# Overwrite an existing global link
./scripts/link.sh -f claude

# Link to a project directory — vault lives outside the palimpsest repo
./scripts/link.sh --vault ~/.agents --dir ~/code/ai claude opencode
```
