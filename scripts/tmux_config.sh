#!/usr/bin/env bash

# Start a tmux session in ~/dotfiles named "nvim" with three windows:
# - Window 1: nvim
# - Window 2: claude-code
# - Window 3: lazygit
cd ~/dotfiles

if tmux has-session -t nvim 2>/dev/null; then
  tmux attach-session -t nvim
else
  # Create new session with nvim in first window
  tmux new-session -s nvim -c ~/dotfiles -n nvim -d nvim
  # Create second window named "claude" with claude-code
  tmux new-window -t nvim:2 -c ~/dotfiles -n claude claude
  # Create third window named "git" with lazygit
  tmux new-window -t nvim:3 -c ~/dotfiles -n git lazygit
  # Select the first window (nvim) to start there
  tmux select-window -t nvim:1
  # Attach to the session
  tmux attach-session -t nvim
fi
