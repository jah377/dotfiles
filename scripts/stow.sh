#!/usr/bin/env bash

cd ~/dotfiles
stow aerospace
stow claude
stow cursor
stow editorconfig
stow eza
stow git
stow karabiner
stow lazygit
stow nvim
stow starship
stow tmux
stow wezterm
stow local

# Cannot create symlinks if files already exist
rm -rf ~/.zprofile ~/.zshrc
stow zsh
