# Folders
alias dow="$HOME/Downloads"
alias doc="$HOME/dotfiles"

# CLI tool shortcuts
alias lg="lazygit"
alias n="nvim"
alias cd=z # use zoxide instead
alias ls="eza -la --icons" # return list + hidden
alias lst="eza -laT --icons" # return list-tree + hidden

# Nicities
alias src="source .venv/bin/activate" # activate python .venv
alias py="source .venv/ben/activate && ipython"
alias cdd="fzf_dirs_and_cd $HOME" # fzf and jump into directory
alias tc="tmux new-session -n config"
alias nc="cd ~/dotfiles && nvim" # jump into config
alias ff="fzf --walker=file,hidden" # return file name

# Directories
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias ......="cd ../../../../.."
