# README: Neovim Configuration

## Dependencies

This configuration requires the following dependencies:

- [fzf](https://github.com/junegunn/fzf) : to fuzzy-find/filter text, filenames, lists
- [fd-find](https://github.com/sharkdp/fd) : to find files/directories
- [ripgrep](https://github.com/BurntSushi/ripgrep) : to search text inside files across directories
- [nerd-fonts](https://github.com/ryanoasis/nerd-fonts) : to "prettify" nvim with icons

## Directory Structure

lazy.nvim imports `lua/config/plugins/*.lua` and the named dirs `notebook/`, `notes/`, and `lsp/`. It does not recurse. `custom/` is require-only and must not be imported.

```
~/.config/nvim
├── init.lua                 # Entry: core, then lazy, then lsp
├── lazy-lock.json           # Pinned plugin commits
├── lua/config/
│   ├── lazy.lua             # lazy.nvim bootstrap and imports
│   ├── core/                # globals, options, keymaps, autocmds
│   ├── lsp/                 # diagnostics and lsp keymaps (not lazy specs)
│   └── plugins/
│       ├── *.lua            # plugin specs (mini, oil, which-key, …)
│       ├── notebook/        # molten, quarto/otter
│       ├── notes/           # image, img-clip, obsidian, render-markdown
│       ├── lsp/             # mason, goto-preview
│       └── custom/          # helpers required by specs; not imported
├── after/ftplugin/          # filetype-local settings (not lazy specs)
└── docs/
```

## Inspiration

**Neovim Configurations**

- [theprimagen](https://github.com/ThePrimeagen/init.lua)
- [tjdevries](https://github.com/tjdevries/config.nvim)
- [omerxx](https://github.com/omerxx/dotfiles/tree/master/nvim)
- [zazencodes](https://github.com/zazencodes/dotfiles/tree/main/nvim)
- [typecraft-dev](https://github.com/typecraft-dev/dotfiles/tree/master/nvim/.config/nvim)
- [josean-dev](https://github.com/josean-dev/dev-environment-files/tree/main/.config/nvim)
- [fokle](https://github.com/folke/dot/tree/master/nvim)
- [xero](https://github.com/xero/dotfiles/tree/main/neovim/.config/nvim)
- [jdhao](https://github.com/jdhao/nvim-config)
- [jakobwesthoff](https://github.com/jakobwesthoff/dotfiles/tree/main/.config/nvim)

**Neovim Distributions**

- [LazyVim](https://github.com/LazyVim/LazyVim)
- [AstroVim](https://github.com/AstroNvim/AstroNvim)
- [LunarVim](https://github.com/LunarVim/Neovim-from-scratch)
