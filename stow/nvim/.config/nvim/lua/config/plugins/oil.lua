-- =============================================================================
-- FILE: lua/config/plugins/oil.lua
-- File explorer to edit filesystem like a regular Neovim buffer
--
-- DOCUMENTATION:
--   > GitHub : https://github.com/stevearc/oil.nvim
--
-- =============================================================================

return {
  {
    "stevearc/oil.nvim",

    ---@module 'oil'
    ---@type oil.SetupOpts
    dependencies = {
      -- mini.icons provides file type icons in the Oil buffer.
      -- opts = {} triggers lazy.nvim to call setup() with empty config.
      { "echasnovski/mini.icons", opts = {} },
    },

    -- Oil is "lazy loaded" and triggered by keymap
    keys = {
      { "<leader>-", "<cmd>Oil --float<CR>", desc = "Open Oil" },
    },

    config = function()
      require("oil").setup({
        columns = {
          "icon", -- File type icon (from mini.icons)
          "permissions", -- Unix permissions (rwxr-xr-x)
          "size", -- File size in human-readable format
          "mtime", -- Last modification time
        },

        view_options = {
          show_hidden = true, -- Show dotfiles (hidden files like .gitignore)
        },

        keymaps = {
          -- Allow pressing 'q' to close Oil (matches our special buffer pattern)
          ["q"] = "actions.close",
        },

        float = {
          max_width = 0.8, -- 80% of screen width
          max_height = 0.8, -- 80% of screen height
          border = "rounded", -- Rounded corners on the window border
          padding = 2, -- Space between border and content
        },

        -- When you delete files in Oil, send them to trash instead of
        -- permanently deleting them. This provides a safety net for
        -- accidental deletions.
        -- NOTE: Requires 'trash' CLI tool to be installed.
        delete_to_trash = true,
      })
    end,
  },
}
