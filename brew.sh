#!/usr/bin/env bash

# Install command-line tools using Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)

echo >> /Users/jonathanharris/.zprofile
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> /Users/jonathanharris/.zprofile
eval "$(/opt/homebrew/bin/brew shellenv)"

# Make sure we’re using the latest Homebrew
brew update

# Upgrade any already-installed formulae
brew upgrade

# Install applications
brew install --cask proton-mail
brew install --cask proton-drive
brew install --cask keybase
brew install --cask whatsapp

# Install emacs-plus (see emacs.sh)
brew tap d12frosted/emacs-plus
brew install emacs-plus@30

# Install other useful binaries
brew install git
brew install stow
brew install cmake   # for vterm
brew install libtool # for vterm

# Remove outdated versions
brew cleanup
