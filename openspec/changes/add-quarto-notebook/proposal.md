## Why

The existing vim-slime setup sends code to an IPython REPL which only renders text output — charts, plots, and dataframes are not visible without leaving Neovim. A Jupyter-backed solution renders output (including images) inline in the buffer, enabling a full interactive data science workflow without switching windows.

## What Changes

- Add `molten-nvim` plugin for Jupyter kernel execution with inline output rendering (text and images)
- Add `otter.nvim` plugin to inject virtual LSP buffers inside `{python}` code blocks in `.qmd` files, enabling pyright completions and diagnostics within cells
- Add `image.nvim` plugin as the Kitty Graphics Protocol backend for image rendering (compatible with WezTerm)
- Add `quarto-nvim` plugin for `.qmd` filetype/treesitter wiring and otter.nvim integration
- Update `conform.lua` to add `.qmd` filetype support with `injected` formatter (formats Python blocks via ruff/isort) and `prettierd`/`prettier` for markdown structure
- Update `which-key.lua` to register `<leader>j` as the "jupyter" group
- Add `<leader>j` keymap group in a new `molten.lua` plugin config for all kernel and cell operations

## Capabilities

### New Capabilities

- `quarto-notebook`: Interactive `.qmd` notebook execution in Neovim — Jupyter kernel integration, inline output with image rendering, LSP inside code blocks, and format-on-save for both markdown and embedded Python

### Modified Capabilities

- None

## Impact

- **New files**: `lua/config/plugins/molten.lua`
- **Modified files**: `lua/config/plugins/conform.lua`, `lua/config/plugins/which-key.lua`
- **New dependencies**: `molten-nvim`, `otter.nvim`, `image.nvim`, `quarto-nvim` (all via lazy.nvim)
- **External dependency**: `luarocks` (required by molten-nvim for MagicPython kernel detection) — install via `brew install luarocks`
- **Python dependency**: `jupyter_client`, `pynvim`, `ipykernel` required in each project venv; `ipykernel` must be registered per venv for `:MoltenInit` to find it
- **Terminal**: WezTerm with Kitty Graphics Protocol (already in use)
- **No breaking changes** to existing configuration
