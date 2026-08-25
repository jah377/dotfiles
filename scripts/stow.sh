#!/usr/bin/env bash
set -euo pipefail

cd ~/dotfiles
stow aerospace
stow claude
stow cursor
stow editorconfig
stow eza
stow git
stow karabiner
stow kitty
stow lazygit
stow nvim
stow starship
stow tmux
stow wezterm
stow local

# Backup existing ~/.z* files and remove to create symlinks
backup_dir="$HOME/zsh_backups"
mkdir -p "$backup_dir"
shopt -s nullglob # skip loop if no matches

for path in "$HOME"/.z*; do
  base="$(basename "$path")"
  cp -a "$path" "$backup_dir/${base}_backup"
  rm -rf "$path"
done
stow zsh
