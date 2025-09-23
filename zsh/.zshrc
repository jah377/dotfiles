# zsh options
HISTFILE=~/.zsh_history
HISTSIZE=5000        # lines kept in memory
SAVEHIST=5000        # lines saved to file

setopt APPEND_HISTORY     # don’t overwrite, append new commands
setopt HIST_IGNORE_DUPS   # ignore duplicate commands
setopt HIST_IGNORE_SPACE  # ignore commands starting with a space
setopt SHARE_HISTORY      # share history across all shells
setopt HIST_VERIFY        # don't automatically run cmd from history
setopt HIST_EXPIRE_DUPS_FIRST  # drop duplicates when trimming history file

bindkey '^[[A' history-search-backward  # up arrow
bindkey '^[[B' history-search-forward   # down arrow

# Customizations
for file in "$HOME/.config/zsh"/.*.zsh; do
    [ -f "$file" ] && source "$file"
done

# [ -f "$HOME/.config/zsh/.functions.zsh" ] && source "$HOME/.config/zsh/.functions.zsh"
# [ -f "$HOME/.config/zsh/.custom.zsh" ] && source "$HOME/.config/zsh/.custom.zsh"
# [ -f "$HOME/.config/zsh/.vi_mode.zsh" ] && source "$HOME/.config/zsh/.vi_mode.zsh"
# [ -f "$HOME/.config/zsh/.aliases.zsh" ] && source "$HOME/.config/zsh/.aliases.zsh"
