# Must run 'brew shellenv' to dynamically configure Homebrew env vars
# See https://docs.brew.sh/Manpage#shellenv-shell-
eval "$(/opt/homebrew/bin/brew shellenv)"

# Must update $PATH so Homebrew python is prioritized over default
PATH="$(brew --prefix)/opt/python@3.12/libexec/bin:$PATH"
