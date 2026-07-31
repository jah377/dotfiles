-- Markdown filetype settings (overrides options.lua)

local set = vim.opt_local

vim.b.disable_autoformat = true
vim.b.overlength_disabled = true -- See `autocmds.lua`

set.spell = true -- deactivated in `options.lua`
set.shiftwidth = 2 -- Standard for nested lists

require("config.core.markdown_folds").setup()
