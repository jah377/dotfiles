#!/usr/bin/env bash

# Install command-line tools using Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)

# Recommended in terminal after installing Homebrew
echo >> /Users/jonathanharris/.zprofile
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> /Users/jonathanharris/.zprofile
eval "$(/opt/homebrew/bin/brew shellenv)"

# Make sure we’re using the latest Homebrew
brew update

# Upgrade any already-installed formulae
brew upgrade

# Install macOS applications
brew install --cask proton-mail
brew install --cask proton-drive
brew install --cask keybase
brew install --cask whatsapp

brew tap d12frosted/emacs-plus
brew install emacs-plus@30

# Install macOS binaries
brew install git
brew install stow
brew install cmake   # for vterm
brew install libtool # for vterm
brew install enchant # for jinx

# Remove outdated versions
brew cleanup
