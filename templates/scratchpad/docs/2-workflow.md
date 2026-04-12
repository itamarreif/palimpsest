---
title: "Workflow"
created: TODO
updated: TODO
tags: [meta, workflow]
---

How this scratchpad system works. Read this at every session startup, before reading the profile or any issues.

---

## Directory Structure

```
scratchpad/
├── profile.md          # domain facts + next_id counter (unnumbered singleton)
├── actives.base        # Obsidian Bases: open issues
├── recents.base        # Obsidian Bases: recent activity
├── docs/               # durable knowledge (numbered)
├── issues/             # active workstreams (numbered)
├── rfcs/               # design documents (numbered, optional)
└── archive/            # retired content, preserved forever
    ├── issues/
    ├── docs/
    └── rfcs/
```

## Numbering

Every file under `scratchpad/` has a globally unique sequential ID as its filename prefix: `1-safety-rails.md`, `7-some-issue.md`.

The counter lives in `scratchpad/profile.md` frontmatter as `next_id`.

**To allocate a new ID:**
1. Read `next_id` from `scratchpad/profile.md` frontmatter
2. Create the new file as `<next_id>-<slug>.md`
3. Increment: `obsidian property:set name="next_id" value="<N+1>" file="profile"`

IDs are never reused, even after archiving.

## Memory Types

**Issues** — workstreams. Track in-flight work with a `status`, `## Plan` checkboxes, and optional parent/child links. Status values: `draft`, `in-progress`, `done`, `cancelled`.

**Docs** — settled knowledge. No `status` field. Durable reference material that evolves via edits.

**Profile** — user facts singleton. One unnumbered file. Append-and-update only; never rewrite.

**Archive** — retired issues, docs, and RFCs. Move here when done; never delete.

## Session Workflow

```
user prompt / task
      │
      ▼
does an issue exist for this?
├── yes → read it
└── no  → create new issue (allocate next_id)
      │
      ▼
do the work
      │
      ▼
update issue (status, plan checkboxes, notes)
      │
      ├── did a general learning crystallize? → write or update a doc
      └── did a user-specific fact emerge?   → update profile.md
      │
      ▼
work complete? → set status: done, archive the issue
```

## Frontmatter Standards

All frontmatter must be valid YAML.

**Issues:**
```yaml
---
title: "Short descriptive title"
status: draft
created: YYYY-MM-DD
updated: YYYY-MM-DD
parent: "[[7-parent|#7]]"   # quoted wikilink; omit if no parent
related:
  - "[[15-a-doc|#15]]"
gh-prs: []                   # plain integers
gh-issues: []                # plain integers
tags: []
---
```

**Docs:**
```yaml
---
title: "Short descriptive title"
created: YYYY-MM-DD
updated: YYYY-MM-DD
related: []
tags: []
---
```

**Wikilink rules:**
- `parent` and `related` values must be quoted: `"[[slug|#N]]"`
- `gh-prs` and `gh-issues` use plain integers: `[12361, 12420]`
- `tags` are inline arrays: `[finance, tax]`
- `#` in unquoted YAML values starts a comment — always quote wikilinks or use integers

## Cross-References

| Location | Format |
|----------|--------|
| Prose | `#35` (short), or `[[35-slug]]` (wikilink) |
| Frontmatter `parent` | `"[[35-slug\|#35]]"` (quoted wikilink) |
| Frontmatter `related` | block list of quoted wikilinks |
| GitHub | plain integers in `gh-prs` / `gh-issues` |

## Obsidian CLI

Use the `obsidian` CLI for frontmatter mutations when Obsidian is running:

```bash
obsidian property:set name="status" value="done" file="35-slug"
obsidian property:set name="updated" value="YYYY-MM-DD" file="35-slug"
obsidian properties file="35-slug" format=json   # verify after writing
```

For multi-item wikilink lists (`related`, `children`), edit YAML directly — the CLI can't reliably handle `[[` in comma-separated values.

---

## Domain-Specific Workflow Notes

TODO: Add any workflow variations specific to your domain, or delete this section if none.
