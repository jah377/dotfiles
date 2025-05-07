#!/usr/bin/env bash

# Install command-line tools using Homebrew
if command -v brew >/dev/null 2>&1; then
	echo "Homebrew is installed"
else
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Make sure we’re using the latest Homebrew
brew update

# Upgrade any already-installed formulae
brew upgrade

# Remove outdated versions
brew cleanup
