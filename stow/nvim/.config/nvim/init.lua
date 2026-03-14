-- =============================================================================
-- FILE: init.lua
-- Entry point for Neovim configuration. Loads modules in order:
-- =============================================================================

-- Must set global leader before plugins
require("config.core")

-- Must load plugins before lsp configuration
require("config.lazy")

require("config.lsp.diagnostics")
require("config.lsp.keymaps")
