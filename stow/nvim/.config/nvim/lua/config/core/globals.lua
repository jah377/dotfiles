-- =============================================================================
-- FILE: lua/config/core/globals.lua
-- Global variables (vim.g). Sets leader key and Nerd Font flag.
--
-- CRITICAL:
--  > This file MUST load before plugins - they read mapleader on init.
--
-- DOCUMENTATION:
--  > vim.g (global vars) : https://neovim.io/doc/user/lua/#vim.g
--  > Leader key  : https://neovim.io/doc/user/map/#mapleader
--  > Local leader : :help localleader
-- =============================================================================

local global = vim.g

-- Leader key = Space. <leader>ff means "Space, then f, then f"
-- MUST be set before plugins load or they'll use default backslash
global.mapleader = " "

-- Local leader for filetype-specific keymaps (also Space for consistency)
global.maplocalleader = " "

-- Enables Nerd Font icons in plugins. Requires Nerd Font in terminal.
-- Download: https://www.nerdfonts.com/
global.have_nerd_font = true
