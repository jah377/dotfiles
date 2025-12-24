-- [[ Mason Tool Installer: Auto-install formatters and linters ]]
-- See: https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim
--
-- This plugin manages non-LSP tools (formatters, linters, DAP servers)
-- For LSP servers, see: lua/config/plugins/lsp/mason.lua

return {
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    dependencies = {
      "williamboman/mason.nvim",
    },
    -- Load eagerly (no event/cmd) to ensure tools install on startup
    config = function()
      require("mason-tool-installer").setup({
        ensure_installed = {
          -- Formatters
          "stylua", -- lua formatter
          "ruff", -- python formatter and linter
          "isort", -- python import organizer
          "prettierd", -- daemon markdown formatter (faster)
          "prettier", -- markdown formatter (slower fallback)
        },
        auto_update = true,
        run_on_start = true,
      })
    end,
  },
}
