-- Quarto (.qmd) filetype settings (overrides options.lua)

local set = vim.opt_local

-- Mirrors `ftplugin/markdown.lua`; autoformat is intentionally NOT disabled here
-- because conform.nvim handles quarto via injected languages + prettier.
vim.b.overlength_disabled = true -- See `autocmds.lua`
set.spell = true
set.shiftwidth = 2

require("config.filetype.markdown_folds").setup()
