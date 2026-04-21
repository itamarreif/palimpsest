---
name: gh-cli
description: Use the GitHub CLI for issues, pull requests, checks, comments, releases, and other GitHub-hosted workflows.
user-invocable: true
created: TODO
---

# GH CLI

Use this skill for GitHub workflows performed through `gh`.

## Use This When

- Reading or updating GitHub issues.
- Creating, viewing, or updating pull requests.
- Inspecting PR comments, reviews, checks, or CI runs.
- Looking up release or repository metadata from GitHub.
- Translating a GitHub URL into the corresponding `gh` command flow.
- Addressing or responding to PR review comments by making local code changes and pushing.

Do not use this for local-only git operations like staging, committing, or worktree cleanup — use `git` for those.

## Default Preference

- Prefer local `git` over `gh` for branch history, local diffs, staging state, rebases, merge-base analysis, blame, and commit archaeology in a checked-out repo.
- Use `gh` when the question depends on GitHub-hosted state: PR bodies, review comments, checks, Actions runs, issue threads, linked discussions, or remote search.
- For PR investigation, combine them intentionally: use `git` to understand the code and branch history, then use `gh` to understand the PR framing, review state, and CI outcome.

## Target Repositories

This agent operates on: **{{TARGET_REPOS}}** (primary: **{{PRIMARY_REPO}}**).

When a task mentions a repo explicitly, use that one. When the task is ambiguous and multiple target repos are configured, confirm with the user which repo applies before running mutating commands.

## Procedure

### 1. Ground the operation in repo context

- If the task touches a local checkout, start with local `git` state first so you know what the GitHub action should include.
- For PR creation, understand the full branch diff since divergence from the base branch, not just the last commit.
- Prefer a rebased, linear branch before opening or updating a PR when that can be done safely.
- Before opening a PR from a local checkout, re-confirm `pwd`, `git branch --show-current`, and `git worktree list` so the PR comes from the intended branch and worktree.
- Before opening a PR, make sure the branch has already gone through the project's standard format / lint / test toolchain for the stack (**{{STACK}}**). Do not treat intermediate compile checks alone as sufficient final verification.
- For issue or PR updates, read the current remote state before mutating it.

### 2. Prefer `gh` over ad hoc web fetching

- Use `gh` for issues, PRs, comments, checks, releases, and repository metadata.
- When given a GitHub URL, translate it into the corresponding `gh` command instead of scraping the page.
- Use `gh api` when higher-level `gh` subcommands do not expose the needed field directly.

### 3. Use the right workflow for common GitHub tasks

- **Compare the real contents of a PR**: inspect the PR summary, changed files, commit list, and full diff against base; do not reason from the latest commit alone.
- **Create a PR**: open it as a draft by default (`gh pr create --draft --assignee "@me" ...`), assign it to `@me` unless the user asks for a different owner, then mark it ready only when the branch is actually ready for review.
- **Understand failing CI**: start from PR checks, identify the failing run/job, then inspect failed logs before guessing at the cause.
- **Explain conflict-resolution follow-ups**: if resolving conflicts changed behavior or required choosing one side's logic, update the PR body or add a PR comment with the decision, rationale, and any follow-up risk.
- **Investigate historical context**: use GitHub search, linked issues, related PRs, and prior merged work in the same area to understand why the code looks the way it does.
- **Address PR review comments**: when asked to address or respond to comments left on a PR, follow the dedicated workflow in section 3a below.

### 3a. Addressing PR review comments

When the user asks you to address, respond to, or fix comments left on a PR (by the user, a teammate, or a reviewer), follow this workflow.

#### Philosophy

Review comments are addressed through code, not conversation. The goal is to make the requested changes locally, verify they work, and push — so the reviewer can see the fix in the next diff. **Do NOT post reply comments on GitHub.** The pushed code is the response.

#### Procedure

1. **Fetch the comments**:
   - Use `gh api repos/{owner}/{repo}/pulls/<number>/comments` to get review comments (inline/file-level).
   - Use `gh pr view <number> --comments` for top-level conversation comments.
   - Use `gh api repos/{owner}/{repo}/pulls/<number>/reviews` to get review-level summaries when needed.
   - Parse out the comment body, the file path, and the line number so you know exactly where each comment applies.

2. **Triage the comments**:
   - Separate actionable comments (code changes needed) from questions or discussion-only comments.
   - For questions or discussion-only items, surface them to the user and ask how to proceed rather than guessing.
   - Group related comments that touch the same area so you can address them together.

3. **Address each comment locally**:
   - Make the code changes on the local branch in the appropriate worktree.
   - If a comment requests a non-trivial design change or you disagree with the suggestion, surface it to the user before implementing — do not silently ignore or reinterpret feedback.

4. **Verify the changes work**:
   - Run the standard verification for the project's stack (**{{STACK}}** — format, lint, tests).
   - Do not skip verification just because the changes seem small.

