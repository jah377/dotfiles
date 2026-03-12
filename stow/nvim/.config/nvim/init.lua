-- =============================================================================
-- FILE: init.lua
-- Entry point for Neovim configuration. Loads modules in order:
-- 1. Core (globals, options, keymaps, autocmds) - sets leader key first
-- 2. Plugin manager (lazy.nvim)
-- 3. LSP configuration
-- =============================================================================

-- MUST load before plugins - sets leader key (see globals.lua)
require("config.core")

require("config.lazy")

require("config.lsp.diagnostics")
require("config.lsp.keymaps")
