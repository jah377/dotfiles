# CLI tool shortcuts
alias lg="lazygit"
alias n="nvim"
alias cd=z # use zoxide instead

_eza_defaults="--icons --group-directories-first --no-user --git"
alias ls="eza -la $_eza_defaults"
alias lst="eza -laT $_eza_defaults --no-permissions --no-filesize --no-time --git-ignore"
unset _eza_defaults

alias src="source .venv/bin/activate" # activate python .venv
alias py="source .venv/bin/activate && ipython"
alias ff="fzf --walker=file,hidden" # return file name

# Quickly spin up tmux sessions
alias dev="tmux_dev"
alias dd="dev-dots"
alias dw="dev-work"

# Directories
alias ..="cd .."
alias ...="cd ../.."

# Obsidian-related shortcuts
alias oo="cd $ZK_DIR"
or() { nvim "$ZK_INBOX_DIR"/*qmd; }
