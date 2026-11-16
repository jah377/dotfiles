-- =============================================================================
-- FILE: lua/config/plugins/gitsigns.lua
-- Display git change indicators in the sign column (left gutter)
--
-- DOCUMENTATION:
--   > GitHub : https://github.com/lewis6991/gitsigns.nvim
-- =============================================================================

return {
    "lewis6991/gitsigns.nvim",

    -- Signs only mean something once a file buffer exists
    event = { "BufReadPre", "BufNewFile" },

    -- lazy.nvim calls require("gitsigns").setup(opts) when `opts` is given
    opts = {
        signs = {
            add = { text = "+" }, -- New lines added since last commit
            change = { text = "~" }, -- Lines modified since last commit
            delete = { text = "_" }, -- Lines deleted (marker at next line)
            topdelete = { text = "‾" }, -- Lines deleted at top of hunk
            changedelete = { text = "~" }, -- Line changed and had adjacent delete
        },
    },
}
