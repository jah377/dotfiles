-- =============================================================================
-- FILE: lua/config/core/init.lua
-- Module loader for core configuration.
-- =============================================================================

-- Must set vim.g.mapleader before `config.core.keymaps`
require("config.core.globals")

require("config.core.options")
require("config.core.keymaps")
require("config.core.autocmds")
