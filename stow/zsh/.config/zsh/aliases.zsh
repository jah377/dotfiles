# CLI tool shortcuts
alias lg="lazygit"
alias n="nvim"
alias cd=z # use zoxide instead
alias ls="eza -la --icons --group-directories-first"
alias lst="eza -laT --icons --group-directories-first --no-permissions --no-filesize --no-user --no-time --git-ignore"

# Nice to have
alias src="source .venv/bin/activate" # activate python .venv
alias py="source .venv/bin/activate && ipython"
alias config="cd ~/dotfiles" # jump into config
alias ff="fzf --walker=file,hidden" # return file name

# Directories
alias ..="cd .."
alias ...="cd ../.."
