-- ================================================================================================
-- TITLE : Mason
--
-- ABOUT : Package manager for LSP tooling
--
-- LINKS :
--   > nvim-lspconfig.nvim (dep) : https://github.com/neovim/nvim-lspconfig
--   > mason.nvim (dep)          : https://github.com/mason-org/mason.nvim
--   > fidget.nvim (dep)         : https://github.com/j-hui/fidget.nvim
--   > cmp-nvim-lsp (dep)        : https://github.com/hrsh7th/cmp-nvim-lsp
--   > lazydev.nvim (dep)        : https://github.com/folke/lazydev.nvim
--
-- ================================================================================================

return {
  {
    -- Automatically install and enable LSP servers
    "williamboman/mason-lspconfig.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      ensure_installed = {
        "lua_ls",
        "pyright",
        "marksman",
      },
    },
    config = function(_, opts)
      require("mason-lspconfig").setup(opts)

      -- Enable auto-completion across all LSP servers
      local capabilities = require("cmp_nvim_lsp").default_capabilities()
      vim.lsp.config("*", { capabilities = capabilities })
    end,
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

      -- LSP completion capabilities
      "hrsh7th/cmp-nvim-lsp",

      -- Configure lua-ls for editing nvim config
      {
        "folke/lazydev.nvim",
        ft = "lua",
        opts = {
          library = {
            { path = "${3rd}/luv/library", words = { "vim%.uv" } },
          },
        },
      },
    },
  },
}
