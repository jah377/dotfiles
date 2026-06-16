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
export ZK_DIR="$HOME/zettelkasten" # location of zettelkasten repo
export ZK_INBOX_DIR="$ZK_DIR/inbox" # newly created notes
export ZK_REVIEWED_DIR="$ZK_DIR/reviewed" # notes reviewed, but not refiled
export ZK_STORE_DIR="$ZK_DIR/notes" # final destination of notes
