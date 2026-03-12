-- =============================================================================
-- FILE: lua/config/core/init.lua
--
-- PURPOSE:
--   This file acts as a module loader for all "core" configuration files.
--   Instead of requiring each core module individually in init.lua, we use
--   this single entry point to load them in the correct order.
--
--   Loading order matters because:
--   1. globals.lua sets the leader key (must be first)
--   2. options.lua configures editor behavior
--   3. keymaps.lua defines keyboard shortcuts (needs leader key)
--   4. autocmds.lua sets up automatic behaviors
--
-- DOCUMENTATION:
--   > Lua modules : https://neovim.io/doc/user/lua-guide.html#lua-guide-modules
--   > require()   : https://www.lua.org/pil/8.1.html
--
-- =============================================================================

-- Load global variables first - this sets vim.g.mapleader which MUST be
-- defined before any plugin loads or creates keymaps using <leader>.
require("config.core.globals")

-- Load editor options (line numbers, tabs, wrapping, etc.).
-- These are Neovim settings that control how the editor behaves and displays.
require("config.core.options")

-- Load custom keybindings that don't depend on plugins.
-- Plugin-specific keymaps are defined in their respective plugin files.
require("config.core.keymaps")

-- Load autocommands - automatic actions triggered by specific events.
-- Examples: highlight yanked text, restore cursor position, auto-save.
require("config.core.autocmds")
