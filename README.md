```
    ____        __  _____ __
   / __ \____  / /_/ __(_) /__  _____
  / / / / __ \/ __/ /_/ / / _ \/ ___/
 / /_/ / /_/ / /_/ __/ / /  __(__  )
/_____/\____/\__/_/ /_/_/\___/____/
```

My dotfiles to setup a dev environment in a **MacOS** machine. Configuration
files are managed using GNU Stow. These dotfiles are inspired by a number of
resources:

- [Webpro/awesome-dotfiles](https://github.com/webpro/awesome-dotfiles?tab=readme-ov-file)
- [Github does dotfiles](https://dotfiles.github.io)

# Before Cloning the Repo

## Install Homebrew

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

Run these commands in your terminal to add Homebrew to your PATH:

```bash
echo >> /Users/<USER>/.zprofile
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> /Users/<USER>/.zprofile
eval "$(/opt/homebrew/bin/brew shellenv)"
```

## Install and Configure Git

```bash
# Install git using HomeBrew
brew install git
```

### Configure Git on Personal Machine

```bash
# Generate a new SSH key for personal GitHub
ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519

# Add key to GitHub (Settings -> SSH and GPG keys -> New SSH Key)
pbcopy < ~/.ssh/id_ed25519.pub

# Configure global git
git config --global user.name {{NAME}}
git config --global user.email {{PERSONAL_EMAIL}}

# Clone repo
git clone git@github:jah377/dotfiles.git ~/dotfiles
```

### Configure Git on Work Machine

Additional steps required to use two GitHub accounts from one machine (see
[blog](https://dineshpandiyan.com/blog/two-github-accounts-one-machine/).

```bash
# Create a new SSH key for both GitHub accounts
ssh-keygen -t ed25519 -C {{WORK_EMAIL}} -f ~/.ssh/id_ed25519
ssh-keygen -t ed25519 -C {{USER_EMAIL}} -f ~/.ssh/id_ed25519_personal

# Add key to Github (Settings → SSH and GPG keys → New SSH key):
pbcopy < ~/.ssh/id_ed25519_work.pub
pbcopy < ~/.ssh/id_ed25519_personal.pub
```

Then create the file `.ssh/config` and paste the following:

```bash
# Personal GitHub account
Host github.com-personal
 HostName github.com
 User git
 AddKeysToAgent yes
 UseKeychain yes
 IdentitiesOnly yes
 IdentityFile ~/.ssh/id_ed25519_personal

# Work GitHub account (no alias so we can use as main)
Host github.com
 HostName github.com
 User git
 AddKeysToAgent yes
 UseKeychain yes
 IdentitiesOnly yes
 IdentityFile ~/.ssh/id_ed25519
```

Then clone this dotfiles repo:

```bash
# Must use alias defined in .ssh/config
git clone git@github.com-personal:jah377/dotfiles.git ~/dotfiles
```

Then set name and email for both users:

```bash
# Set global config
git config --global user.name "{{WORK_NAME}}"
git config --global user.email "{{WORK_EMAIL}}"

# Set local config for dotfiles
git -C ~/dotfiles config --local user.name "{{PERSONAL_NAME}}"
git -C ~/dotfiles config --local user.email "{{PERSONAL_EMAIL}}"
```

Then configure the machine context file with work values (see [Configure Machine Context](#configure-machine-context)):

```bash
# Copy example, then set IS_WORK_MACHINE=true and AI_PROVIDER=cursor
cp ~/.config/zsh/machine.local.zsh.example ~/.config/zsh/machine.local.zsh
vim ~/.config/zsh/machine.local.zsh
```

# Setup Development Environment

## Configure Machine Context

Machine-specific settings live in `~/.config/zsh/machine.local.zsh`, which is
not tracked in git. Copy the example once per machine, then edit before running
other setup scripts:

```bash
cp ~/.config/zsh/machine.local.zsh.example ~/.config/zsh/machine.local.zsh
```

**Personal machine** (default values in the example):
```bash
export IS_WORK_MACHINE=false
export AI_PROVIDER=claude
```

**Work machine**:
```bash
export IS_WORK_MACHINE=true
export AI_PROVIDER=cursor
```

`IS_WORK_MACHINE=true` skips personal apps during `brew.sh` (expressvpn,
whatsapp, keybase, emacs, mactex, skim). `AI_PROVIDER` selects the AI
provider used by Neovim, tmux, and lazygit.

## Run Configuration Scripts

```bash
# Configure macOS settings
bash ~/dotfiles/scripts/osx.sh

# Install kitty-terminfo before installing wezterm (needed for inline images in
# Neovim via image.nvim inside tmux). WezTerm itself is installed in brew.sh.
bash ~/dotfiles/scripts/wezterm.sh
bash ~/dotfiles/scripts/kitty.sh

# Download required packages
bash ~/dotfiles/scripts/brew.sh

# Download tmux dependencies
bash ~/dotfiles/scripts/tmux.sh

# Set up Python venv for Neovim's molten/Jupyter integration
bash ~/dotfiles/scripts/molten.sh

# Clone the upstream repos that populate ai_skills/agents, ai_skills/commands,
# and ai_skills/skills
bash ~/dotfiles/ai_skills/install.sh

# Install cursor-cli and symlink ai_skills/ into ~/.claude and ~/.cursor
bash ~/dotfiles/scripts/ai.sh

# Create symlinks to configuration files
bash ~/dotfiles/scripts/stow.sh

# Clone notes repo
bash ~/dotfiles/scripts/zettelkasten.sh
```

## Add Custom Keyboard Input

By default in MacOS, `option+<key>` returns a symbol. This is annoying as many
apps use `option` for keybindings. This cannot be addressed natively. Instead,
I made a custom keyboard bundle `ABC_wo_opt_symbols.bundle` using `ukelele`.

To use, you must copy the file to `/Library`, select in System Settings >>
Keyboard >> Text Input, and restart the computer

```bash
# to copy custom keyboard layout
cp -R ~/dotfiles/custom_keyboard/ABC_wo_opt_symbols.bundle ~/Library/Keyboard\ Layout
```

# Additional Configurations

## Must Enable Permissions

### Enable Full Disk Access

Apps `wezterm` and `karabiner` require full disk access
permission. To grant access, go to _System Settings >> Privacy & Security >>
Full Disk Access_.

### Enable Accessibility

Apps `borders`, `aerospace`, and `Raycast` need full control of the machine. To
grant access, go to _System Settings > Privacy & Security > Accessibility_.

## Applications

### lazygit

Lazygit is configured with an AI-powered commit message generator. In any
lazygit context, press `G` to call `ai-commit`, which presents a menu of
generated conventional-commit messages to choose from.

`ai-commit` lives in `stow/local/.local/scripts/ai-commit` and is available
in `$PATH` after running `stow.sh`.

### tmux

The script `tmux.sh` clones the tmux package-manager. To install packages,
start a tmux-session, jump to `tmux.conf`, and call `<leader> I` to install
3rd-party packages.
