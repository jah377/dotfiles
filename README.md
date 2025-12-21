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

```
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

Run these commands in your terminal to add Homebrew to your PATH:

```
echo >> /Users/<USER>/.zprofile
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> /Users/<USER>/.zprofile
eval "$(/opt/homebrew/bin/brew shellenv)"
```

## Install and Configure Git

```
brew install git

# to configure user values logged to each commit
git config --global user.name <user>
git config --global user.email <user_email>

# to generate ssh-key and link to github account
ssh-keygen -t ed25519 -C <user_email>
eval "$(ssh-agent -s)"         # start ssh-agent process, add env vars to shell
ssh-add ~/.ssh/id_ed25519      # load key into ssh-agent
pbcopy < ~/.ssh/id_ed25519.pub # copy key to clipboard; paste into github
```

With the key copied to the clipboard, go to Github >> Account >> Settings >>
SSH & GPG keys >> New SSH Key, and paste. This will allow you to clone the
repository.

# Setup Development Environment

## Clone Repository

```
git clone git@github.com:jah377/dotfiles.git
```

## Run Configuration Scripts

```
# to configure macOS settings
bash ~/dotfiles/scripts/osx.sh

# to download required packages
bash ~/dotfiles/scripts/brew.sh

# to download tmux dependencies
bash ~/dotfiles/scripts/tmux.sh

# to create symlinks to configuration files
bash ~/dotfiles/scripts/stow.sh
```

## Add Custom Keyboard Input

By default in MacOS, `option+<key>` returns a symbol. This is annoying as many
apps use `option` for keybindings. This cannot be addressed natively. Instead,
I made a custom keyboard bundle `ABC_wo_opt_symbols.bundle` using `ukelele`.

To use, you must copy the file to `/Library`, select in System Settings >>
Keyboard >> Text Input, and restart the computer

```
# to copy custom keyboard layout
cp -R ~/dotfiles/custom_keyboard/ABC_wo_opt_symbols.bundle ~/Library/Keyboard\ Layout
```

# Additional Configurations

## Must Enable Permissions

### Enable Full Disk Access

Apps `wezterm`, `alacritty`, and `karabiner` require full disk access
permission. To grant access, go to _System Settings >> Privacy & Security >>
Full Disk Access_.

### Enable Accessibility

Apps `borders`, `aerospace`, and `Raycast` need full control of the machine. To
grant access, go to _System Settings > Privacy & Security > Accessibility_.

## Applications

### tmux

The script `tmux.sh` clones the tmux package-manager. To install packages,
start a tmux-session, jump to `tmux.conf`, and call `<leader> I` to install
3rd-party packages.
