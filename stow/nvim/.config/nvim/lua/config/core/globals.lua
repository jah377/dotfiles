-- ============================================================================
-- TITLE : Global nvim variables
--
-- ABOUT : File used to define global variables used throughout config
--
-- ============================================================================

local global = vim.g

-- Set <space> as leader key
-- NOTE: Must happen before loading plugins.
global.mapleader = " "
global.maplocalleader = " "

-- Use `nerd font` if installed and selected in terminal
global.have_nerd_font = true
