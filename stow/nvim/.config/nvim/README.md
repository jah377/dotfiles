# README: Neovim Configuration

## Dependencies

Installed outside Neovim (Mason installs LSP servers and formatters itself):

- [fzf](https://github.com/junegunn/fzf) : fuzzy-find/filter text, filenames, lists
- [fd-find](https://github.com/sharkdp/fd) : find files/directories
- [ripgrep](https://github.com/BurntSushi/ripgrep) : search text inside files (`:grep`, live grep)
- [nerd-fonts](https://github.com/ryanoasis/nerd-fonts) : icons
- [node](https://nodejs.org) : runtime for prettier/prettierd and pyright (installed by Mason)
- [tmux](https://github.com/tmux/tmux) : vim-tmux-navigator, vim-slime REPL target
- [trash](https://github.com/ali-rantakari/trash) : oil.nvim `delete_to_trash`
- [pngpaste](https://github.com/jcsalterego/pngpaste) : paste clipboard images (img-clip)
- [imagemagick](https://imagemagick.org) : image.nvim previews
- Python venv at `~/.venvs/nvim-python` with `pynvim` : molten-nvim remote plugin host
- Optional: MacTeX + Skim for vimtex

## Directory Structure

lazy.nvim imports `lua/config/plugins/*.lua` and the named dirs `notebook/` and
`notes/`. It does not recurse. Shared helper modules live in `lua/config/lib/`,
outside the spec tree, so nothing there can be mistaken for a plugin spec.

```
~/.config/nvim
├── init.lua                 # Entry: core, then lazy, then lsp
├── lazy-lock.json           # Pinned plugin commits
├── lua/config/
│   ├── lazy.lua             # lazy.nvim bootstrap and imports
│   ├── core/                # globals, options, keymaps, autocmds, highlights
│   ├── lsp/                 # diagnostics and lsp keymaps (not lazy specs)
│   ├── lib/                 # helper modules required by specs and ftplugins
│   └── plugins/
│       ├── *.lua            # plugin specs (mini, oil, mason, which-key, …)
│       ├── notebook/        # molten, quarto/otter
│       └── notes/           # image, img-clip, obsidian, render-markdown, bullets
├── after/ftplugin/          # filetype-local settings (not lazy specs)
└── docs/
```

## Conventions

- Formatting follows the repo-level `.stylua.toml` (4-space indent, LuaRocks
  style guide).
- `vim.keymap.set` is called directly; a local `map` helper appears only where
  it adds behaviour.
- Helper modules name their table after the module (`local quarto_extras =
  {}`), hold no mutable state, and return `nil, err` for expected failures.
- Custom highlight groups are defined once in `core/highlights.lua` and
  re-applied on `ColorScheme`.
- `formatoptions` ownership is documented in `core/options.lua`.

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
