---
description: Conduct a five-axis code review scoped to a pull request diff
argument-hint: "[PR number or URL]"
allowed-tools: ["Bash"]
---

Invoke the code-review-and-quality skill.

**Scope:** If "$ARGUMENTS" is provided, run `gh pr diff $ARGUMENTS` to get the diff. Otherwise run `gh pr diff` to get the diff for the current branch's open PR.

Review that diff across all five axes:

1. **Correctness** — Does it match the spec? Edge cases handled? Tests adequate?
2. **Readability** — Clear names? Straightforward logic? Well-organized?
3. **Architecture** — Follows existing patterns? Clean boundaries? Right abstraction level?
4. **Security** — Input validated? Secrets safe? Auth checked?
5. **Performance** — No N+1 queries? No unbounded ops?

Categorize findings as Critical, Important, or Suggestion.
Output a structured review with specific file:line references and fix recommendations.
