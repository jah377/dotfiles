-- =============================================================================
-- FILE: init.lua
--
-- PURPOSE:
--   This is the entry point for Neovim's configuration. When Neovim starts, it
--   automatically looks for and executes this file. Think of it as the "main"
--   function of your editor configuration.
--
--   This file orchestrates the loading order of all configuration modules:
--   1. Core settings (leader keys, options, keymaps, autocommands)
--   2. Plugin manager (lazy.nvim)
--   3. LSP (Language Server Protocol) configuration
--
-- DOCUMENTATION:
--   > Neovim init.lua    : https://neovim.io/doc/user/lua-guide.html
--   > require() function : https://neovim.io/doc/user/lua.html#require()
--
-- =============================================================================

-- Load core configuration first (globals, options, keymaps, autocommands).
-- IMPORTANT: This MUST happen before loading plugins because it defines the
-- leader key mappings. Plugins that create keybindings using <leader> will
-- fail if the leader key isn't set yet.
-- See: lua/config/core/init.lua
require("config.core")

-- Initialize lazy.nvim plugin manager and load all plugins.
-- lazy.nvim handles downloading, updating, and loading plugins on demand.
-- See: lua/config/lazy.lua
require("config.lazy")

-- Configure how LSP diagnostic messages (errors, warnings, hints) are displayed.
-- This affects the visual appearance of error indicators in the editor.
-- See: lua/config/lsp/diagnostics.lua
require("config.lsp.diagnostics")

-- Set up keybindings that become active when an LSP server attaches to a buffer.
-- These keymaps provide code navigation, refactoring, and documentation features.
-- See: lua/config/lsp/keymaps.lua
require("config.lsp.keymaps")
