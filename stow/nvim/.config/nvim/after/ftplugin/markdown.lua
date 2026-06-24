-- Markdown filetype settings (overrides options.lua)

local set = vim.opt_local

vim.b.disable_autoformat = true
vim.b.overlength_disabled = true

-- Spell: ]s/[s (next/prev), z= (suggest), zg (add to dict)
set.spell = true

set.shiftwidth = 2 -- Standard for nested lists

-- Treesitter-based folding (fold by heading)
set.foldmethod = "expr"
set.foldexpr = "v:lua.vim.treesitter.foldexpr()"
