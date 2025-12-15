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
#       Environment variables are in env.zsh (sourced by .zshrc)
#
# ==============================================================================

# Add any login-specific initialization here
# Example: starting ssh-agent, setting up GPG, etc.

# Uncomment to prioritize Homebrew python over system python
# PATH="$(brew --prefix)/opt/python@3.12/libexec/bin:$PATH"
