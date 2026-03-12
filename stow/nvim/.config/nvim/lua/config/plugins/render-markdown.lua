-- =============================================================================
-- FILE: lua/config/plugins/render-markdown.lua
--
-- PURPOSE:
--   Configures render-markdown.nvim, which improves the visual display of
--   Markdown files in Neovim. Instead of showing raw Markdown syntax, it
--   renders headings, code blocks, lists, and other elements with better
--   visual styling.
--
-- WHAT IT DOES:
--   - Renders headings with different colors and optional icons
--   - Shows code blocks with background highlighting
--   - Displays checkboxes, bullet points, and numbered lists nicely
--   - Hides or conceals raw Markdown syntax characters
--   - Makes tables more readable
--
-- DOCUMENTATION:
--   > GitHub : https://github.com/MeanderingProgrammer/render-markdown.nvim
--
-- =============================================================================

return {
  {
    -- Plugin identifier from GitHub
    "MeanderingProgrammer/render-markdown.nvim",

    -- Dependencies required for this plugin to work
    dependencies = {
      -- Treesitter provides syntax tree parsing for Markdown
      "nvim-treesitter/nvim-treesitter",
      -- mini.nvim provides icons and other utilities
      "echasnovski/mini.nvim"
    },

    -- Type annotations for Lua LSP
    ---@module 'render-markdown'
    ---@type render.md.UserConfig

    -- Empty opts table means use all default settings.
    -- The plugin's defaults work well for most use cases.
    -- See the GitHub repo for customization options.
    opts = {},
  },
}
