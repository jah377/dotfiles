## Context

The dotfiles repo has an existing Python development setup: `pyright` for LSP, `ruff`/`isort` via conform for formatting, and `vim-slime` + `vim-slime-cells` for sending `# %%` cells to an IPython REPL in a tmux pane. The slime approach is text-only — it cannot render images, which is the core limitation.

The target workflow: open a `.qmd` file, run `:MoltenInit` to attach a Jupyter kernel (from a `uv` venv with `ipykernel` registered), execute cells with `<leader>j` keymaps, and see output — including matplotlib figures — rendered inline in the buffer below each cell.

## Goals / Non-Goals

**Goals:**
- Inline cell execution with output (text + images) rendered in the buffer
- `pyright` LSP completions and diagnostics inside `{python}` code blocks
- Format-on-save for both markdown structure (`prettierd`) and embedded Python (`injected` → ruff/isort)
- All operations accessible under `<leader>j` with which-key documentation
- No disruption to existing `.py` workflow or vim-slime setup

**Non-Goals:**
- Quarto document preview / HTML/PDF rendering
- Automatic kernel startup (user runs `:MoltenInit` manually per project)
- `.ipynb` file support
- Debugger (DAP) integration for notebook cells

## Decisions

### 1. molten-nvim over alternatives (jupyter-kernel.nvim, iron.nvim)

`molten-nvim` is the only Neovim plugin with first-class image rendering via `image.nvim`. `jupyter-kernel.nvim` is newer and simpler but lacks image support. `iron.nvim` targets REPLs, not kernels. molten-nvim is the established choice for the quarto-nvim ecosystem.

### 2. image.nvim with kitty backend over ueberzug++

WezTerm supports the Kitty Graphics Protocol natively. `ueberzug++` is Linux-only and requires an additional system dependency. The `kitty` backend in `image.nvim` works out-of-the-box on WezTerm with no additional install.

### 3. quarto-nvim included despite no preview usage

`quarto-nvim` handles `.qmd` treesitter grammar setup and the `otter.nvim` activation pattern for `.qmd` files. Without it, otter.nvim would need manual `BufEnter` autocmd configuration to inject LSP into code blocks. The plugin is lightweight (no preview is triggered unless explicitly called) and reduces configuration surface.

### 4. injected formatter in conform for code block formatting

`conform.nvim`'s built-in `injected` formatter uses treesitter injection queries to extract code block content by language, runs the appropriate formatter (ruff/isort for Python), and writes the result back. This means format-on-save applies `ruff_format`/`ruff_fix`/`isort` to `{python}` blocks and `prettierd` to the markdown structure in a single save. The alternative (LSP format via otter.nvim) would only work for pyright, which does not provide formatting.

### 5. New file lua/config/plugins/molten.lua

All molten, quarto, otter, and image.nvim configuration lives in a single new file. This follows the repo pattern (one file per plugin group/concern) and keeps notebook-specific concerns isolated from the existing Python and LSP configs. Conform and which-key changes are minimal edits to existing files.

### 6. Keymaps as buffer-local in molten.lua ftplugin autocmd

Molten keymaps are registered inside an `autocmd BufEnter *.qmd` block with `buffer = true`, matching the pattern used in `vim-slime.lua`. This prevents `<leader>j` bindings from appearing in non-notebook buffers.

## Risks / Trade-offs

- **luarocks dependency**: molten-nvim requires luarocks for the `magicpython` kernel detection heuristic. If luarocks is absent, `:MoltenInit` falls back to manual kernel selection, which is acceptable but requires `brew install luarocks` for the full experience. → Mitigation: document in plugin file comment.

- **image.nvim + tmux**: If Neovim is run inside a tmux session, image rendering via Kitty protocol may not work (tmux intercepts terminal escape codes). → Mitigation: document that notebook workflow should run Neovim directly in WezTerm, not inside tmux. The existing vim-slime workflow requires tmux anyway, so these are separate workflows.

- **injected formatter edge cases**: The `injected` conform formatter can mishandle indentation at code block boundaries in rare cases (e.g., deeply nested code blocks). Standard `.qmd` files with top-level `{python}` blocks are unaffected. → Mitigation: acceptable trade-off; user can disable injected formatter per-buffer with `vim.b.conform_disable`.

- **otter.nvim virtual buffer drift**: otter.nvim maintains a hidden virtual buffer per injected language. On very large `.qmd` files, LSP responses can lag slightly. → Mitigation: no mitigation needed at typical file sizes; acceptable trade-off.

## Migration Plan

1. Install system dependency: `brew install luarocks`
2. Add plugin file `lua/config/plugins/molten.lua` — lazy.nvim picks it up automatically on next start
3. Edit `conform.lua` to add `quarto` filetype entry
4. Edit `which-key.lua` to register `<leader>j` group
5. Run `:Lazy sync` to install new plugins
6. Per project: activate venv, run `python -m ipykernel install --user --name <project>`
7. Open a `.qmd` file, run `:MoltenInit`, select registered kernel

Rollback: remove `molten.lua`, revert `conform.lua` and `which-key.lua` edits, run `:Lazy sync`.

## Open Questions

- None — all decisions resolved during requirements gathering.
