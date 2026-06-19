## 1. System Dependencies

- [x] 1.1 Install luarocks via Homebrew: `brew install luarocks`

## 2. New Plugin File

- [x] 2.1 Create `stow/nvim/.config/nvim/lua/config/plugins/molten.lua` with `image.nvim` plugin spec (kitty backend, WezTerm-compatible settings)
- [x] 2.2 Add `quarto-nvim` plugin spec to `molten.lua` with otter.nvim dependency, configured for `.qmd` filetype wiring only (no preview)
- [x] 2.3 Add `otter.nvim` plugin spec to `molten.lua` with activation for `{python}` blocks in `.qmd` files
- [x] 2.4 Add `molten-nvim` plugin spec to `molten.lua` with virtualtext output and image.nvim integration enabled
- [x] 2.5 Add buffer-local `<leader>j` keymaps in `molten.lua` via `BufEnter *.qmd` autocmd: `ji` (MoltenInit), `jr` (run cell), `jR` (run all), `jo` (show output), `jd` (delete output)

## 3. Update conform.lua

- [x] 3.1 Add `quarto` filetype entry to `formatters_by_ft` in `conform.lua` with `injected` formatter followed by `prettierd` and `prettier` (stop_after_first for the prettier pair)

## 4. Update which-key.lua

- [x] 4.1 Add `{ "<leader>j", group = "jupyter" }` entry to the `spec` table in `which-key.lua`

## 5. Install and Verify

- [ ] 5.1 Run `:Lazy sync` in Neovim to install all new plugins
- [ ] 5.2 Verify `:checkhealth molten` reports no errors
- [ ] 5.3 Verify `:checkhealth image` reports kitty backend available
- [ ] 5.4 In a test project venv: `pip install ipykernel jupyter_client pynvim` then `python -m ipykernel install --user --name test-kernel`
- [ ] 5.5 Open a `.qmd` file, run `<leader>ji`, confirm kernel selection prompt appears and `test-kernel` is listed
- [ ] 5.6 Execute a cell with `<leader>jr` and confirm text output renders inline
- [ ] 5.7 Execute a matplotlib cell and confirm image renders inline in WezTerm
- [ ] 5.8 Confirm `<leader>j` in which-key shows "jupyter" group with all subcommands
- [ ] 5.9 Confirm `<leader>j` keymaps are absent in a `.py` buffer
- [ ] 5.10 Save a `.qmd` file with unformatted Python in a code block and confirm ruff formats it
