-- =============================================================================
-- FILE: lua/config/lsp/diagnostics.lua
-- How diagnostics (errors, warnings) are displayed: signs, underlines,
-- virtual lines. Nothing else lives here.
--
-- HISTORY:
--   This file used to wrap vim.notify to hide a "position_encoding param is
--   required" warning and to force every client to UTF-16 after it attached.
--   The warning came from plugins calling make_position_params() without an
--   encoding (no installed plugin does so any more), and the encoding mismatch
--   between pyright and ruff is now solved at negotiation time in
--   plugins/mason.lua by advertising UTF-16 as the only supported encoding.
--
-- DOCUMENTATION:
--  > :help vim.diagnostic      : Neovim diagnostic system
--  > :help vim.diagnostic.Opts : Configuration options
-- =============================================================================

local severity = vim.diagnostic.severity

vim.diagnostic.config({
    severity_sort = true,
    underline = { severity = severity.ERROR }, -- Only underline errors
    virtual_lines = { current_line = true }, -- Show diagnostic text under the cursor line
    -- Sign column icons (Nerd Font required, see globals.lua have_nerd_font)
    signs = {
        text = {
            [severity.ERROR] = "󰅚 ",
            [severity.WARN] = "󰀪 ",
            [severity.INFO] = "󰋽 ",
            [severity.HINT] = "󰌶 ",
        },
    },
})
