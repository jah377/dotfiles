```
    ____        __  _____ __
   / __ \____  / /_/ __(_) /__  _____
  / / / / __ \/ __/ /_/ / / _ \/ ___/
 / /_/ / /_/ / /_/ __/ / /  __(__  )
/_____/\____/\__/_/ /_/_/\___/____/
```

My dotfiles to setup a dev environment in a **MacOS** machine. Configuration files are managed using GNU Stow.

# Before Cloning the Repo

## Install Homebrew

```
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
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

# to create symlinks to configuration files
bash ~/dotfiles/scripts/stow.sh
```

## Add Custom Keyboard Input

By default in MacOS, `option+<key>` returns a symbol. This is annoying as many
apps use `option` for keybindings. This cannot be addressed natively. Instead,
I made a custom keboard bundle `ABC_wo_opt_symbols.bundle` using `ukelele`.

To use, you must copy the file to `/Library`, select in System Settings >>
Keyboard >> Text Input, and restart the computer 

```
# to copy custom keyboard layout
cp -R ~/dotfiles/custom_keyboard/ABC_wo_opt_symbols.bundle ~/Library/Keyboard\ Layout
```

k
