-- =============================================================================
-- FILE: after/ftplugin/lua.lua
--
-- PURPOSE:
--   File-type-specific settings for Lua files. These settings ONLY apply
--   when editing .lua files and override the global defaults in options.lua.
--
-- WHAT IS AN FTPLUGIN?
--   "ftplugin" stands for "filetype plugin". Neovim automatically loads
--   files from after/ftplugin/<filetype>.lua when opening files of that type.
--   The "after/" directory means these load AFTER built-in defaults, allowing
--   you to override them.
--
-- WHY DIFFERENT SETTINGS FOR LUA?
--   - Lua community standard uses 2-space indentation (not 4)
--   - Neovim config files benefit from consistent styling
--   - Matches stylua formatter defaults
--
-- DOCUMENTATION:
--   > Lua style guide : https://www.lua.org/pil/
--   > :help ftplugin
--
-- =============================================================================

-- Create a local alias for buffer-local options.
-- vim.opt_local sets options that only affect the current buffer,
-- unlike vim.opt which sets global defaults.
local set = vim.opt_local

-- Enable spell checking for Lua files.
--
-- Spell checking is useful for catching typos in:
--   - Comments explaining code
--   - String literals (error messages, user-facing text)
--   - Documentation strings
--
-- Spell commands:
--   ]s   : Jump to next misspelled word
--   [s   : Jump to previous misspelled word
--   z=   : Show spelling suggestions for word under cursor
--   zg   : Add word to dictionary (mark as correct)
set.spell = true

-- Use 2 spaces for indentation in Lua files.
--
-- This overrides the global 4-space default because:
--   - Lua community convention uses 2 spaces
--   - Neovim's built-in Lua uses 2 spaces
--   - stylua formatter defaults to 2 spaces
--   - Keeps nested tables more compact
set.shiftwidth = 2
