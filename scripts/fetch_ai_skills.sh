#!/usr/bin/env bash
# Clones external Claude skill/agent repos and symlinks
# them into ~/.claude/{agents,skills,commands}.
set -euo pipefail

SKILLS_CLONE_DIR="$HOME/.claude/external-skills"
CLAUDE_DIR="$HOME/.claude"
CURSOR_DIR="$HOME/.cursor"

# ── Setup ────────────────────────────────────

rm -rf "$SKILLS_CLONE_DIR"
mkdir -p "$SKILLS_CLONE_DIR" \
    "$CLAUDE_DIR/agents" \
    "$CLAUDE_DIR/skills" \
    "$CLAUDE_DIR/commands" \
    "$CURSOR_DIR/agents" \
    "$CURSOR_DIR/skills" \
    "$CURSOR_DIR/commands"
cd "$SKILLS_CLONE_DIR"

# Symlink a file from a cloned repo into ~/.claude/<type>/
symlink_into() {
    local type="$1"   # agents | skills | commands
    local src_dir="$2"
    local name="$3" # could be .md or sub-directory
    ln -sf \
        "$SKILLS_CLONE_DIR/${src_dir}/${name}" \
        "$CLAUDE_DIR/${type}/${name}"
    ln -sf \
        "$SKILLS_CLONE_DIR/${src_dir}/${name}" \
        "$CURSOR_DIR/${type}/${name}"
}

# ── Cursor Plugins ───────────────────────────

PLUGIN_NAME="cursor-plugins"
git clone \
    https://github.com/cursor/plugins.git \
    "$PLUGIN_NAME"

symlink_into agents \
    "$PLUGIN_NAME/thermos/agents" \
    "thermo-nuclear-code-quality-review-subagent.md"

for skill in \
    thermo-nuclear-code-quality-review \
    thermo-nuclear-review \
    thermos; do
    symlink_into skills \
        "$PLUGIN_NAME/thermos/skills" "$skill"
done

symlink_into skills \
    "$PLUGIN_NAME/cursor-team-kit/skills" \
    "make-pr-easy-to-review"

# ── Anthropic Official Plugins ───────────────

PLUGIN_NAME="claude-plugins"
git clone \
    https://github.com/anthropics/claude-plugins-official.git \
    "$PLUGIN_NAME"

symlink_into agents \
    "$PLUGIN_NAME/plugins/code-simplifier/agents" \
    "code-simplifier.md"

pr_review_agents=(
    code-reviewer
    comment-analyzer
    pr-test-analyzer
    silent-failure-hunter
    type-design-analyzer
)
for agent in "${pr_review_agents[@]}"; do
    symlink_into agents \
        "$PLUGIN_NAME/plugins/pr-review-toolkit/agents" \
        "${agent}.md"
done

symlink_into commands \
    "$PLUGIN_NAME/plugins/pr-review-toolkit/commands" \
    "review-pr.md"

# ── Matt Pocock Skills ───────────────────────

PLUGIN_NAME="mattpocock-skills"
git clone \
    https://github.com/mattpocock/skills \
    "$PLUGIN_NAME"

for skill in grill-me create-a-skill; do
    symlink_into skills \
        "$PLUGIN_NAME/skills/productivity" "$skill"
done

for skill in improve-codebase-architecture zoom-out; do
    symlink_into skills \
        "$PLUGIN_NAME/skills/engineering" "$skill"
done

# ── Karpathy Skills ──────────────────────────

PLUGIN_NAME="karpathy-skills"
git clone \
    https://github.com/multica-ai/andrej-karpathy-skills \
    "$PLUGIN_NAME"

symlink_into skills \
    "$PLUGIN_NAME/skills" "karpathy-guidelines"

# ── Dagster Skills ───────────────────────────

PLUGIN_NAME="dagster-skills"
git clone \
    https://github.com/dagster-io/skills.git \
    "$PLUGIN_NAME"

symlink_into skills \
    "$PLUGIN_NAME/skills/dignified-python/skills" \
    "dignified-python"

symlink_into skills \
    "$PLUGIN_NAME/skills/dagster-expert/skills" \
    "dagster-expert"
