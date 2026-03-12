-- =============================================================================
-- FILE: after/ftplugin/markdown.lua
--
-- PURPOSE:
--   File-type-specific settings for Markdown files. These settings ONLY apply
--   when editing .md files and override the global defaults in options.lua.
--
-- WHAT IS AN FTPLUGIN?
--   "ftplugin" stands for "filetype plugin". Neovim automatically loads
--   files from after/ftplugin/<filetype>.lua when opening files of that type.
--   The "after/" directory means these load AFTER built-in defaults.
--
-- MARKDOWN-SPECIFIC SETTINGS:
--   - Spell checking: Markdown is prose, so catch typos
--   - 2-space indentation: Standard for nested lists
--
-- DOCUMENTATION:
--   > Markdown syntax : https://daringfireball.net/projects/markdown/
--   > :help spell
--   > :help ftplugin
--
-- =============================================================================

-- Create a local alias for buffer-local options.
-- vim.opt_local sets options that only affect the current buffer,
-- unlike vim.opt which sets global defaults.
local set = vim.opt_local

-- Enable spell checking for Markdown files.
--
-- Markdown is typically prose content (documentation, READMEs, notes),
-- so spell checking is valuable for catching typos.
--
-- Spell commands:
--   ]s   : Jump to next misspelled word
--   [s   : Jump to previous misspelled word
--   z=   : Show spelling suggestions for word under cursor
--   zg   : Add word to dictionary (mark as correct)
--   zw   : Remove word from dictionary (mark as wrong)
set.spell = true

-- Use 2 spaces for indentation in Markdown files.
--
-- 2-space indentation is standard in Markdown because:
--   - Nested lists use 2-space increments
--   - Code blocks inside lists require consistent indentation
--   - Keeps documents more compact and readable
set.shiftwidth = 2
