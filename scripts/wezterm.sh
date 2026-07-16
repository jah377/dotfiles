#!/usr/bin/env bash
set -euo pipefail

# kitty.terminfo defines terminal capabilities for the Kitty terminal emulator.
# Terminfo files tell applications (like neovim) what escape sequences and
# features a terminal supports (colors, cursor movement, images, etc.).
#
# Using Kitty's terminfo in WezTerm provides better image rendering than
# WezTerm's native terminfo - fixes issues with split/persistent images in
# neovim. See https://www.youtube.com/watch?v=8m88Mh12yVw&t=155s.
#
# This is auto-installed via zshrc if missing. To manually install:
tempfile=$(mktemp) && curl -o "$tempfile" https://raw.githubusercontent.com/kovidgoyal/kitty/master/terminfo/kitty.terminfo && tic -x -o ~/.terminfo "$tempfile" && rm "$tempfile"
