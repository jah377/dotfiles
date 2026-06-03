#!/usr/bin/env bash

if ! command -v cursor >/dev/null 2>&1; then
    echo "Installing Cursor..."

    # Must use curl; `brew` flagged dependency as malware
    # Cursor installed in ~/.local/bin
    curl https://cursor.com/install -fsS | bash
fi

# Create a symlink, replacing an existing symlink. Errors if dst is a real
# directory (meaning a prior tool created it) to avoid silently nesting
# symlinks inside it.
link_dir() {
    local src="$1" dst="$2"
    if [[ -d "$dst" && ! -L "$dst" ]]; then
        echo "Error: $dst is a real directory; remove it first: rm -rf
        \"$dst\"" >&2
        exit 1
    fi
    ln -sfn "$src" "$dst"
}

# Create claude symlinks
mkdir -p "$HOME/.claude"
link_dir "$DOTFILES_DIR/ai_skills/skills"   "$HOME/.claude/skills"
link_dir "$DOTFILES_DIR/ai_skills/commands" "$HOME/.claude/commands"
link_dir "$DOTFILES_DIR/ai_skills/agents"   "$HOME/.claude/agents"

# Create cursor symlinks
mkdir -p "$HOME/.cursor"
link_dir "$DOTFILES_DIR/ai_skills/skills"   "$HOME/.cursor/skills"
link_dir "$DOTFILES_DIR/ai_skills/commands" "$HOME/.cursor/commands"
link_dir "$DOTFILES_DIR/ai_skills/agents"   "$HOME/.cursor/agents"
