-- Markdown filetype settings (overrides options.lua)

local set = vim.opt_local

-- Spell: ]s/[s (next/prev), z= (suggest), zg (add to dict)
set.spell = true

set.shiftwidth = 2 -- Standard for nested lists

-- Treesitter-based folding (fold by heading)
set.foldmethod = "expr"
set.foldexpr = "v:lua.vim.treesitter.foldexpr()"
set.foldlevelstart = 99 -- Start with all folds open
