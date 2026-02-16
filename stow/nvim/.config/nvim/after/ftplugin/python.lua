local set = vim.opt_local

set.spell = true -- catch typos in comments and docstrings
set.shiftwidth = 4 -- PEP 8: use 4 spaces per indentation level
set.tabstop = 4 -- display tabs as 4 spaces
set.softtabstop = 4 -- backspace removes 4 spaces at once

-- Automatically capitalize boolean values
vim.cmd.inoreabbrev("<buffer> true True")
vim.cmd.inoreabbrev("<buffer> false False")
