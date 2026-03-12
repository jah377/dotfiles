-- =============================================================================
-- FILE: lua/config/plugins/which-key.lua
--
-- PURPOSE:
--   Configures which-key.nvim, a plugin that displays available keybindings
--   in a popup as you type. This is incredibly helpful for discovering and
--   remembering keymaps, especially those starting with <leader>.
--
-- HOW IT WORKS:
--   1. You start typing a key sequence (like <leader>)
--   2. After a brief delay (see timeoutlen in options.lua), a popup appears
--   3. The popup shows all available keymaps that start with what you typed
--   4. You can continue typing to narrow down, or read and pick one
--
-- EXAMPLE:
--   Press <Space> (the leader key) and wait:
--   A popup appears showing:
--     f  → find (group)
--     g  → grep (group)
--     b  → buffers (group)
--     ...etc
--   Press 'f' to see all "find" commands, then 'f' again to find files.
--
-- DOCUMENTATION:
--   > GitHub : https://github.com/folke/which-key.nvim
--
-- =============================================================================

return {
  {
    -- Plugin identifier from GitHub
    "folke/which-key.nvim",

    -- Lazy load on "VeryLazy" event (loads after UI is rendered).
    -- This doesn't delay startup but ensures which-key is ready when needed.
    event = "VeryLazy",

    -- Configuration options passed to setup()
    opts = {
      -- Use the "modern" preset for visual styling.
      -- This provides a cleaner, more contemporary look compared to "classic".
      preset = "modern",

      -- Customize the scrolling keymaps within the which-key popup window.
      -- Default uses Ctrl-d/Ctrl-u, but we use Ctrl-n/Ctrl-p for consistency
      -- with other navigation patterns.
      keys = {
        scroll_up = "<c-p>",   -- Scroll popup up (default was <c-d>)
        scroll_down = "<c-n>", -- Scroll popup down (default was <c-u>)
      },

      -- Window (popup) configuration
      win = {
        height = { min = 4, max = 25 }, -- Limit popup height range
      },

      -- Define key groups - these create labeled categories in the popup.
      -- When you press <leader>, you'll see these groups with their names.
      -- Groups make the keymap hierarchy more understandable.
      spec = {
        { "<leader>f", group = "find" },       -- Telescope/search commands
        { "<leader>g", group = "grep" },       -- Grep/text search commands
        { "<leader>c", group = "code" },       -- Code-related commands
        { "<leader>w", group = "workspace" },  -- Workspace/project commands
        { "<leader>b", group = "buffers" },    -- Buffer management commands
        { "<leader>x", group = "diagnostics" }, -- Diagnostic/error commands
      },

      -- Customize the icons shown in the popup
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

    -- Additional keymaps defined by the plugin
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
