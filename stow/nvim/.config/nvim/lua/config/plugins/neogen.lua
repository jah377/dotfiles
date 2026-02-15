-- [[ neogen: Documentation generator ]]
-- See: https://github.com/danymat/neogen

return {
  {
    "danymat/neogen",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    opts = {
      snippet_engine = "luasnip",
      languages = {
        python = {
          template = { annotation_convention = "google_docstrings" },
        },
      },
    },
    keys = {
      {
        "<leader>d",
        function()
          require("neogen").generate()
        end,
        desc = "Generate docstring",
      },
    },
  },
}
