-- =============================================================================
-- FILE: lua/config/plugins/conform.lua
--
-- PURPOSE:
--   Configures conform.nvim, a lightweight and fast code formatter plugin.
--   Conform runs external formatting tools (like Prettier, Black, stylua)
--   on your code, either automatically on save or manually.
--
-- WHY CONFORM INSTEAD OF LSP FORMATTING?
--   - Faster: External tools are often faster than LSP formatting
--   - More options: Can use any CLI formatter, not just LSP-provided ones
--   - Better control: Precise configuration per file type
--   - Fallback support: Can try multiple formatters in sequence
--
-- HOW IT WORKS:
--   1. When you save a file, conform checks the file type
--   2. It runs the configured formatter(s) for that file type
--   3. The buffer is updated with the formatted code
--   4. If formatting fails, it shows an error notification
--
-- RELATED FILES:
--   - plugins/mason-tool-installer.lua : Installs the formatter tools
--   - plugins/lsp/mason.lua : Installs LSP servers (separate from formatters)
--
-- DOCUMENTATION:
--   > GitHub : https://github.com/stevearc/conform.nvim
--
-- =============================================================================

return {
  {
    -- Plugin identifier from GitHub
    "stevearc/conform.nvim",

    -- Load on "VeryLazy" event - after initial UI render.
    -- Formatting isn't needed until you start editing.
    event = "VeryLazy",

    -- Dependencies that must be loaded before conform
    dependencies = {
      -- Ensures formatter tools (stylua, ruff, etc.) are installed
      "WhoIsSethDaniel/mason-tool-installer.nvim",
      -- Mason is the package manager for external tools
      "williamboman/mason.nvim",
    },

    config = function()
      local conform = require("conform")

      conform.setup({
        -- Map file types to their formatters.
        -- Each key is a filetype, value is a list of formatters to run.
        formatters_by_ft = {
          -- Lua files: Use stylua (the standard Lua formatter)
          lua = { "stylua" },

          -- Python files: Run multiple formatters in sequence
          python = {
            "isort",       -- First: organize imports alphabetically
            "ruff_fix",    -- Second: auto-fix linting issues
            "ruff_format", -- Third: format the code (like Black)
          },

          -- Markdown files: Try prettierd first, fall back to prettier
          markdown = {
            "prettierd", -- Daemon version - faster for repeated formatting
            "prettier",  -- Regular version - fallback if daemon isn't running
            stop_after_first = true, -- Only run one (the first that works)
          },
        },

        -- Default options that apply to all formatters
        default_format_opts = {
          -- If no formatter is configured for a file type, try LSP formatting
          -- as a fallback. This provides reasonable behavior for any file type.
          lsp_format = "fallback",
        },

        -- Automatically format files when saving (:w)
        format_on_save = {
          -- Maximum time to wait for formatting before giving up (in ms).
          -- Some formatters are slow on large files; this prevents hanging.
          timeout_ms = 3000,
        },

        -- Show a notification when formatting fails
        notify_on_error = true,

        -- Show a notification when no formatters are available for a file type
        -- Helps debug why formatting isn't working
        notify_no_formatters = true,
      })
    end,
  },
}
