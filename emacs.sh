#!/usr/bin/env bash

# Check if Emacs is available
if ! command -v emacs >/dev/null 2>&1; then
    echo "Error: Emacs not installed, see brew.sh" >&2
    exit 1
fi

# Start Emacs service (suggested when installing Emacs in brew.sh)
brew services start d12frosted/emacs-plus/emacs-plus@30



