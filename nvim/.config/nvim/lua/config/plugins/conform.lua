return {
  {
    "stevearc/conform.nvim",
    event = "VeryLazy",
    dependencies = { "WhoIsSethDaniel/mason-tool-installer.nvim", "williamboman/mason.nvim" },
    config = function()
      local mason_tools = require("mason-tool-installer")
      local conform = require("conform")
      local ensure_installed = {
        "stylua", -- lua formatter
        "ruff", -- python formatter
        "prettierd", -- daemon markdown formatter (faster)
        "prettier", -- markdown formatter (slower)
      }

      -- Install non-lsp tools
      mason_tools.setup({
        ensure_installed = {
        "stylua", -- lua formatter
        "ruff", -- python formatter
        "prettierd", -- daemon markdown formatter (faster)
        "prettier", -- markdown formatter (slower)
      },
        auto_update = true,
        run_on_start = true,
      })

      -- Configure formatters
      conform.setup({
        formatters_by_ft = {
          lua = { "stylua" },
          python = {
            "ruff_format", -- to run the ruff formatter
            "ruff_fix", -- to fix auto-fixable lint errors
          },
          markdown = { "prettierd", "prettier", stop_after_first = true },
        },
        default_format_opts = {
          lsp_format = "fallback",
        },
        format_on_save = {
          -- Options passed to `conform.format()`
          timeout_ms = 1000,
          lsp_format = "fallback",
        },
        notify_on_error = true,
        notify_no_formatters = true,
      })
    end,
  },
}
