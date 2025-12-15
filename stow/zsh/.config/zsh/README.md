# ZSH Configuration

This directory contains a modular ZSH configuration following best practices.

## File Structure

```
~/.config/zsh/
├── .zshenv          # (Located at ~/.zshenv) Bootstrap file - sets ZDOTDIR
├── .zshrc           # Main interactive shell config - sources all modules
├── .zprofile        # Login shell configuration
├── aliases.zsh      # Command aliases
├── completion.zsh   # Shell completion configuration
├── env.zsh          # Environment variables and PATH
├── functions.zsh    # Custom shell functions
├── keybindings.zsh  # Keybindings and vi-mode setup
├── plugins.zsh      # Plugin initialization (zoxide, fzf, etc.)
└── prompt.zsh       # Prompt configuration (starship)
```

## File Loading Order

1. **`.zshenv`** (at `~/.zshenv`) - Always loaded first, sets ZDOTDIR
2. **`.zprofile`** - Loaded for login shells
3. **`.zshrc`** - Loaded for interactive shells, sources all modules:
   - `env.zsh` - Environment variables
   - `plugins.zsh` - Plugin initialization
   - `prompt.zsh` - Prompt setup
   - `keybindings.zsh` - Keybindings and vi-mode
   - `completion.zsh` - Completion configuration
   - `aliases.zsh` - Command aliases
   - `functions.zsh` - Custom functions

## Why This Structure?

- **Modular**: Each file has a single responsibility
- **Maintainable**: Easy to find and update specific configurations
- **Clean**: Keeps home directory clean by using `~/.config/zsh/`
- **Best practices**: Follows XDG Base Directory specification

## Resources

- [Zsh startup files loading order](https://shreevatsa.wordpress.com/2008/03/30/zshbash-startup-files-loading-order-bashrc-zshrc-etc/)
