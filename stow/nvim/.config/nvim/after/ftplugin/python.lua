-- Python filetype settings (overrides options.lua)
-- Spell: ]s/[s (next/prev), z= (suggest), zg (add to dict)
local set = vim.opt_local

set.spell = true
set.shiftwidth = 4   -- PEP 8
set.tabstop = 4
set.softtabstop = 4

-- Auto-capitalize booleans (Python uses True/False, not true/false)
vim.cmd.inoreabbrev("<buffer> true True")
vim.cmd.inoreabbrev("<buffer> false False")
