#!/usr/bin/env bash

# Must use curl; `brew` falgged dependency as malware
curl https://cursor.com/install -fsS | bash

# Create claude symlinks
mkdir -p ~/.claude
ln -sf ~/dotfiles/ai_skills/skills ~/.claude/skills
ln -sf ~/dotfiles/ai_skills/commands ~/.claude/commands
ln -sf ~/dotfiles/ai_skills/agents ~/.claude/agents

# Create cursor symlinks
mkdir -p ~/.cursor
ln -sf ~/dotfiles/ai_skills/skills ~/.cursor/skills
ln -sf ~/dotfiles/ai_skills/commands ~/.claude/commands
ln -sf ~/dotfiles/ai_skills/agents ~/.claude/agents


