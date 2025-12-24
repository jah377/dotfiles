-- [[ Conform.nvim: Lightweight formatter ]]
-- See: https://github.com/stevearc/conform.nvim

return {
  {
    "stevearc/conform.nvim",
    event = "VeryLazy",
    dependencies = {
      "WhoIsSethDaniel/mason-tool-installer.nvim",
      "williamboman/mason.nvim",
    },

    config = function()
      local mason_tools = require("mason-tool-installer")
      local conform = require("conform")

      local ensure_installed = {
        "stylua",    -- lua formatter
        "ruff",      -- python formatter and linter
        "prettierd", -- daemon markdown formatter (faster)
        "prettier",  -- markdown formatter (slower fallback)
      }

      -- Install non-lsp tools
      mason_tools.setup({
        ensure_installed = ensure_installed,
        auto_update = true,
        run_on_start = true,
      })

      -- Configure formatters
      conform.setup({
        formatters_by_ft = {
          lua = { "stylua" },
          python = {
            "ruff_organize_imports",
            "ruff_fix",
            "ruff_format",
          },
          markdown = { "prettierd", "prettier", stop_after_first = true },
        },
        default_format_opts = {
          lsp_format = "fallback",
        },
        format_on_save = {
          timeout_ms = 3000,
        },
        notify_on_error = true,
        notify_no_formatters = true,
      })
    end,
  },
}
