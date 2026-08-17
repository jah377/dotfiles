# ZSH Configuration

## Basic Concepts

Zsh loads startup files in a fixed order depending on shell type:

- `.zshenv` — sourced for every zsh invocation (login, interactive, scripts).
  Contains only essential env vars (`EDITOR`, `HISTFILE`, `ZDOTDIR`, and others).
- `.zprofile` — sourced for login shells only. Sets up `PATH` and Homebrew.
- `.zshrc` — sourced for interactive shells. Sources all `conf.d/` modules.

The `~/.zshenv` bootstrap file (tracked at `stow/zsh/.zshenv`) sets `ZDOTDIR`
to redirect zsh to load all other config from `~/.config/zsh/`.

## File Structure

```
stow/zsh/
├── .zshenv                        # $HOME bootstrap — sets ZDOTDIR
└── .config/zsh/
    ├── .zshenv                    # universal env vars (EDITOR, HISTFILE, etc.)
    ├── .zprofile                  # login shell — Homebrew, PATH
    ├── .zshrc                     # interactive shell — sources conf.d/ modules
    ├── machine.local.zsh          # machine-specific overrides (untracked)
    ├── machine.local.zsh.example  # template for machine.local.zsh
    └── conf.d/
        ├── history.zsh            # keybindings + history setopts
        ├── aliases.zsh            # shell aliases
        ├── eza.zsh                # eza config
        ├── fzf.zsh                # fzf init + theme
        ├── starship.zsh           # starship prompt init
        ├── zoxide.zsh             # zoxide init
        ├── tmux_dev.zsh           # tmux session helpers
        ├── zsh_vi.zsh             # vi-mode keybindings
        ├── zsh_autosuggestions.zsh # autosuggestions plugin
        └── zsh_highlighting.zsh   # syntax highlighting plugin
```

## Configuring

**Adding a new module:**

1. Create `conf.d/<tool>.zsh` with tool-specific config.
2. Add a source line to `.zshrc` in the appropriate section.
3. Add a row to the File Structure tree above.

**Machine-local overrides:**

Copy `machine.local.zsh.example` to `machine.local.zsh` and add
machine-specific env vars. This file is gitignored and sourced from `.zshenv`
(which runs before `.zprofile` and `.zshrc`).

**Deploying to a new machine:**

```bash
# Install required Homebrew packages (see CLAUDE.md for full list)
brew install stow zsh starship fzf zoxide eza lazygit neovim \
  zsh-autosuggestions zsh-syntax-highlighting zsh-vi-mode

# Deploy
cd ~/dotfiles
stow -t ~ stow/zsh

# Reload
exec zsh
```

## Resources

- [Zsh startup files loading order](https://shreevatsa.wordpress.com/2008/03/30/zshbash-startup-files-loading-order-bashrc-zshrc-etc/)
- [What do I put, where?](https://zerotohero.dev/tips/zshell-startup-files/)
- [Introduction to zsh](https://zsh.sourceforge.io/Intro/intro_toc.html)
- [What should and shouldn't go in zsh files](https://unix.stackexchange.com/questions/71253/what-should-shouldnt-go-in-zshenv-zshrc-zlogin-zprofile-zlogout)
- [macOS terminal command-line](https://mac.install.guide/terminal/zshrc-zprofile)
- [Basics of configuring zsh on macOS](https://craftofcoding.wordpress.com/2022/02/28/the-basics-of-configuring-the-z-shell-on-a-mac/)
- [My macOS zsh profile](https://natelandau.com/my-mac-os-zsh-profile/)
- [Zsh history options](https://postgresqlstan.github.io/cli/zsh-history-options/)
- [XDG Base Directory Specification](https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html)
- [GNU Stow Manual](https://www.gnu.org/software/stow/manual/stow.html)
