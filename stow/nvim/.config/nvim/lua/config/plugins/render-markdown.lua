-- =============================================================================
-- FILE: lua/config/plugins/render-markdown.lua
-- Improves visual display of Markdown files by rendering .md elements
--
-- DOCUMENTATION:
--   > GitHub : https://github.com/MeanderingProgrammer/render-markdown.nvim
--
-- =============================================================================

return {
  {
    "MeanderingProgrammer/render-markdown.nvim",

    dependencies = {
      "nvim-treesitter/nvim-treesitter", -- syntax tree parsing
      "echasnovski/mini.nvim", -- icons
    },

    ---@module 'render-markdown'
    ---@type render.md.UserConfig
    opts = {},
  },
}
