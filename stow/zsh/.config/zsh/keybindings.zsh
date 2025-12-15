# ==============================================================================
# Keybindings & Vi Mode Configuration
# ==============================================================================

# Enable Vi mode in terminal
# See https://github.com/hendrikmi/dotfiles/blob/main/zsh/custom.zsh
bindkey -v

# History search with arrow keys
bindkey '^[[A' history-search-backward  # up arrow
bindkey '^[[B' history-search-forward   # down arrow

# ==============================================================================
# Vi Mode Cursor Shape
# ==============================================================================

# Gets called every time the keymap changes (insert <-> normal mode)
function zle-keymap-select {
  if [[ ${KEYMAP} == vicmd ]]; then
    echo -ne '\e[2 q' # block cursor in normal mode
  else
    echo -ne '\e[6 q' # beam cursor in insert mode
  fi
}
zle -N zle-keymap-select # register as ZLE widget

# Runs once when a new ZLE session starts (e.g. when a prompt appears)
zle-line-init() {
  # Initiate 'vi insert' as keymap
  # Can be removed if 'binkey -V' has been set elsewhere
  zle -K viins
  echo -ne '\e[6 q'
}
zle -N zle-line-init
echo -ne '\e[6 q' # Use beam shape cursor on startup

# ==============================================================================
# Custom Vi Mode Functions
# ==============================================================================

# Yank to the system clipboard (macOS)
function vi-yank-xclip {
  zle vi-yank
  echo "$CUTBUFFER" | pbcopy -i
}

zle -N vi-yank-xclip
bindkey -M vicmd 'y' vi-yank-xclip
