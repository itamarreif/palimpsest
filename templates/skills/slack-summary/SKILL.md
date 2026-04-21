---
name: slack-summary
description: Draft concise, conversational Slack-ready summaries that are easy to paste without cleanup.
user-invocable: true
created: TODO
---

# Slack Summary

Write Slack updates that are easy to paste as-is.

## Use This When

- The user wants a Slack message, standup blurb, status update, or handoff note.
- The main job is packaging existing information for communication.

## Slack Formatting

Slack uses its own markup, not Markdown. Key differences:

- Bold: `*text*` not `**text**`
- Code blocks: triple backticks on their own line before and after the code, no language tag. The opening ``` and closing ``` must each be on a separate line.
- Links: paste bare URLs inline — Slack auto-links them. Don't use Markdown `[text](url)` or mrkdwn `<url|text>` syntax.
- Italic: `_text_`

## Style Rules

- Be conversational and concise.
- Be concrete: say what changed, what is open, and what happens next.
- Prefer short paragraphs or simple `- ` bullets.
- Avoid heavy formatting, link spam, and internal scratchpad refs unless requested.
- Make the result ready to paste into Slack without cleanup.
- When referencing PRs, issues, or other GitHub artifacts, include the full URL inline so Slack auto-links it — e.g. `PR #13007 https://github.com/owner/repo/pull/13007`. Don't use Markdown link syntax or Slack mrkdwn syntax, just paste the bare URL next to the reference.
- Default to first person ("I") not "we" — only use "we" if the user explicitly asks for team voice.
- Include concrete examples when describing technical behavior (error output, config snippets, CLI output) — don't just describe what something does, show what it looks like.
- If something is being done in the current PR/work, don't list it under "next steps" — next steps should only be future work.

## Good Patterns

### Short status update

```text
Wrapped up the data-sync extraction and the validation fix. I also cleaned up the scratchpad state so the related issues now match the merged PRs. Next up is the payment handler refactor and the remaining report-tool follow-ups.
```

### Manager-friendly follow-up

```text
Current status: the extraction work is done and the follow-up PR is focused on three things: adding the remaining sweep coverage, fixing the reset bug, and cleaning up the test-only seams we added during development. The sweep-specific tests are green; the remaining CI failures are in unrelated flaky tests.

Open questions:
1. Do we want to land the bug fix and added coverage now, even if the unrelated flakes are still noisy?
2. Should the remaining API cleanup stay in this thread, or move to a separate follow-up once the current PR lands?
3. Do we want to treat the scratchpad issue as tracking only the active PR, or keep it open for the broader refactor work too?

Next steps:
1. Resolve the remaining PR comments and confirm whether we're splitting any scope out
2. Re-run CI and verify the only failures left are the known unrelated flakes
3. Decide whether to merge the current PR as-is or spin the refactor remainder into a separate follow-up
```

### Technical workstream update

Structure: bold section headers with Slack `*bold*`, inline URLs for auto-linking, triple-backtick code blocks on separate lines for error output/examples.

    *Feature X — status update*

    The migration is mostly done and there are now two automated checks preventing regressions:

    *1. First check (merged, live in CI) — PR #123 https://github.com/owner/repo/pull/123*
    Description of what it does and how it works. Any new violation fails CI with:

    ```
    error: use of a disallowed method `some::method`
      --> some-crate/src/service.rs:42:15
       = note: Use the approved API instead. See docs for details.
    ```

    Existing call sites are tracked as tech debt.

    *2. Second check (in review) — PR #456 https://github.com/owner/repo/pull/456*
    Description of what it covers and why the first check can't handle it.

    *Developer docs*
    - `path/to/GUIDE.md` — full guide with before/after examples

    *Next steps*
    - Land #456
    - Chase down remaining violations listed in #789 https://github.com/owner/repo/issues/789
    - Once clean, enable the next phase of the migration

## Quality Bar

- The message should sound natural in Slack.
- It should be specific enough to be useful.
- It should need little or no editing before posting.
