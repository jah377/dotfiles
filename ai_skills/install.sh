#!/usr/bin/env bash
set -euo pipefail

BASE="$(cd "$(dirname "$0")" && pwd)"
REPOS="$BASE/repos"

mkdir -p "$BASE/agents" "$BASE/commands" "$BASE/skills" "$REPOS"
trap 'echo "Deleting repos..." && rm -rf "$REPOS"' EXIT

# ── Clone upstream repos ─────────────────────────────────────────────────────

CLAUDE="$REPOS/claude-plugins"
CURSOR="$REPOS/cursor-plugins"
DAGSTER="$REPOS/dagster-skills"
KARPATHY="$REPOS/karpathy-skills"
MATTPOCOCK="$REPOS/mattpocock-plugins"
ADDYOSMANI="$REPOS/addyosmani-plugins"
ANTHROPIC="$REPOS/anthropic-skills"

clone() {
  echo "Downloading $1..."
  # & backgrounds the clone; $! is its PID; pids collects all PIDs
  git clone --depth 1 --quiet "$1" "$2" & pids+=($!) 
}

pids=()
clone "https://github.com/anthropics/claude-plugins-official.git" "$CLAUDE"
clone "https://github.com/cursor/plugins.git"                     "$CURSOR"
clone "https://github.com/dagster-io/skills.git"                  "$DAGSTER"
clone "https://github.com/multica-ai/andrej-karpathy-skills"      "$KARPATHY"
clone "https://github.com/mattpocock/skills"                      "$MATTPOCOCK"
clone "https://github.com/addyosmani/agent-skills"                "$ADDYOSMANI"
clone "https://github.com/anthropics/skills"                      "$ANTHROPIC"
# wait on each PID so all clones finish before continuing
for pid in "${pids[@]}"; do wait "$pid"; done 


# ── agents ───────────────────────────────────────────────────────────────────

echo "Copying agents..."

PR_REVIEW="$CLAUDE/plugins/pr-review-toolkit"
cp "$PR_REVIEW/agents"/{code-reviewer,code-simplifier,comment-analyzer,pr-test-analyzer,silent-failure-hunter,type-design-analyzer}.md \
   "$BASE/agents/"

THERMOS="$CURSOR/thermos"
cp "$THERMOS/agents"/{thermo-nuclear-review-subagent,thermo-nuclear-code-quality-review-subagent}.md \
   "$BASE/agents/"

# ── commands ─────────────────────────────────────────────────────────────────

echo "Copying commands..."

cp "$PR_REVIEW/commands/review-pr.md" "$BASE/commands/"

# ── skills ───────────────────────────────────────────────────────────────────

echo "Copying skills..."

copy_skill() {
  local src="$1" dest="$2"
  rm -rf "$dest"
  cp -r "$src" "$dest"
}

copy_skill "$MATTPOCOCK/skills/engineering/improve-codebase-architecture" "$BASE/skills/improve-codebase-architecture"
copy_skill "$MATTPOCOCK/skills/engineering/resolving-merge-conflicts"     "$BASE/skills/resolve-merge-conflict"
copy_skill "$MATTPOCOCK/skills/productivity/grilling"                     "$BASE/skills/grilling"
copy_skill "$MATTPOCOCK/skills/productivity/wait-what"                    "$BASE/skills/wait-what"

copy_skill "$KARPATHY/skills/karpathy-guidelines"                         "$BASE/skills/karpathy-guidelines"
copy_skill "$ADDYOSMANI/skills/code-review-and-quality"                   "$BASE/skills/code-review-and-quality"
copy_skill "$CURSOR/cursor-team-kit/skills/make-pr-easy-to-review"        "$BASE/skills/make-pr-easy-to-review"
copy_skill "$ANTHROPIC/skills/skill-creator"                              "$BASE/skills/skill-creator"

copy_skill "$THERMOS/skills/thermo-nuclear-code-quality-review"           "$BASE/skills/thermo-nuclear-code-quality-review"
copy_skill "$THERMOS/skills/thermo-nuclear-review"                        "$BASE/skills/thermo-nuclear-review"
copy_skill "$THERMOS/skills/thermos"                                      "$BASE/skills/thermos"

# dagster-skills uses a double-nested path: skills/<name>/skills/<name>/
copy_skill "$DAGSTER/skills/dagster-expert/skills/dagster-expert"          "$BASE/skills/dagster-expert"
copy_skill "$DAGSTER/skills/dignified-python/skills/dignified-python"      "$BASE/skills/dignified-python"
