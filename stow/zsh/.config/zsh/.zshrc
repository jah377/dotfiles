# ==============================================================================
# .zshrc - Interactive Shell Configuration
# ==============================================================================
#
# This file is sourced for interactive shells. It sets up shell options,
# history behavior, and sources modular configuration files.
#
# Configuration is split into modular files for better organization:
#   - env.zsh         : Environment variables and PATH configuration
#   - plugins.zsh     : Plugin initialization (zoxide, fzf, etc.)
#   - prompt.zsh      : Prompt configuration (starship)
#   - keybindings.zsh : Keybindings and vi-mode setup
#   - completion.zsh  : Shell completion configuration
#   - aliases.zsh     : Command aliases
#   - functions.zsh   : Custom shell functions
#
# ==============================================================================

# ==============================================================================
# History Options
# ==============================================================================

setopt APPEND_HISTORY            # Don't overwrite, append new commands
setopt HIST_IGNORE_DUPS          # Ignore duplicate commands in history
setopt HIST_IGNORE_SPACE         # Ignore commands starting with a space
setopt SHARE_HISTORY             # Share history across all shells
setopt HIST_VERIFY               # Don't automatically run cmd from history
setopt HIST_EXPIRE_DUPS_FIRST    # Drop duplicates when trimming history file

# ==============================================================================
# Load Modular Configuration Files
# ==============================================================================
# Order matters: env -> plugins -> prompt -> keybindings -> completion -> aliases -> functions

source "$HOME/.config/zsh/env.zsh"
source "$HOME/.config/zsh/plugins.zsh"
source "$HOME/.config/zsh/prompt.zsh"
source "$HOME/.config/zsh/keybindings.zsh"
source "$HOME/.config/zsh/completion.zsh"
source "$HOME/.config/zsh/aliases.zsh"
source "$HOME/.config/zsh/functions.zsh"
