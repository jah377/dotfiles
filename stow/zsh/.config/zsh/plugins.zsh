# ==============================================================================
# Plugin Initialization
# ==============================================================================

# zsh-autosuggestions - suggests commands as you type based on history
source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# zsh-syntax-highlighting - syntax highlighting for commands
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# zoxide - a better cd command (smarter directory jumping)
eval "$(zoxide init zsh)"

# fzf - fuzzy finder for files and command history
source <(fzf --zsh)
