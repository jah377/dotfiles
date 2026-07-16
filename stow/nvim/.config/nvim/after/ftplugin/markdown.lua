-- Markdown filetype settings (overrides options.lua)

local set = vim.opt_local

vim.b.disable_autoformat = true
vim.b.overlength_disabled = true -- See `autocmds.lua`

set.spell = true -- deactivated in `options.lua`
set.shiftwidth = 2 -- Standard for nested lists

-- Folding ----------------------------------------------------------------------------------

set.foldmethod = "expr"
set.foldexpr = "v:lua.vim.treesitter.foldexpr()" -- Delegate fold logic to Treesitter

-- Override treesitter fold query to only fold ATX heading sections (#, ##, etc.)
-- nvim-treesitter's default folds.scm also folds code blocks and lists; this replaces it.
vim.treesitter.query.set("markdown", "folds", "((section (atx_heading)) @fold)")
