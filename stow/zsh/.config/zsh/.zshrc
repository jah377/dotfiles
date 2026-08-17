# -- history ------------------------------------------------------------------
source "$ZDOTDIR/conf.d/history.zsh"

# -- cli tools ----------------------------------------------------------------
source "$ZDOTDIR/conf.d/eza.zsh"
source "$ZDOTDIR/conf.d/fzf.zsh"
source "$ZDOTDIR/conf.d/starship.zsh"
source "$ZDOTDIR/conf.d/zoxide.zsh"
source "$ZDOTDIR/conf.d/tmux_dev.zsh"

# -- zsh plugins --------------------------------------------------------------
source "$ZDOTDIR/conf.d/zsh_vi.zsh"
source "$ZDOTDIR/conf.d/zsh_autosuggestions.zsh"
source "$ZDOTDIR/conf.d/zsh_highlighting.zsh"

# aliases last: cd=z requires zoxide (z function)
source "$ZDOTDIR/conf.d/aliases.zsh"
