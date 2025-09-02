# README: Neovim Configuration
## Example Configurations

- [theprimagen](https://github.com/ThePrimeagen/init.lua)
- [tjdevries](https://github.com/tjdevries/config.nvim)
- [omerxx](https://github.com/omerxx/dotfiles/tree/master/nvim)
- [zazencodes](https://github.com/zazencodes/dotfiles/tree/main/nvim)
- [typecraft-dev](https://github.com/typecraft-dev/dotfiles/tree/master/nvim/.config/nvim)
- [josean-dev](https://github.com/josean-dev/dev-environment-files/tree/main/.config/nvim)
- [fokle](https://github.com/folke/dot/tree/master/nvim)
- [xero](https://github.com/xero/dotfiles/tree/main/neovim/.config/nvim)
- [jdhao](https://github.com/jdhao/nvim-config)

Neovim distributions
- [LazyVim](https://github.com/LazyVim/LazyVim)
- [AstroVim](https://github.com/AstroNvim/AstroNvim)
- [LunarVim](https://github.com/LunarVim/Neovim-from-scratch)

## Directory Structure

~/.config/nvim
├── init.lua              # Entry point (loads lazy.nvim and your config)
├── lazy-lock.json        # Auto-generated lockfile for plugin versions
├── lua/
│   └── config/           # Your custom non-plugin configuration
│       ├── autocmds.lua  # Autocommands
│       ├── keymaps.lua   # Key mappings
│       ├── lazy.lua      # lazy.nvim setup
│       └── options.lua   # General Neovim options
│
├── lua/plugins/          # Plugin specifications (loaded by lazy.nvim)
│   ├── colorscheme.lua   # Example: your colorscheme
│   ├── coding.lua        # LSP, completion, linting, snippets
│   ├── editing.lua       # Editing enhancements (comment, surround, etc.)
│   ├── git.lua           # Git-related plugins
│   ├── ui.lua            # UI/UX (statusline, bufferline, telescope, etc.)
│   └── ...               # More modular plugin files
│
├── after/
│   └── ftplugin/         # Plugin specifications (loaded by lazy.nvim
│
└── docs/                 # Organize documentation related to config 
