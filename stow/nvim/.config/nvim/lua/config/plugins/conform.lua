-- [[ Conform.nvim: Lightweight formatter ]]
-- Tool installation handled in 'plugins/mason-tool-installer.lua'
-- LSP servers installed in 'plugins/lsp/mason.lua'
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
      local conform = require("conform")

      conform.setup({
        formatters_by_ft = {
          lua = { "stylua" },
          python = {
            "isort",       -- organize inputs
            "ruff_fix",    -- fix linting issues
            "ruff_format", -- fix formatting issues
          },
          markdown = {
            "prettierd", -- daemon formatter (fast)
            "prettier",  -- formatter (slow fallback)
            stop_after_first = true,
          },
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
