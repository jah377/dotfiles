-- [[ Oil.nvim: Nvim file explorer ]]
-- See: https://github.com/stevearc/oil.nvim

return {
  {
    "stevearc/oil.nvim",
    ---@module 'oil'
    ---@type oil.SetupOpts
    dependencies = {
      -- Provide icon column per doc
      { "echasnovski/mini.icons", opts = {} },
    },
    keys = {
      { "<leader>-", "<cmd>Oil --float<CR>", desc = "Open Oil" },
    },

    config = function()
      require("oil").setup({
        columns = {
          "icon",
          "permissions",
          "size",
          "mtime",
        },
        view_options = {
          show_hidden = true, -- Always show hidden files
        },
        keymaps = {
          ["q"] = "actions.close", -- Quick close with 'q'
        },
        float = {
          max_width = 0.8,
          max_height = 0.8,
          border = "rounded", -- Add visual border
          padding = 2,
        },

        -- Enable trash support for safer file operations
        delete_to_trash = true,
      })
    end,
  },
}
