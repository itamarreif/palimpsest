---
name: git
description: Handle common local git workflows safely — inspect status, branch work, stage changes, draft commits, and verify results.
user-invocable: true
created: TODO
---

# Git

Use this skill for common local repository workflows.

## Config

Fill these in during init. Update here if they change.

- **Branch prefix**: `{{BRANCH_PREFIX}}` (convention: `{{BRANCH_PREFIX}}<domain>/<task>`)
- **Worktree dir**: `{{WORKTREE_DIR}}` (repo-local parent directory for worktrees)

## Use This When

- Inspecting a repo before making changes.
- Reviewing local diffs, staged changes, or recent commits.
- Creating or switching branches.
- Staging files and creating commits.
- Checking whether a branch is ahead, behind, or ready for a PR.

Do not use this for GitHub-hosted operations like opening PRs or reading issue comments — use `gh-cli` for that.

## Default Preference

- Prefer the local `git` CLI over `gh` whenever the question is about local repo state, commit history, branch structure, rebases, staged content, or diff inspection.
- Reach for `gh` only when the source of truth lives on GitHub: PR metadata, review state, issue discussion, checks, CI runs, comments, or remote search.
- If both tools could answer the question, default to `git` first and then use `gh` only for the GitHub-specific layer.

## Procedure

### 1. Start with repo state

- Run `git status` first.
- For non-trivial implementation work, also confirm `pwd`, `git branch --show-current`, and `git worktree list` so the active repo context is explicit.
- When worktree use is likely, check `git worktree list` for an existing intended worktree before creating a new one.
- If commit or PR work is involved, also inspect `git diff` and recent `git log` so the change and local message style are clear.
- Treat unrelated dirty files as user-owned unless the task explicitly says to clean them up.

### 2. Prefer safe local operations

- For non-trivial code changes, prefer a dedicated repo-local worktree over using the main checkout directly. Reuse an existing intended worktree when one is already present.
- Create or switch branches with non-destructive commands.
- Do not use `git -C <path>` or `cd ... && git ...` for routine git operations. Run git in the intended repo or worktree by setting the Bash tool `workdir` instead, so repo context and permission matching stay consistent.
- Avoid git commands that open an interactive editor in a non-interactive session; prefer explicit flags like `-m`, `-F`, or `--no-edit` when appropriate.
- For worktree creation, fetch the base branch first, then create the worktree from `origin/main` unless the user explicitly wants another stack base.
- Prefer `git worktree add "{{WORKTREE_DIR}}<name>" -b <branch-name> origin/main`.
- Prefer domain-first branch names that match the actual workstream, e.g. `{{BRANCH_PREFIX}}reports/reconciliation-tests` or `{{BRANCH_PREFIX}}funds/extract-sweep-service`.
- Use the stable prefix `{{BRANCH_PREFIX}}` by default rather than ad-hoc alternatives.
- Favor `{{BRANCH_PREFIX}}<domain>/<task>` or `{{BRANCH_PREFIX}}<domain>/<subarea>/<task>` over generic type-first names like `{{BRANCH_PREFIX}}feat/<task>` when the domain is clear.
- Reserve generic buckets like `chore`, `fix`, `test`, or `ci` for work that truly spans domains or does not have a natural code-area home.
- When handing off a branch for PR creation, keep the branch name and local history clean enough that `gh-cli` can open a draft PR assigned to `@me` without extra cleanup.
- Prefer rebasing a feature branch onto its base branch to keep the branch history linear and preserve the branch's own sequence of changes.
- Avoid local merge commits on feature branches unless the user explicitly wants them.
- Stage only files relevant to the task.
- Before committing, verify what is staged, not just what is modified.
- Use Conventional Commits unless the repo clearly follows another style.

### 3. Commit carefully

- Never commit unless explicitly asked.
- Never rely on a terminal editor for commit, merge, rebase, or tag messages; write the message in the command itself or use a file/input flag.
- Prefer small, incremental commits that capture one logical step at a time and are easy to squash later.
- Draft commit messages around intent and why, not a file list.
- Treat branch commit history as working history: useful for review and recovery, but not something that needs to be polished as the permanent record when the repo merges with squash.
- If hooks fail, fix the problem and create a new commit rather than reaching for `--amend` by default.
- Do not use interactive git flows like `git rebase -i` in this environment.
- During conflict resolution, prefer a non-interactive rebase flow: resolve files, stage them, then run `GIT_EDITOR=true git rebase --continue`.
- Use `GIT_EDITOR=true` only as a one-shot override for commands that may invoke an editor during automation; do not modify `git config core.editor` globally.
- Avoid destructive commands like hard reset or checkout-overwrite.
- If a rebase rewrites an already-pushed branch, note that updating the remote will require a force push and only do that when the user explicitly asks.

### 4. Verify after each mutation

- After branch changes, confirm the current branch and tracking state.
- After staging, confirm the staged diff.
- After committing, run `git status` to verify the tree is in the expected state.
- Before committing, run the project's standard format / lint / test toolchain. This vault's stack: **{{STACK}}** — use the canonical commands for that stack.
- Do not pipe verification commands through `grep`, `head`, `tail`, or similar shell filters; run them directly and rely on the tool's captured output or command-specific flags instead.

## Quality Bar

- Make the current git state legible before changing it.
- Preserve unrelated user work.
- Keep branch names organized around the code area or workstream so active branches are easy to scan locally.
- Optimize branch history for clean rebases and easy squash-merge, not for permanent granular commit archaeology.
- Prefer reversible, inspectable steps over clever one-liners.
- Avoid duplicate worktrees, interactive editor prompts, and reporting work as verified from intermediate compile checks alone.
