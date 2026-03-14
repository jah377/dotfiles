-- =============================================================================
-- FILE: lua/config/plugins/which-key.lua
-- Improve kbd discoverability by displaying kbds in popup as you type
--
-- DOCUMENTATION:
--   > GitHub : https://github.com/folke/which-key.nvim
--
-- =============================================================================

return {
  {
    "folke/which-key.nvim",
    event = "VeryLazy", -- load after UI is rendered
    opts = {
      preset = "modern", -- cleaner visual styling

      keys = {
        scroll_up = "<C-p>",
        scroll_down = "<C-n>",
      },

      win = {
        height = { min = 4, max = 25 }, -- Limit popup height range
      },

      -- Keybinding groups
      spec = {
        { "<leader>s", group = "spelling" }, -- core/keymaps.lua
        { "<leader>b", group = "buffers" }, -- core/keymaps.lua
        { "<leader>q", group = "quickfix" }, -- core/keymaps.lua
        { "<leader>l", group = "lsp" }, -- lsp/keymaps.lua
        { "<leader>f", group = "find" }, -- plugins/telescope.lua
        { "<leader>9", group = "99" }, -- plugins/99.nvim
        { "<leader>c", group = "code" }, -- plugins/nvim-treesitter-textobject.lua

        -- plugins/telescope.lua
        -- core/keymaps.lua
        { "<leader>m", group = "markdown" },
      },

      icons = {
        -- Shown between nested key sequences in the command line area
        -- Example: "<leader> » f » f" shows the path taken
        breadcrumb = "»",

        -- Separator between the key and its description
        -- Example: "f ➜ Find files"
        separator = "➜",

        -- Icon shown before group names
        -- Makes groups visually distinct from leaf keymaps
        group = "󰹍 ",
      },
    },

    keys = {
      {
        -- Show keymaps specific to the current buffer.
        -- Useful for seeing what file-type-specific keymaps are available.
        "<leader>?",
        function()
          -- global = false means only show buffer-local keymaps
          require("which-key").show({ global = false })
        end,
        desc = "Show buffer keymaps",
      },
    },
  },
}
