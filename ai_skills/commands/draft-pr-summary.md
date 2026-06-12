---
name: /draft-pr-summary
id: draft-pr-summary
category: Workflow
description: Draft a GitHub pull-request summary from Jira context and git history
---

Draft a pull-request summary that can be copied directly into GitHub.

The output MUST follow `.github/pull_request_template.md` exactly: preserve the
same headings, order, checklist sections, and prompt text.

---

**Input**: The argument after `/draft-pr-summary` is optional. It may include a
Jira ticket, base branch, output path, or freeform context about the pull
request.

Defaults:

- Base branch: infer from git; ask if uncertain.
- Output path: `pull_request_summary.md`.

**Steps**

1. **Read the pull-request template**

   Read `.github/pull_request_template.md` before drafting. Treat it as the
   source of truth for the final markdown structure.

2. **Use the `grill-me` skill to clarify intent**

   Use the `grill-me` skill before drafting. Ask one question at a time unless
   the answer can be found from the repository or git history.

   Gather enough context to complete the template:
   - Jira ticket link or ticket ID.
   - Why the PR exists: bug fix, feature, tech debt, or other motivation.
   - High-level reviewer context and what changed on the branch.
   - Whether the PR includes a breaking change.
   - Unit test evidence.
   - Ruff evidence.
   - Whether the change was deployed and run on DEV.
   - Whether the PR breaks backend integration.
   - Whether documentation was updated.
   - Any review notes, risks, rollout concerns, or known limitations.

   Do not invent missing answers. If context remains unknown after questioning
   and git inspection, leave an explicit placeholder in the draft.

3. **Collect branch evidence with git**

   Run git commands before drafting. Use the current repository state and do
   not modify files during evidence collection.

   Collect:
   - Current branch and status:

     ```bash
     git status --short --branch
     git branch --show-current
     ```

   - Upstream tracking branch, if present. If it has the same branch name as
     the current branch, treat it as the remote copy of the feature branch, not
     as the PR base:

     ```bash
     git rev-parse --abbrev-ref --symbolic-full-name @{upstream}
     ```

   - Candidate base branches when the upstream is unavailable or unsuitable:

     ```bash
     git branch --list main master develop
     git branch --list --remotes origin/main origin/master origin/develop
     ```

   - Exact comparison point for the chosen base:

     ```bash
     git merge-base <base> HEAD
     ```

   - Branch-only commits from the chosen base, including complete commit
     messages:

     ```bash
     git log --decorate --date=short --format='%h %ad %an%n%s%n%b' <base>..HEAD
     git log --reverse --decorate --date=iso --format=fuller <base>..HEAD
     ```

   - Changed files and diff summary:

     ```bash
     git diff --stat <base>...HEAD
     git diff --name-status <base>...HEAD
     ```

   - Relevant committed diffs:

     ```bash
     git diff <base>...HEAD
     ```

   - Per-commit diffs with commit messages and file summaries:

     ```bash
     git log --reverse --patch --stat --find-renames --find-copies <base>..HEAD
     ```

   - Merge commit diffs, when merge commits are present:

     ```bash
     git log --cc --stat --patch <base>..HEAD
     ```

   - Relevant uncommitted changes:
     ```bash
     git status --porcelain=v1 -uall
     git ls-files --others --exclude-standard
     git diff
     git diff --stat
     git diff --name-status
     git diff --staged
     git diff --staged --stat
     git diff --staged --name-status
     ```

   If the base branch is ambiguous, ask the user which base to use before
   drafting. Prefer an explicitly provided base branch over inferred values.

4. **Draft the pull-request body**

   Write the draft to `pull_request_summary.md` unless the user provides
   another output path.

   Output rules:
   - Match `.github/pull_request_template.md` headings and section order.
   - Keep `# Summary` concise and reviewer-oriented.
   - Explain the PR motivation and the high-level changes made on the branch.
   - Check exactly one appropriate change type when supported by evidence.
   - Check `Breaking change?`, backend integration, documentation, and checklist
     boxes only when supported by user answers or command output.
   - Keep unchecked boxes unchecked when evidence is missing.
   - Preserve template guidance text that the reviewer still needs.
   - Use explicit placeholders such as `TODO: add Jira link` for unknown
     required details.

5. **Show completion status**

   After writing the file, summarize:
   - Output path.
   - Base branch used.
   - Key git evidence inspected.
   - Any placeholders that still need user review.

**Guardrails**

- Do not create the GitHub pull request.
- Do not change `.github/pull_request_template.md`.
- Do not modify application code.
- Do not fabricate Jira details, test results, deployment status, or
  documentation links.
- Warn the user that `pull_request_summary.md` is a generated draft to review
  before copying into GitHub or committing.
