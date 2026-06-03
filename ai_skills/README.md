# external-skills

This directory contains agents, commands, and skills manually copied from
upstream plugin/skill repositories cloned into `repos/`.

The `repos/` directory holds the upstream sources. Files in `agents/`,
`commands/`, and `skills/` are flat or shallow copies of specific files from
those repos.

---

## Upstream Repositories

| Local path                 | Remote URL                                                |
| -------------------------- | --------------------------------------------------------- |
| `repos/claude-plugins`     | https://github.com/anthropics/claude-plugins-official.git |
| `repos/cursor-plugins`     | https://github.com/cursor/plugins.git                     |
| `repos/dagster-skills`     | https://github.com/dagster-io/skills.git                  |
| `repos/karpathy-skills`    | https://github.com/multica-ai/andrej-karpathy-skills      |
| `repos/mattpocock-plugins` | https://github.com/mattpocock/skills                      |

---

## agents/

Each file is a single-file copy from its upstream source.

| Destination file                                        | Source path (relative to `repos/`)                                             |
| ------------------------------------------------------- | ------------------------------------------------------------------------------ |
| `agents/code-reviewer.md`                               | `claude-plugins/plugins/pr-review-toolkit/agents/code-reviewer.md`             |
| `agents/code-simplifier.md`                             | `claude-plugins/plugins/pr-review-toolkit/agents/code-simplifier.md`           |
| `agents/comment-analyzer.md`                            | `claude-plugins/plugins/pr-review-toolkit/agents/comment-analyzer.md`          |
| `agents/pr-test-analyzer.md`                            | `claude-plugins/plugins/pr-review-toolkit/agents/pr-test-analyzer.md`          |
| `agents/silent-failure-hunter.md`                       | `claude-plugins/plugins/pr-review-toolkit/agents/silent-failure-hunter.md`     |
| `agents/type-design-analyzer.md`                        | `claude-plugins/plugins/pr-review-toolkit/agents/type-design-analyzer.md`      |
| `agents/thermo-nuclear-review-subagent.md`              | `cursor-plugins/thermos/agents/thermo-nuclear-review-subagent.md`              |
| `agents/thermo-nuclear-code-quality-review-subagent.md` | `cursor-plugins/thermos/agents/thermo-nuclear-code-quality-review-subagent.md` |

---

## commands/

| Destination file        | Source path (relative to `repos/`)                               |
| ----------------------- | ---------------------------------------------------------------- |
| `commands/review-pr.md` | `claude-plugins/plugins/pr-review-toolkit/commands/review-pr.md` |

---

## skills/

Each skill is an entire directory tree copied from its upstream source. The
destination directory name maps to the upstream directory name.

> **Note on dagster-skills path structure:** The `dagster-skills` repo nests
> each skill inside `skills/<skill-name>/skills/<skill-name>/`. For example,
> the `dagster-expert` skill lives at
> `repos/dagster-skills/skills/dagster-expert/skills/dagster-expert/`. Only the
> innermost directory (the one containing `SKILL.md`) is copied here.

| Destination directory                        | Source path (relative to `repos/`)                                     |
| -------------------------------------------- | ---------------------------------------------------------------------- |
| `skills/dagster-expert/`                     | `dagster-skills/skills/dagster-expert/skills/dagster-expert/`          |
| `skills/dignified-python/`                   | `dagster-skills/skills/dignified-python/skills/dignified-python/`      |
| `skills/improve-codebase-architecture/`      | `mattpocock-plugins/skills/engineering/improve-codebase-architecture/` |
| `skills/karpathy-guidelines/`                | `karpathy-skills/skills/karpathy-guidelines/`                          |
| `skills/make-pr-easy-to-review/`             | `cursor-plugins/cursor-team-kit/skills/make-pr-easy-to-review/`        |
| `skills/thermo-nuclear-code-quality-review/` | `cursor-plugins/thermos/skills/thermo-nuclear-code-quality-review/`    |
| `skills/thermo-nuclear-review/`              | `cursor-plugins/thermos/skills/thermo-nuclear-review/`                 |
| `skills/thermos/`                            | `cursor-plugins/thermos/skills/thermos/`                               |

