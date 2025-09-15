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

# Vim-motions in terminal
# See https://github.com/hendrikmi/dotfiles/blob/main/zsh/custom.zsh
bindkey -v
export KEYTIMEOUT=1            # Makes switching modes quicker
export VI_MODE_SET_CURSOR=true # trigger cursor shape changes when switching modes

# Gets called every time the keymap changes (insert <-> normal mode)
function zle-keymap-select {
  if [[ ${KEYMAP} == vicmd ]]; then
    echo -ne '\e[2 q' # block
  else
    echo -ne '\e[6 q' # beam
  fi
}
zle -N zle-keymap-select # register as ZLE widget

# Runs once when a new ZLE session starts (e.g. when a prompt appears)
zle-line-init() {
  zle -K viins # initiate 'vi insert' as keymap (can be removed if 'binkey -V has been set elsewhere')
  echo -ne '\e[6 q'
}
zle -N zle-line-init
echo -ne '\e[6 q' # Use beam shape cursor on startup

# Yank to the system clipboard
function vi-yank-xclip {
  zle vi-yank
  echo "$CUTBUFFER" | pbcopy -i
}

zle -N vi-yank-xclip
bindkey -M vicmd 'y' vi-yank-xclip
