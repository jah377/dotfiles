-- ============================================================================
-- FILE: lua/config/core/globals.lua
-- Global variables (vim.g): leader keys, Nerd Font flag, Python host.
--
-- CRITICAL:
--  > This file MUST load before plugins; they read mapleader when they
--    register keymaps.
--
-- DOCUMENTATION:
--  > vim.g (global vars) : https://neovim.io/doc/user/lua/#vim.g
--  > Leader key          : https://neovim.io/doc/user/map/#mapleader
--  > Local leader        : :help localleader
--  > Python provider     : :help provider-python
-- ============================================================================

-- Leader key = Space. <leader>ff means "Space, then f, then f".
vim.g.mapleader = " "

-- Local leader for filetype-specific keymaps (also Space, for consistency).
vim.g.maplocalleader = " "

-- Enables Nerd Font icons in plugins. Requires a Nerd Font in the terminal.
-- Download: https://www.nerdfonts.com/
vim.g.have_nerd_font = true

-- Python provider for remote plugins (molten-nvim). Points at a dedicated venv
-- with pynvim installed. Only set when the interpreter exists: an unset
-- provider makes `:checkhealth provider` report the problem, whereas a path to
-- a missing file produces confusing errors from the remote plugin host.
local python_host = vim.fn.expand("~/.venvs/nvim-python/bin/python")
if vim.uv.fs_stat(python_host) then
    vim.g.python3_host_prog = python_host
else
    -- Deferred so the message is not lost before the UI is attached.
    vim.schedule(function() vim.notify("Python host not found: " .. python_host .. " (molten-nvim will not work)", vim.log.levels.WARN) end)
end
