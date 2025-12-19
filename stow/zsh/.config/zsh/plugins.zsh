# ==============================================================================
# Plugins
# ==============================================================================

# Vi-mode in terminal
# See https://github.com/jeffreytse/zsh-vi-mode
source /opt/homebrew/opt/zsh-vi-mode/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh

# Syntax-highlighting for commands
# See https://github.com/zsh-users/zsh-syntax-highlighting
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Smarter 'cd' command
# See https://github.com/ajeetdsouza/zoxide
eval "$(zoxide init zsh)"

# Command-line fuzzy finding
# See https://github.com/junegunn/fzf
source <(fzf --zsh)

# Customizable CL prompt formatter
# See https://github.com/starship/starship
eval "$(starship init zsh)"
