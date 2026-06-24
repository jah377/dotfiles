# ==============================================================================
# machine.local.zsh - Machine-Specific Configuration
# ==============================================================================
#
# Tracked in git with safe defaults. Edit this file to reflect this machine's
# context before or after running setup scripts.
# Sourced from .zshenv on every shell invocation.
#
# ==============================================================================

# Whether this is a work machine. Set to true on work machines to skip personal
# app installation during brew.sh.
# Valid values: "true" | "false"
export IS_WORK_MACHINE=false

# AI provider to use across tools (neovim, tmux, lazygit).
# Valid values: "claude" | "cursor"
export AI_PROVIDER="claude"
