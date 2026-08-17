# -- homebrew -----------------------------------------------------------------
# See https://docs.brew.sh/Manpage#shellenv-shell
eval "$(/opt/homebrew/bin/brew shellenv)"
export HOMEBREW_NO_AUTO_UPDATE=1
export PATH="$HOMEBREW_PREFIX/opt/trash/bin:$PATH"

# -- path ---------------------------------------------------------------------
# brew shellenv prepends Homebrew, which would shadow ~/.local/bin (e.g.
# cursor-agent from cursor-cli cask vs the complete install from Cursor). Keep
# user-local first.
export PATH="$HOME/.local/bin:$PATH"

# Location of custom scripts and commands
export PATH="$HOME/.local/scripts:$PATH"

# Uncomment to prioritize Homebrew python over system python
# PATH="$(brew --prefix)/opt/python@3.12/libexec/bin:$PATH"
