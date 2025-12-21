# ==============================================================================
# .zshenv - Zsh Environment Configuration Bootstrap
# ==============================================================================
#
# This file MUST exist at ~/.zshenv (in $HOME) and cannot be relocated.
#
# It serves as a bootstrap to redirect zsh to load configuration files stored
# in ~/.config/zsh. This is done to de-clutter the home directory, and follows
# XDG Base-Directory specifications.
#
# ==============================================================================

export XDG_CONFIG_HOME="$HOME/.config"
export ZDOTDIR="$XDG_CONFIG_HOME/zsh"
