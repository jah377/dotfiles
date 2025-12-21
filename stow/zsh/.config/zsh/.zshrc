# ==============================================================================
# .zshrc - Interactive Shell Configuration
# ==============================================================================

# Bind arrow keys to search through command history.
bindkey '^[[A' history-search-backward  # up arrow
bindkey '^[[B' history-search-forward   # down arrow

# History options
# See https://postgresqlstan.github.io/cli/zsh-history-options/
setopt EXTENDED_HISTORY         # include timestamp
setopt HIST_BEEP                # beep if attempting to access a history entry which isn’t there
setopt HIST_EXPIRE_DUPS_FIRST   # trim dupes first if history is full
setopt HIST_FIND_NO_DUPS        # do not display previously found command
setopt HIST_IGNORE_DUPS         # do not save duplicate of prior command
setopt HIST_IGNORE_SPACE        # do not save if line starts with space
setopt HIST_NO_STORE            # do not save history commands
setopt HIST_REDUCE_BLANKS       # strip superfluous blanks
setopt INC_APPEND_HISTORY       # don’t wait for shell to exit to save history lines


# Initialize cli packages
source "$ZDOTDIR/eza.zsh"
source "$ZDOTDIR/fzf.zsh"
source "$ZDOTDIR/starship.zsh"
source "$ZDOTDIR/zoxide.zsh"

# Initalize zsh packages
source "$ZDOTDIR/zsh_vi.zsh"
source "$ZDOTDIR/zsh_completion.zsh"
source "$ZDOTDIR/zsh_highlighting.zsh"

# MUST source aliases after packages initialized
source "$ZDOTDIR/aliases.zsh"
