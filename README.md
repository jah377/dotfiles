```
    ____        __  _____ __
   / __ \____  / /_/ __(_) /__  _____
  / / / / __ \/ __/ /_/ / / _ \/ ___/
 / /_/ / /_/ / /_/ __/ / /  __(__  )
/_____/\____/\__/_/ /_/_/\___/____/
```

My dotfiles to setup a dev environment in a **MacOS** machine. Configuration files are managed using GNU Stow.

## Scripts

- `scripts/brew.sh`: Download `homebrew`; install applications
- `scripts/osx.sh`: Configure **MacOS** settings
- `scripts/git.sh`: Configure `git` and create key for github
- `scripts/stow.sh`: Create desired symulinks

## Setup

1. Download repository zip from github.com

2. Install `homebrew` and configure **MacOS**

```sh
bash brew.sh
bash osx.sh
```

3. Configure `git` and add SSH key to github

```sh
bash git.sh
```

4. Delete repository zip and clone from github

```sh
rm -rf ~/Downloads/dotfiles-main
git clone git@github.com:jah377/dotfiles.git
```

5. Symulink configuration files

```sh
bash stow.sh
```

## Application-Specific Setup

- `raycast`: 
- `whatsapp`: 
- `keybase`:
- `proton-mail`:
- `proton-drive`:


