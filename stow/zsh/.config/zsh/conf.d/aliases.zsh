# -- cli tools ----------------------------------------------------------------
alias lg="lazygit"
alias n="nvim"
alias cd=z # use zoxide instead

# -- eza ----------------------------------------------------------------------
_eza_defaults="--icons --group-directories-first --no-user --git"
alias ls="eza -la $_eza_defaults"
alias lst="eza -laT $_eza_defaults --no-permissions --no-filesize --no-time --git-ignore"
unset _eza_defaults

# -- python -------------------------------------------------------------------
alias src="source .venv/bin/activate" # activate python .venv
alias py="source .venv/bin/activate && ipython"

# -- fzf ----------------------------------------------------------------------
alias ff="fzf --walker=file,hidden" # return file name

# -- tmux sessions ------------------------------------------------------------
alias dev="tmux_dev"
alias dd="dev-dots"
alias dw="dev-work"
alias tas="tmux attach-session"

# -- default browser ----------------------------------------------------------
alias dbc="defaultbrowser chrome"
alias dbs="defaultbrowser safari"
alias dbe="defaultbrowser edgemac"

# -- directories --------------------------------------------------------------
alias ..="cd .."
alias ...="cd ../.."

# -- obsidian -----------------------------------------------------------------
alias oo="cd $ZK_DIR"
or() { nvim "$ZK_INBOX_DIR"/*qmd; }
