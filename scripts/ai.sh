#!/usr/bin/env bash

if ! command -v cursor >/dev/null 2>&1; then
    echo "Installing Cursor..."

    # Must use curl; `brew` falgged dependency as malware
    curl https://cursor.com/install -fsS | bash
fi

# Create claude symlinks
mkdir -p ~/.claude
ln -sf ~/dotfiles/ai_skills/skills ~/.claude
ln -sf ~/dotfiles/ai_skills/commands ~/.claude
ln -sf ~/dotfiles/ai_skills/agents ~/.claude

# Create cursor symlinks
mkdir -p ~/.cursor
ln -sf ~/dotfiles/ai_skills/skills ~/.cursor
ln -sf ~/dotfiles/ai_skills/commands ~/.cursor
ln -sf ~/dotfiles/ai_skills/agents ~/.cursor