5. **Commit and push**:
   - Commit the changes with a clear message referencing that review feedback was addressed (e.g., `fix(scope): address PR review feedback`).
   - Push to the remote branch so the reviewer sees the updates in the PR.

6. **Report back to the user**:
   - Summarize which comments were addressed and how.
   - Call out any comments that were not addressed and why (e.g., needs user decision, disagreement, out of scope).
   - **Do NOT post reply comments on GitHub.** The pushed commit is the response. If the user wants to reply on GitHub, they can do so themselves.

### 4. Useful command patterns

#### CI status and debugging

- **Quick CI status check**:
  - `gh pr checks <number>` — at-a-glance pass/fail/pending for all checks on a PR
  - `gh pr checks <number> --watch` — poll until all checks complete
- **Identify failing runs**:
  - `gh run list --branch <branch>` — list recent workflow runs for the branch
  - `gh run list --branch <branch> --status failure` — show only failed runs
- **Debug a failed run**:
  - `gh run view <run-id>` — overview of jobs and their status
  - `gh run view <run-id> --log-failed` — dump logs from only the failed steps
  - `gh run view <run-id> --job <job-id> --log` — full log for a specific job when you need more context
- **Re-run failed CI**:
  - `gh run rerun <run-id> --failed` — re-run only the failed jobs

#### PR comparison

- `gh pr view <number> --json title,body,baseRefName,headRefName,files,commits,reviews`
- `gh pr diff <number>`

#### PR creation

- `gh pr create --draft --assignee "@me" --title "..." --body-file <file>`
- When the body is inline, prefer a HEREDOC and keep `--assignee "@me"` unless the user explicitly requests a different assignee.

#### Updating PRs and issues

- **Edit PR title**:
  - `gh pr edit <number> --title "new title"`
- **Edit PR body**:
  - `gh pr edit <number> --body "new body"` — inline for short updates
  - `gh pr edit <number> --body-file <file>` — from file for longer content
  - Use a HEREDOC when constructing multi-line bodies inline
- **Edit issue title**:
  - `gh issue edit <number> --title "new title"`
- **Edit issue body**:
  - `gh issue edit <number> --body "new body"`
  - `gh issue edit <number> --body-file <file>`
- **Add/remove labels, assignees, milestones**:
  - `gh pr edit <number> --add-label "bug" --add-assignee "@me"`
  - `gh issue edit <number> --add-label "priority" --remove-label "triage"`

#### Commenting on PRs and issues

- **Comment on a PR**:
  - `gh pr comment <number> --body "..."` — general comment
  - `gh api repos/{owner}/{repo}/pulls/<number>/comments` — view existing review comments
- **Comment on an issue**:
  - `gh issue comment <number> --body "..."`
- **View existing comments**:
  - `gh pr view <number> --comments` — show PR conversation
  - `gh issue view <number> --comments` — show issue conversation

#### Fetching PR review comments

- **Inline review comments** (file-level, line-level):
  - `gh api repos/{owner}/{repo}/pulls/<number>/comments` — returns all inline review comments with `path`, `line`, `body`, and `user`
  - `gh api repos/{owner}/{repo}/pulls/<number>/comments --jq '.[] | {id: .id, user: .user.login, path: .path, line: .line, body: .body}'` — extract the actionable fields
- **Top-level conversation comments**:
  - `gh pr view <number> --comments` — conversation thread
  - `gh api repos/{owner}/{repo}/issues/<number>/comments --jq '.[] | {id: .id, user: .user.login, body: .body}'` — structured extraction
- **Review summaries**:
  - `gh api repos/{owner}/{repo}/pulls/<number>/reviews --jq '.[] | {id: .id, user: .user.login, state: .state, body: .body}'`

#### Master issues with sub-issues

Use GitHub's native sub-issue feature (GraphQL `addSubIssue` mutation) instead of manually listing sub-issues in markdown. Native sub-issues show up in the sidebar, track completion automatically, and are queryable.

**Workflow:**

1. Create the master issue with `gh issue create`.
2. Create each sub-issue with `gh issue create`.
3. Get node IDs for all issues:
   ```bash
   gh api graphql -f query='query {
     repository(owner: "OWNER", name: "REPO") {
       parent: issue(number: PARENT_NUM) { id }
       child1: issue(number: CHILD1_NUM) { id }
       child2: issue(number: CHILD2_NUM) { id }
     }
   }' --jq '.data.repository'
   ```
4. Link each sub-issue to the parent:
   ```bash
   gh api graphql -f query='mutation {
     addSubIssue(input: {
       issueId: "PARENT_NODE_ID",
       subIssueId: "CHILD_NODE_ID"
     }) { subIssue { number } }
   }'
   ```
