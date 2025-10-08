-- ================================================================================================
-- TITLE : Mason
--
-- ABOUT :
--
-- LINKS :
--   > github                  : https://github.com/neovim/nvim-lspconfig
--   > mason.nvim (dep)        : https://github.com/mason-org/mason.nvim
--   > cmp-nvim-lsp (dep)      : https://github.com/hrsh7th/cmp-nvim-lsp
--
-- FILES :
--   > lsp_servers/            : Contains server-specific setting files
--   > lsp_servers/init.lua    : Enables servers
--   > utils/on_attach.lua     : Configure buffer-local LSP setup
--   > utils/diagnostics.lua   : Configure LSP diagnostics
--
-- ================================================================================================

return {
  "williamboman/mason.nvim",
  dependencies = {
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
