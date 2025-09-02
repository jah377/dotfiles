#!/usr/bin/env bash
#
# SCRIPT NAME: brew.sh
#
# DESCRIPTION: Install apps/libraries on fresh macOS
#
# NOTE: 
# - Inspired by https://github.com/protiumx/.dotfiles/
# - Call 'brew outdated' to view outdated packages
# - Call 'brew upgrade <formula>' to update package

# ---- General Tools ----

brew install --cask bitwarden        # OS-agnostic password manager
brew install --cask raycast          # smart spotlight replacement
brew install --cask expressvpn       # virtual private network tool
brew install --cask whatsapp keybase # messaging-apps

# ---- User Experience ----

brew install --cask hiddenbar          # hide less-useful menubar items
brew install --cask ukelele            # create custom keyboard input .bundle
brew install --cask karabiner-elements # keyboard remapping utility
brew install --cask nikitabobko/tap/aerospace # i3-like window manager

# ---- Programming Tools ----

brew install git  # version control tool
brew install stow # dotfile symlink-farm manager

brew install --cask visual-studio-code
brew install neovim

brew tap d12frosted/emacs-plus
brew install --cask emacs-app

# ---- Python Tools ----

brew install uv     # packge and project manager
brew install pyenv  # manage multiple python versions
brew install poetry # package/dependency manager

# ---- Terminal ----

brew install --cask alacritty # terminal
brew install --cask kitty     # terminal emulator
brew install lazygit          # terminal-based git client

brew install powerlevel10k           # zsh theme
brew install zsh-autosuggestions     # improved autosuggestions
brew install zsh-syntax-highlighting # improved highlighting
brew install eza                     # improve ls command

brew install --cask font-meslo-lg-nerd-font # font for terminal
