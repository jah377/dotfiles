-- [[ Nvim Treesitter Text Objects: syntax-aware text-objects ]]
-- See https://github.com/nvim-treesitter/nvim-treesitter-textobjects

return {
  "nvim-treesitter/nvim-treesitter-textobjects",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
  },
  init = function()
    local config = require("nvim-treesitter.configs")
    config.setup({
      textobjects = {
        select = {
          enable = true,
          lookahead = true,
          include_surrounding_whitespace = false,
          keymaps = {
            -- You can use the capture groups defined in textobjects.scm
            -- >> 'vaf' to select entire function
            ["af"] = { query = "@function.outer", desc = "Select outer part of function" },
            ["if"] = { query = "@function.inner", desc = "Select inner part of function" },
            ["ac"] = { query = "@class.outer", desc = "Select outer part of class" },
            ["ic"] = { query = "@class.inner", desc = "Select inner part of a class region" },
          },
          selection_modes = {
            ["@parameter.outer"] = "v", -- charwise
            ["@function.outer"] = "V", -- linewise
            ["@class.outer"] = "<c-v>", -- blockwise
          },
        },
      },
    })
  end,
}
