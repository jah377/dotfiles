# ZSH Configuration

This dorectory contains a modular ZSH configuration that follows best practices
according to XDG Base-Directory specifications. Specifically, the `.zshrc`
configuration is separated into modules, each with their own responsibility.

## File Structure

```
~/dotfiles/stow/zsh
├── .zshenv          # (Located at ~/.zshenv) Bootstrap file - sets ZDOTDIR
└── .config/zsh/
    ├── .zshenv          # Establish minimum, universal environment
    ├── .zprofile        # Login shell configuration
    ├── .zshrc           # Control interactive shell behavior (load modules)
    └── modules
```

## Resources

- [Zsh startup files loading order](https://shreevatsa.wordpress.com/2008/03/30/zshbash-startup-files-loading-order-bashrc-zshrc-etc/)
- [What do I put, where?](https://zerotohero.dev/tips/zshell-startup-files/)
- [Introduction to zsh](https://zsh.sourceforge.io/Intro/intro_toc.html)
- [What should and shouldn't go in zsh files](https://unix.stackexchange.com/questions/71253/what-should-shouldnt-go-in-zshenv-zshrc-zlogin-zprofile-zlogout)
- [macOS terminal command-line](https://mac.install.guide/terminal/zshrc-zprofile)
- [Basics of configuring zsh on macOS](https://craftofcoding.wordpress.com/2022/02/28/the-basics-of-configuring-the-z-shell-on-a-mac/)
- [My macOS zsh profile](https://natelandau.com/my-mac-os-zsh-profile/)
