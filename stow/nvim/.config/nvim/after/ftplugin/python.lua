-- Python filetype settings (override options.lua; run after Neovim's
-- ftplugin/python.vim)

local set = vim.opt_local

-- Spell checking for comments and strings
set.spell = true

-- Indentation: Neovim's ftplugin/python.vim already sets expandtab and
-- tabstop/softtabstop/shiftwidth = 4 (PEP 8), so nothing is repeated here.
-- textwidth is not set by that ftplugin; 79 is PEP 8's limit and is pinned so
-- a future change to the global default in options.lua cannot alter it.
set.textwidth = 79

-- Line wrapping: auto-wrap comments and docstrings, never code. `t` and `c`
-- make Vim attempt a wrap; the formatexpr decides whether the current line is
-- prose (wrap) or code (leave alone). wrap_comments tells the FileType autocmd
-- in core/autocmds.lua to leave `c` in place; it strips `c` from every
-- filetype that does not opt in.
vim.b.wrap_comments = true
set.formatoptions:append("tc")
vim.bo.formatexpr = "v:lua.require'config.lib.python_format'.formatexpr()"

-- Auto-capitalize booleans (Python uses True/False)
vim.cmd.inoreabbrev("<buffer> true True")
vim.cmd.inoreabbrev("<buffer> false False")
