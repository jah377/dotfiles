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

# History configuration
export HISTFILE=~/.zsh_history
export HISTSIZE=5000        # lines kept in memory
export SAVEHIST=5000        # lines saved to file
