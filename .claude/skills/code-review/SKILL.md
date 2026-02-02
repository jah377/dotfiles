---
name: code-review
description: Review code changes for bugs, style issues, security concerns, and adherence to project conventions. Use when the user asks for a code review, feedback on changes, or wants a second opinion on their code.
allowed-tools: Read, Grep, Glob, Bash(git diff*), Bash(git log*), Bash(git show*)
context: fork
agent: Explore
---

# Code Review

Review the code changes specified by the user. If no specific files or range are given, review the current uncommitted changes via `git diff` and `git diff --cached`.

Apply the coding practices, security, and performance standards defined in CLAUDE.md. In addition, check for:

- Stow package structure is correct (symlinks will resolve properly)
- Neovim plugin configs follow existing patterns in `stow/nvim/`
- Changes don't break existing tool integrations

## Output Format

Organize findings by severity. For each finding, reference the file and line, explain the issue, and suggest a fix.

- **Bugs / Critical**: Issues that will cause incorrect behavior or security risks
- **Warnings**: Potential problems or code smells
- **Suggestions**: Style or readability improvements (optional, non-blocking)

If the code looks good, say so briefly -- do not invent problems.
