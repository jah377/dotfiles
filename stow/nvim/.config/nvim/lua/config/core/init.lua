-- =============================================================================
-- FILE: lua/config/core/init.lua
-- Module loader for core configuration. Order matters:
-- 1. globals (leader key) -> 2. options -> 3. keymaps -> 4. autocmds
-- =============================================================================

-- Sets vim.g.mapleader - MUST run before any plugin keymaps
require("config.core.globals")

require("config.core.options")
require("config.core.keymaps")
require("config.core.autocmds")
