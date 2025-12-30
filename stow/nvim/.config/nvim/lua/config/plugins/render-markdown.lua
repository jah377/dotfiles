-- [[ Render Markdown: Plugin to improve viewing Markdown files in Neovim ]]
-- See https://github.com/MeanderingProgrammer/render-markdown.nvim

return {
  {
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter", "echasnovski/mini.nvim" },
    ---@module 'render-markdown'
    ---@type render.md.UserConfig
    opts = {},
  },
}
