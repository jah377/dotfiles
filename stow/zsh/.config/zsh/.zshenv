# ==============================================================================
# .zshenv - Universal Environment Configuration
# ==============================================================================
#
# See ~/.zshenv bootstrap file
#
# Only use to define essential environment variables. This file is sourced at
# EVERY zsh invocation. Must keep minimal to avoid slowing down shell.
#
# ==============================================================================

# Used by git, man, etc.
export EDITOR=nvim
export VISUAL=nvim

# Ensure consistent Unicode behavior
export LANG=en_US.UTF-8

# Default browser CLI tools use to open links
export BROWSER=safari
