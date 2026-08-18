# external-skills

This directory contains agents, commands, and skills manually copied from
upstream plugin/skill repositories cloned into `repos/`.

The `repos/` directory holds the upstream sources and is **not tracked in git**
(gitignored). Clone the upstream repos listed below into `repos/` before
updating files here. Files in `agents/`, `commands/`, and `skills/` are flat or
shallow copies of specific files from those repos.

---

## Upstream Repositories

| Local path                 | Remote URL                                                |
| -------------------------- | --------------------------------------------------------- |
| `repos/claude-plugins`     | https://github.com/anthropics/claude-plugins-official.git |
| `repos/cursor-plugins`     | https://github.com/cursor/plugins.git                     |
| `repos/dagster-skills`     | https://github.com/dagster-io/skills.git                  |
| `repos/karpathy-skills`    | https://github.com/multica-ai/andrej-karpathy-skills      |
| `repos/mattpocock-plugins` | https://github.com/mattpocock/skills                      |
| `repos/addyosmani-plugins` | https://github.com/addyosmani/agent-skills                |
| `repos/anthropic-skills`   | https://github.com/anthropics/skills                      |

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

> [!NOTE] Dagster-skill path structure
> The `dagster-skills` repo nests each skill inside
> `skills/<name>/skills/<name>/`. For example, the `dagster-expert` skill lives
> at `repos/dagster-skills/skills/dagster-expert/skills/dagster-expert/`. Only
> the innermost directory (the one containing `SKILL.md`) is copied here.


| Destination directory                        | Source path (relative to `repos/`)                                               |
| -------------------------------------------- | -------------------------------------------------------------------------------- |
| `skills/codebase-design/`                    | `mattpocock-plugins/skills/engineering/codebase-design/`                         |
| `skills/code-review-and-quality/`            | `addyosmani-plugins/skills/code-review-and-quality/`                             |
| `skills/dagster-expert/`                     | `dagster-skills/skills/dagster-expert/skills/dagster-expert/`                    |
| `skills/dignified-python/`                   | `dagster-skills/skills/dignified-python/skills/dignified-python/`                |
| `skills/domain-modeling/`                    | `mattpocock-plugins/skills/engineering/domain-modeling/`                         |
| `skills/grilling/`                           | `mattpocock-plugins/skills/productivity/grilling/`                               |
| `skills/improve-codebase-architecture/`      | `mattpocock-plugins/skills/engineering/improve-codebase-architecture/`           |
| `skills/karpathy-guidelines/`                | `karpathy-skills/skills/karpathy-guidelines/`                                    |
| `skills/make-pr-easy-to-review/`             | `cursor-plugins/cursor-team-kit/skills/make-pr-easy-to-review/`                  |
| `skills/performance-optimization/`           | `addyosmani-plugins/skills/performance-optimization/`                            |
| `skills/resolve-merge-conflict/`             | `mattpocock-plugins/skills/engineering/resolving-merge-conflicts/`               |
| `skills/security-and-hardening/`             | `addyosmani-plugins/skills/security-and-hardening/`                             |
| `skills/skill-creator/`                      | `anthropic-skills/skills/skill-creator/`                                         |
| `skills/thermo-nuclear-code-quality-review/` | `cursor-plugins/thermos/skills/thermo-nuclear-code-quality-review/`              |
| `skills/thermo-nuclear-review/`              | `cursor-plugins/thermos/skills/thermo-nuclear-review/`                           |
| `skills/thermos/`                            | `cursor-plugins/thermos/skills/thermos/`                                         |
| `skills/wait-what/`                          | `mattpocock-plugins/skills/productivity/wait-what/`                              |

---

## Recreating this layout from repos/

Run `install.sh` from this directory to clone all upstream repos and copy files
into `agents/`, `commands/`, and `skills/`. The script cleans up the `repos/`
clone directory on exit.
