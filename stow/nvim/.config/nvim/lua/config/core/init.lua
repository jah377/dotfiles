-- ============================================================================
-- FILE: lua/config/core/init.lua
-- Module loader for plugin-independent configuration.
-- ============================================================================

-- Sets vim.g.mapleader; must precede any module that defines <leader> keymaps.
require("config.core.globals")

require("config.core.options")
require("config.core.keymaps")
require("config.core.autocmds")
require("config.core.highlights")
