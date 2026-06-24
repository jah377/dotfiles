# ==============================================================================
# machine.local.zsh - Machine-Specific Configuration
# ==============================================================================
#
# This file is gitignored and must be created on each machine during setup:
#
#   cp machine.local.zsh.template machine.local.zsh
#
# Then edit machine.local.zsh to reflect this machine's context.
# Sourced from .zshenv on every shell invocation.
#
# ==============================================================================

# Whether this is a work machine.
# Valid values: "true" | "false"
export IS_WORK_MACHINE=false

# AI provider to use across tools (neovim, tmux, lazygit).
# Valid values: "claude" | "cursor"
export AI_PROVIDER="claude"
