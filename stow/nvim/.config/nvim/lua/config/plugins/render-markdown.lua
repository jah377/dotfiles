-- [[ Render Markdown: Plugin to improve viewing Markdown files in Neovim ]]
-- See https://github.com/MeanderingProgrammer/render-markdown.nvim

return {
  {
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-mini/mini.icons" },
    ---@module 'render-markdown'
    ---@type render.md.UserConfig
    opts = {},
  },
}
