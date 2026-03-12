-- =============================================================================
-- FILE: lua/config/core/globals.lua
--
-- PURPOSE:
--   This file defines global variables that affect Neovim's behavior across
--   the entire editor. Global variables in Neovim are accessed via `vim.g`.
--
--   The most critical setting here is the "leader key" - a prefix key that
--   creates a namespace for custom keybindings. For example, if leader is
--   <Space>, then pressing <Space>ff might trigger "find files".
--
-- DOCUMENTATION:
--   > vim.g (global vars) : https://neovim.io/doc/user/lua.html#vim.g
--   > Leader key          : https://neovim.io/doc/user/map.html#mapleader
--   > Local leader        : https://neovim.io/doc/user/map.html#maplocalleader
--
-- =============================================================================

-- Create a local alias for vim.g to make the code more readable.
-- `vim.g` is Neovim's table for accessing global variables (like :let g:var).
local global = vim.g

-- Set <Space> as the "leader" key for custom keybindings.
--
-- The leader key acts as a prefix for user-defined shortcuts. When you see
-- a keymap like `<leader>ff`, it means "press Space, then f, then f".
--
-- Why Space? It's the largest key on the keyboard, easy to reach with either
-- thumb, and doesn't conflict with Vim's built-in commands.
--
-- CRITICAL: This MUST be set BEFORE loading any plugins. If a plugin defines
-- keymaps using <leader> before this line runs, those keymaps will use the
-- default leader (backslash \) instead of Space.
global.mapleader = " "

-- Set <Space> as the "local leader" key for filetype-specific keybindings.
--
-- The local leader is like the regular leader, but intended for keymaps that
-- only apply to specific file types. For example, a Python-specific command
-- might use <localleader>r to "run" the current file.
--
-- We set it to Space here for consistency, but some users prefer a different
-- key (like comma or backslash) to separate global and local commands.
global.maplocalleader = " "

-- Enable Nerd Font icons throughout the configuration.
--
-- Nerd Fonts are patched fonts that include thousands of icons (file type
-- icons, git status symbols, etc.). Many plugins check this variable to
-- decide whether to show icons or fall back to ASCII characters.
--
-- PREREQUISITE: You must have a Nerd Font installed AND selected in your
-- terminal emulator for icons to display correctly. Popular choices include:
--   - JetBrainsMono Nerd Font
--   - FiraCode Nerd Font
--   - Hack Nerd Font
--
-- Download from: https://www.nerdfonts.com/
global.have_nerd_font = true
