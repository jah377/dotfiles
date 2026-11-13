-- ============================================================================
-- FILE: init.lua
-- Entry point for the Neovim configuration. Load order matters:
--   1. config.core   : leader keys, options, keymaps, autocmds, highlights
--   2. config.lazy   : plugin manager bootstrap and plugin specs
--   3. config.lsp.*  : LSP behaviour that relies on plugins being available
-- ============================================================================

-- Sets vim.g.mapleader, which plugins read when they define their keymaps.
require("config.core")

-- Plugin specs may require plugins lazily; nothing below may run before this.
require("config.lazy")

require("config.lsp.diagnostics")
require("config.lsp.keymaps")