---

## Recreating this layout from repos/

The following bash script recreates all files in `agents/`, `commands/`, and
`skills/` from the cloned repos in `repos/`. Run it from this directory
(`external-skills/`).

```bash
#!/usr/bin/env bash
set -euo pipefail

BASE="$(cd "$(dirname "$0")" && pwd)"
REPOS="$BASE/repos"

# ── agents ────────────────────────────────────────────────────────────────────

mkdir -p "$BASE/agents"

# From repos/claude-plugins  (plugin: pr-review-toolkit)
PR_REVIEW_AGENTS="$REPOS/claude-plugins/plugins/pr-review-toolkit/agents"
cp "$PR_REVIEW_AGENTS/code-reviewer.md"        "$BASE/agents/code-reviewer.md"
cp "$PR_REVIEW_AGENTS/code-simplifier.md"      "$BASE/agents/code-simplifier.md"
cp "$PR_REVIEW_AGENTS/comment-analyzer.md"     "$BASE/agents/comment-analyzer.md"
cp "$PR_REVIEW_AGENTS/pr-test-analyzer.md"     "$BASE/agents/pr-test-analyzer.md"
cp "$PR_REVIEW_AGENTS/silent-failure-hunter.md" "$BASE/agents/silent-failure-hunter.md"
cp "$PR_REVIEW_AGENTS/type-design-analyzer.md" "$BASE/agents/type-design-analyzer.md"

# From repos/cursor-plugins  (plugin: thermos)
THERMOS_AGENTS="$REPOS/cursor-plugins/thermos/agents"
cp "$THERMOS_AGENTS/thermo-nuclear-review-subagent.md" \
   "$BASE/agents/thermo-nuclear-review-subagent.md"
cp "$THERMOS_AGENTS/thermo-nuclear-code-quality-review-subagent.md" \
   "$BASE/agents/thermo-nuclear-code-quality-review-subagent.md"

# ── commands ──────────────────────────────────────────────────────────────────

mkdir -p "$BASE/commands"

# From repos/claude-plugins  (plugin: pr-review-toolkit)
cp "$REPOS/claude-plugins/plugins/pr-review-toolkit/commands/review-pr.md" \
   "$BASE/commands/review-pr.md"

# ── skills ────────────────────────────────────────────────────────────────────

mkdir -p "$BASE/skills"

# From repos/dagster-skills  (note: double-nested path  skills/<name>/skills/<name>/)
cp -r "$REPOS/dagster-skills/skills/dagster-expert/skills/dagster-expert/"  "$BASE/skills/dagster-expert"
cp -r "$REPOS/dagster-skills/skills/dignified-python/skills/dignified-python/" "$BASE/skills/dignified-python"

# From repos/mattpocock-plugins
cp -r "$REPOS/mattpocock-plugins/skills/engineering/improve-codebase-architecture/" \
      "$BASE/skills/improve-codebase-architecture"

# From repos/karpathy-skills
cp -r "$REPOS/karpathy-skills/skills/karpathy-guidelines/" "$BASE/skills/karpathy-guidelines"

# From repos/cursor-plugins  (plugin: cursor-team-kit)
cp -r "$REPOS/cursor-plugins/cursor-team-kit/skills/make-pr-easy-to-review/" \
      "$BASE/skills/make-pr-easy-to-review"

# From repos/cursor-plugins  (plugin: thermos)
cp -r "$REPOS/cursor-plugins/thermos/skills/thermo-nuclear-code-quality-review/" \
      "$BASE/skills/thermo-nuclear-code-quality-review"
cp -r "$REPOS/cursor-plugins/thermos/skills/thermo-nuclear-review/" \
      "$BASE/skills/thermo-nuclear-review"
cp -r "$REPOS/cursor-plugins/thermos/skills/thermos/" \
      "$BASE/skills/thermos"
```
