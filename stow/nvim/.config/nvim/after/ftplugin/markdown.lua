-- Markdown filetype settings (override options.lua; run after Neovim's
-- ftplugin/markdown.vim)

local set = vim.opt_local

-- Opt out of format-on-save and the trailing-whitespace trim (conform.lua and
-- mini.lua both honour this flag): prettier rewrites notes, and two trailing
-- spaces are a hard line break in Markdown.
vim.b.disable_autoformat = true
vim.b.overlength_disabled = true -- see core/autocmds.lua

set.spell = true -- off globally in options.lua

require("config.lib.markdown_folds").setup()
