-- =============================================================================
-- FILE: lua/config/plugins/lsp/mason.lua
--
-- PURPOSE:
--   Configures Mason and mason-lspconfig, which together provide automatic
--   installation and configuration of LSP (Language Server Protocol) servers,
--   Formatters, Linters (code analysis), and DAP servers for debugging.
--
-- HOW TO ADD MORE SERVERS:
--   1. Add the server name to ensure_installed list below
--   2. Run :Lazy sync to trigger installation
--   3. Server will auto-configure via mason-lspconfig
--
-- RELATED FILES:
--   - mason-tool-installer.lua : Installs formatters/linters (non-LSP tools)
--
-- DOCUMENTATION:
--   > mason.nvim        : https://github.com/williamboman/mason.nvim
--   > mason-lspconfig   : https://github.com/williamboman/mason-lspconfig.nvim
--   > nvim-lspconfig    : https://github.com/neovim/nvim-lspconfig
--   > fidget.nvim       : https://github.com/j-hui/fidget.nvim
--   > lazydev.nvim      : https://github.com/folke/lazydev.nvim
--
-- =============================================================================

return {
  {
    -- Auto-configures LSP servers after Mason installs them.
    "williamboman/mason-lspconfig.nvim",
    event = { "BufReadPre", "BufNewFile" },

    opts = {
      -- List of LSP servers to install automatically.
      -- Names must match Mason's server registry.
      -- Run :Mason to see available servers.
      ensure_installed = {
        "lua_ls", -- Lua language server (for Neovim config)
        "pyright", -- Python language server (Microsoft's implementation)
        "marksman", -- Markdown language server
      },
    },

    -- Custom setup function (runs after opts is applied)
    config = function(_, opts)
      -- Initialize mason-lspconfig with our options
      require("mason-lspconfig").setup(opts)

      -- Get completion capabilities from nvim-cmp.
      -- This tells LSP servers what completion features Neovim supports.
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      -- Apply these capabilities to ALL LSP servers.
      -- The "*" pattern means this applies to every server.
      vim.lsp.config("*", { capabilities = capabilities })
    end,

    dependencies = {
      -- nvim-lspconfig provides default configurations for LSP servers.
      -- Without this, you'd have to manually configure each server.
      -- To override defaults, add config files in .config/nvim/after/lsp/
      "neovim/nvim-lspconfig",

      -- Mason itself - the package manager.
      -- opts = {} triggers lazy.nvim to run setup() with empty config,
      -- which must happen before mason-lspconfig initializes.
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

      -- fidget.nvim shows LSP progress in the bottom corner of your screen.
      { "j-hui/fidget.nvim", opts = {} },

      -- cmp-nvim-lsp provides completion capabilities for nvim-cmp.
      "hrsh7th/cmp-nvim-lsp",

      -- lazydev.nvim configures lua_ls specifically for Neovim development.
      -- It makes lua_ls understand vim.*, require(), etc.
      {
        "folke/lazydev.nvim",
        ft = "lua", -- Only load for Lua files
        opts = {
          library = {
            -- Make lua_ls understand vim.uv (libuv bindings)
            -- path = "${3rd}/luv/library" loads type definitions
            -- words = { "vim%.uv" } tells it when to load them
            { path = "${3rd}/luv/library", words = { "vim%.uv" } },
          },
        },
      },
    },
  },
}
