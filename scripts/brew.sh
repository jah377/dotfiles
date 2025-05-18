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

# Install general packages
brew install git
brew install stow

# Install Emacs + tooling
brew tap d12frosted/emacs-plus
brew install emacs-plus@30
brew install cmake    # vterm
brew install libtool  # vterm
brew install enchant  # jinx
brew install autoconf # emacs-jupyter

# Install python + tooling
brew install python@3.12
brew install uv

# Remove outdated versions
brew cleanup
