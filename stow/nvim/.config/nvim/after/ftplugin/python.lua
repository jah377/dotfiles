-- =============================================================================
-- FILE: after/ftplugin/python.lua
--
-- PURPOSE:
--   File-type-specific settings for Python files. These settings ONLY apply
--   when editing .py files and configure Python-specific behavior.
--
-- WHAT IS AN FTPLUGIN?
--   "ftplugin" stands for "filetype plugin". Neovim automatically loads
--   files from after/ftplugin/<filetype>.lua when opening files of that type.
--   The "after/" directory means these load AFTER built-in defaults.
--
-- PYTHON-SPECIFIC SETTINGS:
--   - Spell checking for comments and docstrings
--   - PEP 8 compliant indentation (4 spaces)
--   - Boolean value auto-capitalization
--
-- DOCUMENTATION:
--   > PEP 8 style guide : https://peps.python.org/pep-0008/
--   > :help spell
--   > :help ftplugin
--
-- =============================================================================

-- Create a local alias for buffer-local options.
-- vim.opt_local sets options that only affect the current buffer.
local set = vim.opt_local

-- Enable spell checking for Python files.
--
-- Spell checking is valuable in Python for:
--   - Comments explaining code logic
--   - Docstrings (function/class documentation)
--   - String literals (error messages, user output)
--   - Variable names (helps catch typos like 'recieve' vs 'receive')
--
-- Spell commands:
--   ]s   : Jump to next misspelled word
--   [s   : Jump to previous misspelled word
--   z=   : Show spelling suggestions for word under cursor
--   zg   : Add word to dictionary (mark as correct)
set.spell = true

-- PEP 8 mandates 4 spaces per indentation level.
-- These settings ensure consistent indentation:
--
-- shiftwidth: Spaces used for auto-indent (>>, <<, and automatic indentation)
set.shiftwidth = 4

-- tabstop: How wide a <Tab> character DISPLAYS (if any exist in the file)
set.tabstop = 4

-- softtabstop: How many spaces are inserted when you press Tab,
-- and how many are removed when you press Backspace on indentation
set.softtabstop = 4

-- Auto-correct lowercase boolean values to Python's capitalized versions.
--
-- In Python, boolean values are capitalized: True and False (not true/false).
-- These abbreviations automatically expand when you type the lowercase versions:
--
--   Type "true"  -> Automatically becomes "True"
--   Type "false" -> Automatically becomes "False"
--
-- This helps developers coming from languages like JavaScript or C where
-- booleans are lowercase.
--
-- inoreabbrev = Insert mode, NO REmap, ABBREViation
-- <buffer> = only active in this buffer (Python files)
vim.cmd.inoreabbrev("<buffer> true True")
vim.cmd.inoreabbrev("<buffer> false False")
