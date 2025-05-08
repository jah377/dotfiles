#!/usr/bin/env bash
#
# Script Name: brew.sh
#
# Description: Install apps/libraries on fresh macOS
#
# Note: Inspired by https://github.com/protiumx/.dotfiles/. Call 'brew
# outdated' to view outdates packages and update via 'brew upgrade <formula>'

# Install Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)

# Make sure we’re using the latest Homebrew
brew update

# Upgrade any already-installed formulae
brew upgrade


# Install macOS applications
brew install --cask proton-mail
brew install --cask proton-drive
brew install --cask keybase
brew install --cask whatsapp

# Install general packages
brew install git
brew install stow

# Install Emacs + tooling
brew tap d12frosted/emacs-plus
brew install emacs-plus@30
brew install cmake   # for vterm
brew install libtool # for vterm
brew install enchant # for jinx

# Install python + tooling
brew install python@3.12
brew install uv

# Remove outdated versions
brew cleanup
