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

# Install general packages
brew install git
brew install stow
brew install neovim
brew install python@3.12
brew install uv

# Install window manager
brew install --cask nikitabobko/tap/aerospace

# Install terminal
brew install --cask alacritty
brew install --cask font-meslo-lg-nerd-font
brew install powerlevel10k

# Remove outdated versions
brew cleanup
