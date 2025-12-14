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
brew install --cask google-chrome
brew install claude-code

# ---- User Experience ----

brew install --cask hiddenbar          # hide less-useful menubar items
brew install --cask ukelele            # create custom keyboard input .bundle
brew install --cask karabiner-elements # keyboard remapping utility
brew install --cask nikitabobko/tap/aerospace # i3-like window manager

brew tap FelixKratz/formulae
brew install borders # highlight around active window borders

# ---- Programming Tools ----

brew install git  # version control tool
brew install stow # dotfile symlink-farm manager

brew install --cask visual-studio-code

brew install neovim
brew install npm # required for :Mason

brew tap d12frosted/emacs-plus
brew install --cask emacs-app

# ---- Python Tools ----

brew install uv     # package and project manager
brew install pyenv  # manage multiple python versions
brew install poetry # package/dependency manager

# ---- Terminal ----

brew install --cask wezterm   # terminal emulator
brew install starship         # shell prompt
brew install lazygit          # terminal-based git client
brew install tmux             # terminal multiplexer
brew install yq               # required tmux nerd-font

brew install zsh-autosuggestions     # improved auto-suggestions
brew install zsh-syntax-highlighting # improved highlighting
brew install eza    # improve ls command
brew install zoxide # improve cd command
brew install fd     # improved find
brew install fzf    # fuzzy-finding

brew install --cask font-fira-code-nerd-fonts
brew install --cask font-jetbrains-mono-nerd-fonts
