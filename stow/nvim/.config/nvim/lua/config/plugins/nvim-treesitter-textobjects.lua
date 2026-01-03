-- [[ Nvim Treesitter Text Objects: syntax-aware text-objects ]]
-- See https://github.com/nvim-treesitter/nvim-treesitter-textobjects

-- Documented in 'docs/treesitter_text_objects.md'

return {
  "nvim-treesitter/nvim-treesitter-textobjects",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
  },
  config = function()
    local config = require("nvim-treesitter.configs")
    config.setup({
      textobjects = {
        -- Text object selection
        select = {
          enable = true,
          -- Automatically jump forward to textobject, similar to targets.vim
          lookahead = true,
          include_surrounding_whitespace = false,
          keymaps = {
            -- Functions
            ["af"] = { query = "@function.outer", desc = "Select outer part of function" },
            ["if"] = { query = "@function.inner", desc = "Select inner part of function" },

            -- Classes
            ["ac"] = { query = "@class.outer", desc = "Select outer part of class" },
            ["ic"] = { query = "@class.inner", desc = "Select inner part of class" },

            -- Parameters/arguments
            ["aa"] = { query = "@parameter.outer", desc = "Select outer part of parameter" },
            ["ia"] = { query = "@parameter.inner", desc = "Select inner part of parameter" },

            -- Conditionals
            ["ai"] = { query = "@conditional.outer", desc = "Select outer part of conditional" },
            ["ii"] = { query = "@conditional.inner", desc = "Select inner part of conditional" },

            -- Loops
            ["al"] = { query = "@loop.outer", desc = "Select outer part of loop" },
            ["il"] = { query = "@loop.inner", desc = "Select inner part of loop" },

            -- Comments
            ["a/"] = { query = "@comment.outer", desc = "Select comment" },
          },
          selection_modes = {
            ["@parameter.outer"] = "v", -- charwise
            ["@function.outer"] = "V", -- linewise
            ["@class.outer"] = "V", -- linewise
            ["@conditional.outer"] = "V", -- linewise
            ["@loop.outer"] = "V", -- linewise
          },
        },

        -- Move to next/previous text object
        move = {
          enable = true,
          set_jumps = true, -- Set jumps in jumplist
          goto_next_start = {
            ["]m"] = { query = "@function.outer", desc = "Next function start" },
            ["]c"] = { query = "@class.outer", desc = "Next class start" },
            ["]a"] = { query = "@parameter.inner", desc = "Next parameter start" },
          },
          goto_next_end = {
            ["]M"] = { query = "@function.outer", desc = "Next function end" },
            ["]C"] = { query = "@class.outer", desc = "Next class end" },
            ["]A"] = { query = "@parameter.inner", desc = "Next parameter end" },
          },
          goto_previous_start = {
            ["[m"] = { query = "@function.outer", desc = "Previous function start" },
            ["[c"] = { query = "@class.outer", desc = "Previous class start" },
            ["[a"] = { query = "@parameter.inner", desc = "Previous parameter start" },
          },
          goto_previous_end = {
            ["[M"] = { query = "@function.outer", desc = "Previous function end" },
            ["[C"] = { query = "@class.outer", desc = "Previous class end" },
            ["[A"] = { query = "@parameter.inner", desc = "Previous parameter end" },
          },
        },

        -- Swap text objects (useful for function parameters)
        swap = {
          enable = true,
          swap_next = {
            ["<leader>a"] = { query = "@parameter.inner", desc = "Swap parameter with next" },
          },
          swap_previous = {
            ["<leader>A"] = { query = "@parameter.inner", desc = "Swap parameter with previous" },
          },
        },
      },
    })
  end,
}
