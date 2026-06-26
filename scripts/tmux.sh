#!/usr/bin/env bash
set -euo pipefail

# Must download package manager
git clone https://github.com/tmux-plugins/tpm ~/.config/tmux/plugins/tpm

# Download catppuccin theme
mkdir -p ~/.config/tmux/plugins/catppuccin
git clone -b v2.1.3 https://github.com/catppuccin/tmux.git ~/.config/tmux/plugins/catppuccin/tmux
