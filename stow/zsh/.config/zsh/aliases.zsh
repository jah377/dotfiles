# CLI tool shortcuts
alias lg="lazygit"
alias n="nvim"
alias cd=z # use zoxide instead
alias ls="eza -la --icons" # return list + hidden
alias lst="eza -laT --icons" # return list-tree + hidden

# Nice to have
alias src="source .venv/bin/activate" # activate python .venv
alias py="source .venv/ben/activate && ipython"
alias config="cd ~/dotfiles" # jump into config
alias ff="fzf --walker=file,hidden" # return file name

# Directories
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias ......="cd ../../../../.."
