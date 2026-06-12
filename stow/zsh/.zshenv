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

# See structure of https://github.com/jah377/zettelkasten
export NOTES_DIR="$HOME/zettelkasten"
export NOTES_TO_REVIEW_DIR="$NOTES_DIR/tmp"
export NOTES_TO_FILE_DIR="$NOTES_DIR/keep"
