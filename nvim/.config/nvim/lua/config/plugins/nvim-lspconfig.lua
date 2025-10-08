-- ================================================================================================
-- TITLE : nvim-lspconfig
--
-- ABOUT : Quickstart configurations for the built-in Neovim LSP client.
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
-- NOTES :
--   > to view installation instructions -> :help lspconfig-all
--   > to confirm nvim sees lsp -> :echo executable("lua-language-server")
--
-- ================================================================================================

return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    { "mason-org/mason.nvim", opts = {} }, -- LSP/DAP/Linter installer & manager
    "hrsh7th/cmp-nvim-lsp", -- nvim-cmp source for LSP-based completion
    "nvim-telescope/telescope.nvim", -- used by helpers.on_attach
    "mason-org/mason-lspconfig.nvim", -- used to install LSP tools
  },

  config = function()
    local diagnostics = require("config.plugins.lsp.helpers.diagnostics")
    local on_attach_config = require("config.plugins.lsp.helpers.on_attach")
    local mason_lsp = require("mason-lspconfig")
    local capabilities = require("cmp_nvim_lsp").default_capabilities()

    -- Desired servers
    -- See: 'plugins/lsp/<server>.lua' for custom configuration
    local servers = {
      "lua_la",
      "pyright",
      "marksmen",
    }

    mason_lsp.setup({ ensure_installed = servers })

    -- Extend 'nvim-lspconfig' server config with customizations
    for _, server_name in ipairs(servers) do
      local server_config = {
        on_attach = on_attach_config.on_attach,
        capabilities = capabilities,
      }

      -- Concat custom settings from 'lsp/<server>.lua', if exists
      local has_custom_config, custom_config = pcall(require, "config.plugins.lsp." .. server_name)
      if has_custom_config then
        server_config = vim.tbl_extend("force", server_config, custom_config)
        print(server_config)
      end

      vim.lsp.config(server_name, server_config)
    end

    -- Setup diagnostics
    diagnostics.setup()

    -- Enable LSP servers
    vim.lsp.enable(servers)
  end,
}
