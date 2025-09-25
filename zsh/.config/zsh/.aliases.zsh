# Folders
alias dow="$HOME/Downloads"
alias doc="$HOME/dotfiles"

# CLI tool shortcuts
alias lg="lazygit"
alias n="nvim"

# Commands
alias ls="eza -la --icons" # return list + hidden
alias lst="eza -laT --icons" # return list-tree + hidden
alias cdd="fzf_dirs_and_cd $HOME"
alias cdc="cd ~/dotfiles && nvim"
alias ff="fzf --walker=file,hidden" # return file name

# Directories
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias ......="cd ../../../../.."
