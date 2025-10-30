-- ================================================================================================
-- TITLE : Mason
--
-- ABOUT : Package manager for LSP tooling
--
-- LINKS :
--   > nvim-lspconfig.nvim (dep) : https://github.com/neovim/nvim-lspconfig
--   > mason.nvim (dep)          : https://github.com/mason-org/mason.nvim
--   > fidget.nvim (dep)         : https://github.com/j-hui/fidget.nvim
--
-- RELATED FILES :
--   > cmp-nvim-lsp.lua          : Completion for built-in language server client
--   > nvim/config/lsp.lua       : Configure 'on_attach' and diagnostics
--
-- ================================================================================================

return {
  {
    -- Automatically install and enable LSP servers
    "williamboman/mason-lspconfig.nvim",
    opts = {
      ensure_installed = {
        "lua_ls",
        "pyright",
        "marksman",
      },
    },
    dependencies = {
      -- Collection of LSP server configurations
      -- To overwrite defaults, add config files in '.config/nvim/after/lsp'
      "neovim/nvim-lspconfig",

      -- Package manager for LSP tooling
      -- 'opts={}' triggers Lazyvim to initialize package before 'mason-lspconfig'
      {
        "williamboman/mason.nvim",
        opts = {
          ui = {
            icons = {
              package_installed = "✓",
              package_pending = "➜",
              package_uninstalled = "✗",
            },
          },
        },
      },

      -- Useful status updates for LSP
      { "j-hui/fidget.nvim", opts = {} },
    },
  },
}
