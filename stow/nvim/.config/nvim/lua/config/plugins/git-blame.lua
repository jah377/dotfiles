-- =============================================================================
-- FILE: lua/config/plugins/git-blame.lua
-- Toggle inline git blame annotations as virtual text.
-- Disabled by default; toggle with <leader>gb.
--
-- DOCUMENTATION:
--   > GitHub : https://github.com/f-person/git-blame.nvim
--
-- =============================================================================

return {
  "f-person/git-blame.nvim",
  event = "VeryLazy",
  opts = {
    enabled = false, -- start disabled, toggle with keymap
  },
  keys = {
    { "<leader>gb", "<cmd>GitBlameToggle<CR>", desc = "[G]it [B]lame" },
    { "<leader>gs", "<cmd>GitBlameCopySHA<CR>", desc = "[G]it Copy [S]HA" },
    { "<leader>gf", "<cmd>GitBlameCopyFileURL<CR>", desc = "[G]it Copy [F]ile URL" },
    { "<leader>gc", "<cmd>GitBlameCopyCommitURL<CR>", desc = "[G]it Copy [C]ommit URL" },
    { "<leader>go", "<cmd>GitBlameOpenFileURL<CR>", desc = "[G]it [O]pen File URL" },
  },
}
