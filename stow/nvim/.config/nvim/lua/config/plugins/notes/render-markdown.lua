-- =============================================================================
-- FILE: lua/config/plugins/notes/render-markdown.lua
-- Improves visual display of Markdown and Quarto (.qmd) files
--
-- DOCUMENTATION:
--   > GitHub : https://github.com/MeanderingProgrammer/render-markdown.nvim
--   > Callouts : https://github.com/MeanderingProgrammer/render-markdown.nvim/wiki/Callouts
-- =============================================================================

return {
  "MeanderingProgrammer/render-markdown.nvim",
  dependencies = {
    "nvim-treesitter/nvim-treesitter", -- syntax tree parsing
    "echasnovski/mini.nvim", -- icons
  },
  ft = { "markdown", "quarto" },
  opts = {
    heading = {
      -- backgrounds = {}, -- remove header color
    },
    code = {
      -- https://github.com/MeanderingProgrammer/render-markdown.nvim/wiki/CodeBlocks
      language_border = " ",
      language_left = "",
      language_right = "",
    },
    checkbox = {
      unchecked = { icon = "✘ " },
      checked = { icon = "✔ ", scope_highlight = "@markup.strikethrough" },
      custom = { todo = { rendered = "◯ " } },
    },
  },
}
