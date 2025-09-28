-- =============================================================================
-- TITLE : nvim-treesittertextobjects.nvim
--
-- ABOUT : Syntax aware text-objects, select, move, swap, and peek support
--
-- LINKS :
--   > github : https://github.com/nvim-treesitter/nvim-treesitter-textobjects
--
-- TUTORIALS :
--   > Mr. Jakobs : https://youtu.be/E4qXZv34NQQ?si=UmMqqCnXOlOAnV8_
--
-- =============================================================================

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
