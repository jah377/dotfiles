-- =============================================================================
-- FILE: lua/config/plugins/snacks.lua
-- Small quality-of-life modules from snacks.nvim.
--
-- Only the modules in use are listed. Every snacks module is off unless
-- `enabled = true` is passed, and most modules (lazygit, terminal, notify,
-- win, ...) are libraries that only act when called, so `enabled = false`
-- entries are noise. Features deliberately NOT taken from snacks because
-- another plugin owns them: picker (telescope/fff), explorer (oil), indent
-- guides (mini.indentscope), images (image.nvim), window dimming (catppuccin).
--
-- DOCUMENTATION:
--   > GitHub : https://github.com/folke/snacks.nvim
-- =============================================================================

return {
    "folke/snacks.nvim",
    priority = 1000, -- before other plugins: bigfile must see the first buffer
    lazy = false,

    opts = {
        -- Disable heavy features (LSP, treesitter, ...) for very large files
        bigfile = {
            enabled = true,
            notify = true,
            size = 1.5 * 1024 * 1024, -- bytes
        },

        -- Render the file given on the command line before plugins finish loading
        quickfile = { enabled = true },

        -- Sign/number column rendering. Defaults are used as-is
        -- (left: mark, sign; right: fold, git).
        statuscolumn = { enabled = true },
    },
}
