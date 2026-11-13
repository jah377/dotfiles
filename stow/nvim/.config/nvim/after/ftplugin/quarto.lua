-- Quarto (.qmd) filetype settings (override options.lua)

local set = vim.opt_local

-- Mirrors ftplugin/markdown.lua except that autoformat stays ON: conform.nvim
-- formats quarto via injected languages + prettier (plugins/conform.lua).
vim.b.overlength_disabled = true -- see core/autocmds.lua
set.spell = true

require("config.lib.markdown_folds").setup()
