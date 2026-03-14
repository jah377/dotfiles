-- =============================================================================
-- FILE: lua/config/plugins/snacks.lua
-- Collection of 20+ small quality-of-life plugins (like mini.nvim)
--
-- DOCUMENTATION:
--   > GitHub : https://github.com/folke/snacks.nvim
--
-- =============================================================================

return {
  {
    "folke/snacks.nvim",
    priority = 1000, -- high priority (load before other plugins)
    lazy = false, -- load immediately

    opts = {
      -- =====================================================================
      -- ENABLED FEATURES
      -- =====================================================================

      -- Disable heavy features (LSP, Treesitter, etc.) for large files
      bigfile = {
        enabled = true,
        notify = true, -- Show notification when bigfile mode activates
        size = 1.5 * 1024 * 1024, -- Threshold: 1.5 MB
      },

      -- Speed up initial file rendering when you run `nvim <file>` from
      -- the command line. Provides faster time-to-first-render.
      quickfile = { enabled = true },

      -- Enhanced sign column (gutter) rendering with better visual styling.
      -- The sign column shows line numbers, git changes, diagnostics, etc.
      statuscolumn = {
        enabled = true,
        opts = { statuscolumn = {} },
      },

      -- =====================================================================
      -- DISABLED FEATURES (functionality provided elsewhere)
      -- =====================================================================

      -- Dimming inactive windows - handled by theme.lua (catppuccin)
      dim = { enabled = false },

      -- File explorer - we use oil.nvim instead
      explorer = { enabled = false },

      -- GitHub integration - prefer viewing in browser
      gh = { enabled = false },

      -- Git features - we use lazygit in tmux instead
      git = { enabled = false },

      -- Open in GitHub web - prefer browser integration
      gitbrowse = { enabled = false },

      -- Image viewing - we use image.nvim if needed
      image = { enabled = false },

      -- Indentation guides - we use mini.indentscope instead
      indent = { enabled = false },

      -- Fuzzy finder - we use telescope.nvim instead
      picker = { enabled = false },

      -- Lazygit integration - we run lazygit directly in tmux
      lazygit = { enabled = false },

      -- =====================================================================
      -- DISABLED FEATURES (not needed/wanted)
      -- =====================================================================

      -- Smooth animations - can be distracting
      animate = { enabled = false },

      -- Keep layout when deleting buffers - not needed
      bufdelete = { enabled = false },

      -- Startup dashboard - we prefer starting clean
      dashboard = { enabled = false },

      -- Fancy input UI - default is fine
      input = { enabled = false },

      -- Better vim.keymap.set - not needed
      keymap = { enabled = false },

      -- Window layout management - not needed
      layout = { enabled = false },

      -- Notification system - disabled in theme.lua as well
      notifier = { enabled = false },

      -- Notification utilities - not needed
      notify = { enabled = false },

      -- Lua profiler - only needed for debugging
      profiler = { enabled = false },

      -- LSP-aware file renaming - using LSP directly
      rename = { enabled = false },

      -- Scope-based navigation - not needed
      scope = { enabled = false },

      -- Persistent scratch buffers - not needed
      scratch = { enabled = false },

      -- Smooth scrolling - still has some jank
      scroll = { enabled = false },

      -- Floating terminal - we use tmux for terminals
      terminal = { enabled = false },

      -- Toggle keymaps - not needed
      toggle = { enabled = false },

      -- Utility functions - internal use
      util = { enabled = false },

      -- Floating windows for docs - not needed
      win = { enabled = false },

      -- Navigate LSP references with highlighting - not needed
      words = { enabled = false },

      -- Zen/focus mode - not needed
      zen = { enabled = false },
    },
  },
}
