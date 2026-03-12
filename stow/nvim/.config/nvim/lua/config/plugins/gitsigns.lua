-- =============================================================================
-- FILE: lua/config/plugins/gitsigns.lua
--
-- PURPOSE:
--   Configures gitsigns.nvim, which displays Git change indicators in the
--   sign column (the gutter to the left of line numbers). This gives you
--   instant visual feedback about which lines have been added, modified,
--   or deleted since the last commit.
--
-- WHAT YOU'LL SEE IN THE GUTTER:
--   +  : Line was added (new line not in the last commit)
--   ~  : Line was modified (changed from the last commit)
--   _  : Line was deleted below this position
--   ‾  : Line was deleted above this position (top delete)
--   ~  : Line was both changed and had adjacent deletions
--
-- DOCUMENTATION:
--   > GitHub : https://github.com/lewis6991/gitsigns.nvim
--
-- =============================================================================

return {
  {
    -- Plugin identifier from GitHub
    "lewis6991/gitsigns.nvim",

    -- 'opts' is shorthand for passing a table to the plugin's setup() function.
    -- It's equivalent to calling require("gitsigns").setup({ ... })
    -- lazy.nvim calls setup() automatically when 'opts' is provided.
    opts = {
      -- Configure the characters displayed in the sign column.
      -- These are the visual indicators that show Git status.
      signs = {
        add = { text = "+" },          -- New lines added since last commit
        change = { text = "~" },       -- Lines modified since last commit
        delete = { text = "_" },       -- Lines deleted (marker at next line)
        topdelete = { text = "‾" },    -- Lines deleted at top of hunk
        changedelete = { text = "~" }, -- Line changed and had adjacent delete
      },
    },
  },
}
