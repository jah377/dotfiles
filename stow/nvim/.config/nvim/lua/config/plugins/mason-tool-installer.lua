-- =============================================================================
-- FILE: lua/config/plugins/mason-tool-installer.lua
--
-- PURPOSE:
--   Configures mason-tool-installer, which automatically installs non-LSP
--   tools like formatters, linters, and debuggers via Mason. This ensures
--   your development tools are consistently available across machines.
--
-- WHAT'S THE DIFFERENCE FROM MASON-LSPCONFIG?
--   - mason-lspconfig.nvim : Installs LSP SERVERS (like pyright, lua_ls)
--     See: lua/config/plugins/lsp/mason.lua
--   - mason-tool-installer: Installs OTHER TOOLS (formatters, linters, DAP)
--     See: this file
--
-- TOOLS INSTALLED:
--   Formatters:
--   - stylua    : Formats Lua code
--   - ruff      : Python linter and formatter (fast, written in Rust)
--   - isort     : Sorts Python imports alphabetically
--   - prettierd : Daemon version of Prettier (faster for repeated use)
--   - prettier  : Formats Markdown, JSON, YAML, and more
--
-- DOCUMENTATION:
--   > GitHub : https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim
--   > Mason  : https://github.com/williamboman/mason.nvim
--
-- =============================================================================

return {
  {
    -- Plugin identifier from GitHub
    "WhoIsSethDaniel/mason-tool-installer.nvim",

    -- This plugin depends on Mason being available
    dependencies = {
      "williamboman/mason.nvim",
    },

    -- No event or keys - load eagerly to ensure tools install on startup.
    -- We want formatters available immediately when you open any file.

    -- Configuration function
    config = function()
      require("mason-tool-installer").setup({
        -- List of tools to ensure are installed.
        -- Mason will automatically download and install these if missing.
        -- Tool names must match Mason's package names exactly.
        ensure_installed = {
          -- Lua formatter - enforces consistent code style
          "stylua",

          -- Python linter and formatter - extremely fast, replaces flake8/black
          "ruff",

          -- Python import sorter - organizes imports alphabetically
          "isort",

          -- Daemon version of Prettier - keeps running in background for speed
          -- Used for Markdown formatting
          "prettierd",

          -- Prettier itself - fallback if prettierd isn't available
          "prettier",
        },

        -- Automatically check for and install updates to these tools
        auto_update = true,

        -- Run installation check when Neovim starts.
        -- This ensures any missing tools are installed immediately.
        run_on_start = true,
      })
    end,
  },
}
