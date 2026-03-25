# CLI tool shortcuts
alias lg="lazygit"
alias n="nvim"
alias cd=z # use zoxide instead

MY_EZA_DEFAULTS="--icons --group-directories-first --no-user --git"
alias ls="eza -la $MY_EZA_DEFAULTS"
alias lst="eza -laT $MY_EZA_DEFAULTS --no-permissions --no-filesize --no-user --no-time --git-ignore"

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
