-- =============================================================================
-- FILE: lua/config/plugins/render-markdown.lua
-- Improves visual display of Markdown and Quarto (.qmd) files
--
-- DOCUMENTATION:
--   > GitHub : https://github.com/MeanderingProgrammer/render-markdown.nvim
--
-- =============================================================================

return {
  {
    "MeanderingProgrammer/render-markdown.nvim",

    ft = { "markdown", "quarto" },

    dependencies = {
      "nvim-treesitter/nvim-treesitter", -- syntax tree parsing
      "echasnovski/mini.nvim", -- icons
    },

    ---@module 'render-markdown'
    ---@type render.md.UserConfig
    opts = {
      file_types = { "markdown", "quarto" },
    },
  },
}
