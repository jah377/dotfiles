return {
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      preset = "modern",
      win = {
        height = { max = math.huge },
      },
      spec = {
        { "<leader>f", group = "find" },
        { "<leader>fg", group = "grep-find" },
        { "<leader>fl", group = "lsp-find" },
        { "<leader>g", group = "git" },
        { "<leader>b", group = "buffer" },
      },
      icons = {
        rules = false,
        breadcrumb = " ", -- symbol used in the command line area that shows your active key combo
        separator = "󱦰  ", -- symbol used between a key and it's label
        group = "󰹍 ", -- symbol prepended to a group
      },
    },
    keys = {
      {
        "<leader>?",
        function()
          require("which-key").show({ global = false })
        end,
        desc = "local-keymap",
      },
    },
  },
}
