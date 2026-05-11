-- Python filetype settings (overrides options.lua)

local set = vim.opt_local

-- Spell checking for comments and string
set.spell = true

-- PEP 8 compliant
set.shiftwidth = 4 -- spaces for auto-indent
set.tabstop = 4 -- display width of <tab> character
set.softtabstop = 4 -- spaces for <tab>
set.textwidth = 79 -- PEP 8 line length

-- Line wrapping: auto-wrap comments and docstrings, but not code.
-- Uses treesitter to detect if cursor is in a comment/string node.
-- `t` must be enabled so auto-format triggers; formatexpr decides what to wrap.
set.formatoptions:append("t")
set.formatoptions:append("c")

vim.bo.formatexpr = "v:lua.require'config.core.python_format'.formatexpr()"

-- Auto-capitalize booleans (Python uses True/False, not true/false)
vim.cmd.inoreabbrev("<buffer> true True")
vim.cmd.inoreabbrev("<buffer> false False")
