-- =============================================================================
-- FILE: after/ftplugin/text.lua
--
-- PURPOSE:
--   File-type-specific settings for plain text files. These settings ONLY
--   apply when editing .txt files and override the global defaults.
--
-- WHAT IS AN FTPLUGIN?
--   "ftplugin" stands for "filetype plugin". Neovim automatically loads
--   files from after/ftplugin/<filetype>.lua when opening files of that type.
--   The "after/" directory means these load AFTER built-in defaults.
--
-- TEXT-SPECIFIC SETTINGS:
--   - Spell checking: Plain text is usually prose
--   - 4-space indentation: Standard for general text
--
-- DOCUMENTATION:
--   > :help spell
--   > :help ftplugin
--
-- =============================================================================

-- Create a local alias for buffer-local options.
-- vim.opt_local sets options that only affect the current buffer.
local set = vim.opt_local

-- Enable spell checking for plain text files.
--
-- Plain text files are typically prose content like:
--   - Notes and documentation
--   - README files (when not using .md)
--   - TODO lists and task notes
--   - Letters, emails, and other written content
--
-- Spell commands:
--   ]s   : Jump to next misspelled word
--   [s   : Jump to previous misspelled word
--   z=   : Show spelling suggestions for word under cursor
--   zg   : Add word to dictionary (mark as correct)
--   zw   : Remove word from dictionary (mark as wrong)
set.spell = true

-- Use 4 spaces for indentation in text files.
--
-- This matches the global default but is explicitly set here for clarity.
-- Plain text files don't have strong conventions, so we use a reasonable
-- default that provides clear visual indentation.
set.shiftwidth = 4
