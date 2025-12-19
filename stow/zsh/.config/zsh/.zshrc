# ==============================================================================
# .zshrc - Interactive Shell Configuration
# ==============================================================================

# History options
setopt APPEND_HISTORY            # Don't overwrite, append new commands
setopt HIST_IGNORE_DUPS          # Ignore duplicate commands in history
setopt HIST_IGNORE_SPACE         # Ignore commands starting with a space
setopt SHARE_HISTORY             # Share history across all shells
setopt HIST_VERIFY               # Don't automatically run cmd from history
setopt HIST_EXPIRE_DUPS_FIRST    # Drop duplicates when trimming history file

# Automatically source all .zsh files (excluding dot files)
for config_file in "$HOME/.config/zsh"/[^.]*.zsh; do
  source "$config_file"
done
