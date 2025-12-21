# ==============================================================================
# .zprofile - Login Shell Configuration
# ==============================================================================
#
# This file is sourced for login shells (when you first log in to your system).
# It's typically used for:
#   - Setting up environment variables that should be available to all processes
#   - Starting background services or daemons
#   - One-time initialization tasks
#
# Note: Most interactive configuration is in .zshrc
# ==============================================================================

# Homebrew
# See https://docs.brew.sh/Manpage#shellenv-shell
eval "$(/opt/homebrew/bin/brew shellenv)"
export HOMEBREW_NO_AUTO_UPDATE=1

# Uncomment to prioritize Homebrew python over system python
# PATH="$(brew --prefix)/opt/python@3.12/libexec/bin:$PATH"
