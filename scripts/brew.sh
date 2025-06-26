#!/usr/bin/env bash
#
# Script Name: brew.sh
#
# Description: Install apps/libraries on fresh macOS
#
# Note: Inspired by https://github.com/protiumx/.dotfiles/. Call 'brew
# outdated' to view outdates packages and update via 'brew upgrade <formula>'

# Install Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Must add 'brew' to path before we can use
touch /Users/$USER/.zprofile
echo 'eval $(/opt/homebrew/bin/brew shellenv)' >> $HOME/.zprofile
eval "$(/opt/homebrew/bin/brew shellenv)"

# Make sure we’re using the latest Homebrew
brew update

# Upgrade any already-installed formulae
brew upgrade

# Install macOS applications
brew install --cask proton-mail proton-drive
brew install --cask whatsapp keybase
brew install --cask bitwarden
brew install --cask expressvpn
brew install --cask visual-studio-code
brew install --cask raycast

# Install general packages
brew install git
brew install stow
brew install neovim
brew install python@3.12
brew install uv

# Install window manager
brew install --cask nikitabobko/tap/aerospace

# Install custom menubar
brew tap FelixKratz/formulae
brew install borders
brew install sketchybar
brew install --cask font-hack-nerd-font
brew install font-sf-pro
brew install --cask sf-symbols
brew install jq
chmod +x ~/dotfiles/sketchybar/.config/sketchybar/plugins/*
chmod +x ~/dotfiles/sketchybar/.config/sketchybar/items/*

curl -L https://github.com/kvndrsslr/sketchybar-app-font/releases/download/v1.0.16/sketchybar-app-font.ttf -o $HOME/Library/Fonts/sketchybar-app-font.ttf

# Install terminal
brew install --cask alacritty
brew install --cask font-meslo-lg-nerd-font
brew install powerlevel10k # improve CLI header
brew install zsh-autosuggestions 
brew install zsh-syntax-highlighting

brew install eza # improve `ls`

# Remove outdated versions
brew cleanup
