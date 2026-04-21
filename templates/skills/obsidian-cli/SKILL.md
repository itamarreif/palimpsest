---
name: obsidian-cli
description: Interact with the scratchpad vault via the Obsidian CLI for property management, search, backlink discovery, and navigation. Use when reading/writing frontmatter properties, searching the vault, or querying Bases.
user-invocable: true
created: TODO
---

# Obsidian CLI

Use the `obsidian` CLI to interact with the vault. Requires Obsidian to be running.

## CLI-First Principle

**Default to the CLI for all frontmatter mutations.** Only fall back to direct YAML editing when:

- Obsidian isn't running (`obsidian version` fails)
- The operation requires multi-item wikilink lists (CLI can't comma-separate `[[...]]` values)
- The file doesn't exist yet (write the file first, then use CLI for adjustments)

## Property Operations

### Read

```bash
obsidian property:read name="status" file="35-some-issue"
obsidian properties file="35-some-issue" format=json
```

### Set scalar

Best for `status`, `parent`, `updated`, `title`, `next_id`, and single-value fields:

```bash
obsidian property:set name="status" value="done" file="35-some-issue"
obsidian property:set name="updated" value="YYYY-MM-DD" file="35-some-issue"
obsidian property:set name="parent" value="[[7-parent|#7]]" file="35-some-issue"
obsidian property:set name="next_id" value="36" file="profile"
```

### Set list (non-wikilink items)

Works for `gh-prs`, `gh-issues`, `tags`:

```bash
obsidian property:set name="gh-prs" type=list value="12361, 12420" file="35-some-issue"
obsidian property:set name="tags" type=list value="finance, tax" file="35-some-issue"
```

### Set list (wikilink items)

The CLI can't reliably comma-separate wikilinks (`[[` confuses the parser). For multi-item wikilink lists (`related`, `children`), edit the YAML directly:

```yaml
related:
  - "[[15-some-doc|#15]]"
  - "[[22-another-issue|#22]]"
```

For a single-item wikilink list, the CLI works:

```bash
obsidian property:set name="related" value="[[15-slug|#15]]" file="35-some-issue"
```

### Remove

```bash
obsidian property:remove name="blocked-by" file="35-some-issue"
```

## Verify After Write

After creating a file or making structural frontmatter changes, verify Obsidian parsed the YAML correctly:

```bash
obsidian properties file="35-some-issue" format=json
```

Check that:
- All expected fields are present (not null)
- List fields are arrays, not strings
- Wikilink values are properly quoted

Common failure causes:
- Block list item on the same line as the key: `related:   - "[[...]]"` (must be on its own line)
- Unquoted values containing colons, brackets, or `#`
- Missing quotes around wikilink values

## Task Management

```bash
obsidian tasks todo file="35-some-issue"           # list open checkboxes
obsidian tasks todo file="35-some-issue" verbose    # with line numbers
obsidian task file="35-some-issue" line=30 done     # mark a task complete
obsidian tasks todo                                  # all open tasks in vault
```

## Search & Discovery

```bash
obsidian search query="keyword" limit=10
obsidian search:context query="keyword" limit=5
obsidian backlinks file="35-some-issue"
obsidian backlinks file="35-some-issue" total
```

## Bases Queries

```bash
obsidian base:query file="scratchpad/actives.base" view="Active Issues" format=tsv
obsidian base:query file="scratchpad/actives.base" view="Active Issues" format=json
obsidian base:query file="scratchpad/recents.base" view="Recently Updated" format=tsv
```

## Tag Hygiene

```bash
obsidian tags sort=count counts          # full tag inventory
obsidian tags name="topic" verbose       # files with a specific tag
```

## Link Integrity

After moving, renaming, or deleting files:

```bash
obsidian unresolved verbose
```

**Expected unresolved entries**: cross-vault wikilinks of the form `[[vault-name:N-slug]]` always show up here because Obsidian vaults are isolated and can't resolve external qualifiers. The `cross-vault` skill owns these references. Filter them from the broken-link baseline when scanning for real issues.

## Navigation

```bash
obsidian open file="35-some-issue"          # open in Obsidian
obsidian open file="35-some-issue" silent   # refresh cache without focus
```

## Scratchpad Conventions

### Frontmatter schema — issues

```yaml
---
title: "Short descriptive title"
status: in-progress
created: 2026-04-12
updated: 2026-04-12
parent: "[[7-parent|#7]]"
related:
  - "[[15-a-doc|#15]]"
gh-prs: [12361, 12420]
gh-issues: [9886]
tags: [topic, domain]
---
```

### Frontmatter schema — docs

```yaml
---
title: "Short descriptive title"
created: 2026-04-12
updated: 2026-04-12
related: []
tags: [topic]
---
```

### Cross-reference formats

| Location | Format |
|----------|--------|
| Frontmatter `parent` | `"[[N-slug\|#N]]"` (quoted wikilink) |
| Frontmatter `related` | block list of quoted wikilinks |
| Frontmatter `gh-prs` / `gh-issues` | plain integers |
| Body prose | `#N` or `[[N-slug]]` |

## Base File Templates

### actives.base — open work dashboard

```yaml
filters:
  and:
    - file.inFolder("scratchpad/issues")
    - file.ext == "md"
    - not:
        - file.inFolder("scratchpad/archive/issues")
    - not:
        - status == "done"
        - status == "cancelled"
formulas:
  days_since_update: if(updated, (today() - date(updated)).days, "")
views:
  - type: table
    name: Active Issues
    groupBy:
      property: status
      direction: ASC
    sort:
      - property: formula.days_since_update
        direction: DESC
  - type: table
    name: Recently Updated
    sort:
      - property: updated
        direction: DESC
```

### recents.base — all scratchpad files, most recent first

```yaml
filters:
  and:
    - file.ext == "md"
    - or:
        - file.inFolder("scratchpad/issues")
        - file.inFolder("scratchpad/docs")
        - file.inFolder("scratchpad/rfcs")
        - file.inFolder("scratchpad/archive/issues")
        - file.inFolder("scratchpad/archive/docs")
        - file.inFolder("scratchpad/archive/rfcs")
formulas:
  type: if(file.inFolder("scratchpad/docs") or file.inFolder("scratchpad/archive/docs"), "doc", if(file.inFolder("scratchpad/rfcs") or file.inFolder("scratchpad/archive/rfcs"), "rfc", "issue"))
views:
  - type: table
    name: Recently Updated
    sort:
      - property: updated
        direction: DESC
    limit: 30
```