5. For multiple sub-issues, loop over the child IDs:
   ```bash
   PARENT="<parent_node_id>"
   for CHILD in "<child1_id>" "<child2_id>" "<child3_id>"; do
     gh api graphql -f query="mutation { addSubIssue(input: { issueId: \"$PARENT\", subIssueId: \"$CHILD\" }) { subIssue { number } } }"
   done
   ```

**Do not** duplicate sub-issue lists in markdown body text — the native sub-issue sidebar is the source of truth. Keep the master issue body focused on context, problem description, and approach.

#### Historical context

- `gh search prs --repo {{PRIMARY_REPO}} --state merged <query>`
- `gh search issues --repo {{PRIMARY_REPO}} <query>`
- `gh issue view <number>` / `gh pr view <number>` for linked discussion and rationale

### 5. Use `jq` with `gh` when the raw JSON is noisy

- Prefer `gh ... --json ... --jq '...'` for simple field extraction when the built-in jq filter is enough.
- Use external `jq` when you need heavier reshaping, grouping, sorting, or multi-step filtering across JSON arrays.
- Favor structured extraction over reading raw JSON blobs by eye.
- When triaging CI or large PRs, use `jq` to collapse the output to failing jobs, changed file paths, review states, or commit metadata.

### 6. Useful `gh` + `jq` patterns

- **Summarize PR files**:
  - `gh pr view <number> --json files | jq -r '.files[] | "\(.path) +\(.additions) -\(.deletions)"'`
- **See failing checks only**:
  - `gh pr view <number> --json statusCheckRollup | jq '.statusCheckRollup[] | select(.conclusion != "SUCCESS") | {name: .name, conclusion: .conclusion, detailsUrl: .detailsUrl}'`
- **List commits with authors**:
  - `gh pr view <number> --json commits | jq -r '.commits[] | "\(.oid[0:7]) \(.authors[0].login // .authors[0].name // "unknown") \(.messageHeadline)"'`
- **Pull historical merged PR titles in an area**:
  - `gh search prs --repo {{PRIMARY_REPO}} --state merged <query> --json number,title,mergedAt,url | jq -r '.[] | "#\(.number) \(.mergedAt) \(.title) \(.url)"'`

Prefer `--json` + `--jq` first for simple extraction because it keeps the workflow inside `gh`; reach for external `jq` when the query becomes meaningfully more complex.

### 7. Write structured remote updates

- Draft PR and issue text from the owning scratchpad issue when one exists.
- Create PRs as drafts by default unless the user explicitly asks for a ready-for-review PR.
- Assign agent-created PRs to `@me` by default unless the user explicitly asks for a different assignee or no assignee.
- Keep PR summaries focused on why the branch exists and key user-visible or architectural changes.
- Do not include a "Validation" section listing commands that were run — that is routine verification noise, not useful to reviewers.
- Do not overfit PR messaging to granular branch commits; in squash-merge repos, the PR body and final squashed commit are the durable history.
- Do not include raw changelists that merely echo what GitHub already shows (file names, line counts with no explanation). When a PR touches multiple files, include a brief summary table explaining **what each changed file does and why** — this orients the reviewer before they dive into the diff.
- When updating a PR after conflict resolution or CI debugging, capture the non-obvious delta: what changed, why that resolution was chosen, and whether verification changed.
- Use a HEREDOC for multi-line PR or issue bodies so formatting stays stable.
- **After creating a PR or GitHub issue, record its `gh#N` reference in the owning scratchpad issue** so the link flows both ways.

#### Sanitize shared artifacts

PR descriptions, issue bodies, and comments on GitHub are **shared artifacts visible to the entire team**. Before publishing any text to GitHub:

- **Strip all scratchpad-internal references.** Do not include `scratchpad#N`, `doc#N`, `rfc#N`, scratchpad paths, or scratchpad file names. Use the scratchpad issue for context and structure, but rewrite the content in terms that make sense to someone who has never seen the scratchpad.
- **Link to GitHub objects by number** (`#1234`), not scratchpad issue files.
- **Avoid accidental `#N` auto-links.** GitHub automatically converts `#N` into a link to issue/PR N. Do not write ordinals or list references as `#1`, `#2`, `item #3`, etc. in PR/issue bodies — use plain text ("step 1", "the third item") or ordered Markdown lists instead. Only use `#N` when intentionally linking to a real GitHub issue or PR.

### 8. Verify and report the result

- After creating or editing a remote object, return the resulting URL.
- If checks, reviews, or comments are relevant, summarize the important findings rather than dumping raw output.
- For CI failures, report the failing job, the likely root cause, and the next most useful verification step.
- For historical context requests, report the prior PRs/issues/commits that matter and the rationale they reveal.
- Call out when a local push is still required before a PR can be opened.

## Quality Bar

- Prefer `gh` as the source of truth for GitHub state.
- Understand the full remote object before editing it.
- Optimize PRs for clear squash-merge outcomes rather than preserving every intermediate branch commit in remote history.
- Leave the user with a direct URL or actionable next step.
