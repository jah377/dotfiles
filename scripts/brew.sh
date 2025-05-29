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
echo eval "$(/opt/homebrew/bin/brew shellenv)"

# Make sure we’re using the latest Homebrew
brew update

# Upgrade any already-installed formulae
brew upgrade

# Install macOS applications
brew install --cask proton-mail
brew install --cask proton-drive
brew install --cask keybase
brew install --cask whatsapp
brew install --cask bitwarden
brew install --cask freedome
brew install --cask expressvpn
brew install --cask vscode
brew install --cask sketch 
brew install --cask karabiner-elements

# Install general packages
brew install git
brew install stow
brew install neovim
brew install python@3.12
brew install uv

# Tile manager + menu bar
brew install --cask nikitabobko/tap/aerospace
brew tap FelixKratz/formulae
brew install felixkratz/formulae/borders 
brew install sketchybar
brew install --cask font-hack-nerd-font

# Remove outdated versions
brew cleanup
