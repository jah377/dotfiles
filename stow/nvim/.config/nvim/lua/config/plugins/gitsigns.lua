-- =============================================================================
-- FILE: lua/config/plugins/gitsigns.lua
-- Display git change indicators in sign column (eg. left gutter)
--
-- DOCUMENTATION:
--   > GitHub : https://github.com/lewis6991/gitsigns.nvim
--
-- =============================================================================

return {
  {
    "lewis6991/gitsigns.nvim",

    -- lazy.nvim calls setup() automatically when 'opts' is provided.
    -- Equivalent to calling `require"gitsigns").setup({...})`
    opts = {
      signs = {
        add = { text = "+" }, -- New lines added since last commit
        change = { text = "~" }, -- Lines modified since last commit
        delete = { text = "_" }, -- Lines deleted (marker at next line)
        topdelete = { text = "‾" }, -- Lines deleted at top of hunk
        changedelete = { text = "~" }, -- Line changed and had adjacent delete
      },
    },
  },
}
