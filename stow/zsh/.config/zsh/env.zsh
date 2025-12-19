# ==============================================================================
# Environment Variables & PATH Configuration
# ==============================================================================


# History
export HISTFILE=~/.zsh_history
export HISTSIZE=5000        # lines kept in memory
export SAVEHIST=5000        # lines saved to file


# fzf configuration
# See: https://github.com/catppuccin/fzf
FZF_THEME=" \
--color=bg+:#313244,bg:#1E1E2E,spinner:#F5E0DC,hl:#F38BA8 \
--color=fg:#CDD6F4,header:#F38BA8,info:#CBA6F7,pointer:#F5E0DC \
--color=marker:#B4BEFE,fg+:#CDD6F4,prompt:#CBA6F7,hl+:#F38BA8 \
--color=selected-bg:#45475A \
--color=border:#6C7086,label:#CDD6F4"

export FZF_DEFAULT_OPTS="--padding=5% --height=40% --layout=reverse $FZF_THEME"

# Starship prompt configuration
export STARSHIP_CONFIG="$HOME/.config/starship/starship.toml"

# Uncomment to prioritize Homebrew python over system python
# PATH="$(brew --prefix)/opt/python@3.12/libexec/bin:$PATH"
