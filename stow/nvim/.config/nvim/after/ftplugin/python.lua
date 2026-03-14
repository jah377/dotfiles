-- Python filetype settings (overrides options.lua)

local set = vim.opt_local

-- Spell checking for comments and string
set.spell = true

-- PEP 8 compliant
set.shiftwidth = 4 -- spaces for auto-indent
set.tabstop = 4 -- display width of <tab> character
set.softtabstop = 4 -- spaces for <tab>

-- Auto-capitalize booleans (Python uses True/False, not true/false)
vim.cmd.inoreabbrev("<buffer> true True")
vim.cmd.inoreabbrev("<buffer> false False")
