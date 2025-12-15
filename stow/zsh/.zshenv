# ==============================================================================
# .zshenv - Zsh Environment Configuration Bootstrap
# ==============================================================================
#
# INTENDED USE:
#
#   This file must exist at ~/.zshenv (in $HOME) and cannot be relocated. It
#   serves as a bootstrap to redirect zsh to load configuration files from a
#   custom location instead of cluttering the home directory.
#
# ACTUAL ZSH CONFIGURATION LOCATION:
#
#   All other zsh configuration files are located in: ~/.config/zsh/
#
# WHY THIS STRUCTURE:
#
#   By default, zsh looks for configuration files directly in $HOME, which can
#   lead to a cluttered home directory. The ZDOTDIR environment variable tells
#   zsh to look for its configuration files in a different directory.
#
#   However, .zshenv itself cannot be relocated - zsh always reads it from
#   $HOME first. This makes it the perfect place to set ZDOTDIR and redirect
#   all other configuration to a cleaner location following XDG Base Directory
#   specifications (~/.config/).
#
# ==============================================================================

export ZDOTDIR="$HOME/.config/zsh"
