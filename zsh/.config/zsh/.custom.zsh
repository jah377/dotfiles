# Homebrew
# See https://docs.brew.sh/Manpage#shellenv-shell
eval "$(/opt/homebrew/bin/brew shellenv)"
export HOMEBREW_NO_AUTO_UPDATE=1

# Activate syntax highlighting
source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Starship
export STARSHIP_CONFIG="$HOME/dotfiles/starship/.config/starship/starship.toml"
eval "$(starship init zsh)"

# zoxide - a better cd command
eval "$(zoxide init zsh)"

# fzf - fuzzy-finder
export FZF_DEFAULT_OPTS="--padding=5% --height=40% --layout=reverse"
source <(fzf --zsh)
