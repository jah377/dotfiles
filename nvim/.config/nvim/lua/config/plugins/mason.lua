return {
  "williamboman/mason.nvim",
  dependencies = {
    "williamboman/mason-lspconfig.nvim",
    "WhoIsSethDaniel/mason-tool-installer.nvim",

    -- Useful status updates for LSP
    -- See https://github.com/j-hui/fidget.nvim
    -- NOTE: `opts={}` is the same as calling `require("fidget").setup({})`
    { "j-hui/fidget.nvim", opts = {} },
  },
  config = function()
    -- Enable mason and configure icons
    require("mason").setup({
      ui = {
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗",
        },
      },
    })

    -- Ensured LSPs installed
    -- Configured in `~/.config/nvim/lsp/<lsp>.lua`
    require("mason-lspconfig").setup({
      ensure_installed = {
        "lua_ls",
        "pyright",
        "marksmen",
      },
    })

    require("mason-tool-installer").setup({
      ensure_installed = {
        "prettierd", -- prettier formatter
        "stylua", -- lua formatter
        "ruff", -- python formatter
        -- "isort", -- python formatter
        -- "black", -- python formatter
      },
    })
  end,
}
