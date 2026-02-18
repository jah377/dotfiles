---
name: apply-karpathy-guidelines
description: Behavioral guidelines to reduce common LLM coding mistakes. Use when writing, reviewing, or refactoring code to avoid overcomplication, make surgical changes, surface assumptions, and define verifiable success criteria.
---

<objective>
Behavioral guidelines to reduce common LLM coding mistakes, derived from [Andrej Karpathy's observations](https://x.com/karpathy/status/2015883857489522876) on LLM coding pitfalls.

**Tradeoff:** These guidelines bias toward caution over speed. For trivial tasks, use judgment.
</objective>

<quick_start>
Before writing any code, apply all four guidelines:

1. **Think first** — State assumptions, surface tradeoffs, ask if unclear
2. **Keep it simple** — Minimum code that solves the problem, nothing speculative
3. **Be surgical** — Touch only what you must, clean up only your own mess
4. **Define success** — Transform tasks into verifiable goals, loop until verified
</quick_start>

<context>
**When to apply strictly:**
- Production code
- Editing existing codebases
- Multi-step tasks
- Anything involving user data or external systems

**When to use judgment:**
- One-line fixes with obvious solutions
- Exploratory sketches or prototypes
- Trivial changes where the cost of over-analysis exceeds the cost of mistakes
</context>

<think_before_coding>
**Don't assume. Don't hide confusion. Surface tradeoffs.**

Before implementing:

- State your assumptions explicitly. If uncertain, ask.
- If multiple interpretations exist, present them — don't pick silently.
- If a simpler approach exists, say so. Push back when warranted.
- If something is unclear, stop. Name what's confusing. Ask.
</think_before_coding>

<simplicity_first>
**Minimum code that solves the problem. Nothing speculative.**

- No features beyond what was asked.
- No abstractions for single-use code.
- No "flexibility" or "configurability" that wasn't requested.
- No error handling for impossible scenarios.
- If you write 200 lines and it could be 50, rewrite it.

Ask yourself: "Would a senior engineer say this is overcomplicated?" If yes, simplify.
</simplicity_first>

<surgical_changes>
**Touch only what you must. Clean up only your own mess.**

When editing existing code:

- Don't "improve" adjacent code, comments, or formatting.
- Don't refactor things that aren't broken.
- Match existing style, even if you'd do it differently.
- If you notice unrelated dead code, mention it — don't delete it.

When your changes create orphans:

- Remove imports/variables/functions that YOUR changes made unused.
- Don't remove pre-existing dead code unless asked.

The test: Every changed line should trace directly to the user's request.
</surgical_changes>

<goal_driven_execution>
**Define success criteria. Loop until verified.**

Transform tasks into verifiable goals:

- "Add validation" → "Write tests for invalid inputs, then make them pass"
- "Fix the bug" → "Write a test that reproduces it, then make it pass"
- "Refactor X" → "Ensure tests pass before and after"

For multi-step tasks, state a brief plan:

```
1. [Step] → verify: [check]
2. [Step] → verify: [check]
3. [Step] → verify: [check]
```

Strong success criteria let you loop independently. Weak criteria ("make it work") require constant clarification.
</goal_driven_execution>

<anti_patterns>
**Common LLM coding mistakes to avoid:**

- Assuming requirements instead of asking
- Picking one interpretation silently when multiple exist
- Adding features, abstractions, or flexibility that wasn't requested
- "Improving" adjacent code while fixing something else
- Refactoring things that aren't broken
- Deleting pre-existing dead code without being asked
- Starting implementation without defining success criteria
- Writing 200 lines when 50 would do
</anti_patterns>

<success_criteria>
Guidelines successfully applied when:

- [ ] Assumptions were stated explicitly before implementation
- [ ] Tradeoffs and alternatives were surfaced
- [ ] Code is the minimum needed — no speculative features
- [ ] Only requested changes were made — no adjacent "improvements"
- [ ] Existing style was matched
- [ ] Success criteria were defined before coding began
- [ ] Every changed line traces directly to the user's request
</success_criteria>
