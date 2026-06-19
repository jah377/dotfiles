-- Quarto (.qmd) filetype settings (overrides options.lua)

local set = vim.opt_local

-- Spell: ]s/[s (next/prev), z= (suggest), zg (add to dict)
set.spell = true

set.shiftwidth = 2 -- Standard for nested lists

-- Treesitter-based folding (fold by heading)
set.foldmethod = "expr"
set.foldexpr = "v:lua.vim.treesitter.foldexpr()"

-- Autoformat on save stays enabled; conform.nvim handles quarto via injected + prettier.
