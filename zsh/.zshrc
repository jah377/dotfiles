# zsh options
HISTFILE=~/.zsh_history
HISTSIZE=5000        # lines kept in memory
SAVEHIST=5000        # lines saved to file

setopt APPEND_HISTORY     # Don’t overwrite, append new commands
setopt HIST_IGNORE_DUPS   # Ignore duplicate commands
setopt HIST_IGNORE_SPACE  # Ignore commands starting with a space
setopt SHARE_HISTORY      # Share history across all shells
setopt HIST_VERIFY        # Don't automatically run cmd from history
setopt HIST_EXPIRE_DUPS_FIRST  # Drop duplicates when trimming history file

bindkey '^[[A' history-search-backward  # Up arrow: search back for matching prefix
bindkey '^[[B' history-search-forward   # Down arrow: search forward for matching prefix

# Customizations
[ -f "$HOME/.config/zsh/.custom.zsh" ] && source "$HOME/.config/zsh/.custom.zsh"
[ -f "$HOME/.config/zsh/.vi_mode.zsh" ] && source "$HOME/.config/zsh/.vi_mode.zsh"
[ -f "$HOME/.config/zsh/.aliases.zsh" ] && source "$HOME/.config/zsh/.aliases.zsh"
