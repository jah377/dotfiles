-- [[ Show available keybindings in a popup as you type ]]
-- See: https://github.com/folke/which-key.nvim

return {
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      preset = "modern",
      keys = {
        scroll_up = "<c-p>",   -- default <c-d>
        scroll_down = "<c-n>", -- default <c-u>
      },

      -- Window configuration
      win = {
        height = { min = 4, max = 25 }, -- Reasonable height limits
      },

      -- Key group definitions
      spec = {
        { "<leader>f", group = "find" },
        { "<leader>g", group = "grep" },
        { "<leader>c", group = "code" },
        { "<leader>w", group = "workspace" },
        { "<leader>b", group = "buffers" },
        { "<leader>x", group = "diagnostics" },
      },

      -- Custom icons
      icons = {
        breadcrumb = "»", -- Active key combo separator in command line
        separator = "➜", -- Key-description separator
        group = "󰹍 ", -- Group prefix icon
      },
    },

    -- Custom keymaps
    keys = {
      {
        "<leader>?",
        function()
          require("which-key").show({ global = false })
        end,
        desc = "Show buffer keymaps",
      },
    },
  },
}
