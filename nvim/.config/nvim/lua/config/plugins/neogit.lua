return {
  {
    "NeogitOrg/neogit",
    dependencies = {
      "nvim-lua/plenary.nvim",         -- required
      "sindrets/diffview.nvim",        -- optional - Diff integration
      "nvim-telescope/telescope.nvim", -- optional
    },
    keys = {
      {
        "<leader>gn",
        function()
          require("neogit").open({ kind = "floating" })
        end,
        desc = "[Git] [N]eogit"
      }
    }
  }
}
