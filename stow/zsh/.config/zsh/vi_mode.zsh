# # ==============================================================================
# # Vi-mode experience in the terminal
# # ==============================================================================
#
# bindkey -v                      # Enable vim bindings (default: emacs)
# export KEYTIMEOUT=1             # Reduce time switching between modes
# export VI_MODE_SET_CURSOR=true  # Trigger cursor shape changes when switching modes
#
# # Provides visual feedback by changing the cursor shape based on vi mode:
# #   - Beam cursor (|) in insert mode - indicates you're typing normally
# #   - Block cursor (█) in normal mode - indicates you're in command mode
# #
# BEAM_SHAPE='\e[6 q'     # steady beam cursor
# BLOCK_SHAPE='\e[2 q'    # steady block cursor
#
# # Change cursor shape if in insert or normal mode
# function zle-keymap-select {
#   if [[ ${KEYMAP} == vicmd ]]; then
#     echo -ne $BLOCK_SHAPE # block cursor in normal mode
#   else
#     echo -ne $BEAM_SHAPE # beam cursor in insert mode
#   fi
# }
# zle -N zle-keymap-select
#
# zle-line-init() {
#   zle -K viins
#   echo -ne $BEAM_SHAPE
# }
# zle -N zle-line-init
# echo -ne $BEAM_SHAPE
#
# # ==============================================================================
# # System Clipboard Integration
# # ==============================================================================
# #
# # By default, vi mode's yank (y) command only copies to zsh's internal buffer,
# # not the system clipboard. This function extends the yank command to also copy
# # to the macOS system clipboard using pbcopy.
# #
# # Why this is necessary:
# #   - Without this, you can't paste yanked text into other applications
# #   - Provides seamless integration between terminal and GUI applications
# #   - Makes vi mode more practical for everyday use
# #
# # Usage:
# #   - In normal mode, use 'y' commands as usual (yy, yw, y$, etc.)
# #   - The yanked text is automatically available in the system clipboard
# #   - Paste in other apps with Cmd+V or in terminal with 'p'
# #
#
# function vi-yank-xclip {
#   zle vi-yank                    # Perform the standard vi yank
#   echo "$CUTBUFFER" | pbcopy -i  # Copy to macOS clipboard
# }
#
# zle -N vi-yank-xclip              # Register as ZLE widget
# bindkey -M vicmd 'y' vi-yank-xclip  # Override default 'y' in normal mode
