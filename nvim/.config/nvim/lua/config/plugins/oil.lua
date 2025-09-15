return {
  {
    "stevearc/oil.nvim",
    ---@module 'oil'
    ---@type oil.SetupOpts
    opts = {},
    dependencies = { { "echasnovski/mini.icons", opts = {} } },
    config = function()
      require("oil").setup({
        columns = {
          "icon",
          "permissions",
          "size",
          "mtime",
        },
        view_options = { show_hidden = true },
        keymaps = {
          ["q"] = "actions.close",
        },
        float = {
          max_width = 0.8,
          max_height = 0.8,
        },
      })

      vim.keymap.set("n", "<leader>-", "<cmd>Oil --float<CR>", { desc = "Open Oil" })
    end,
  },
}
