-- ================================================================================================
-- TITLE : cmp-nvim-lsp
--
-- ABOUT : Completion for built-in language server client
--
-- LINKS :
--   > mason.nvim (dep)   : https://github.com/mason-org/mason.nvim
--   > lazydev.nvim (dep) : https://github.com/folke/lazydev.nvim
--
-- RELATED FILES :
--   > mason.lua        : Completion for built-in language server client
--
-- ================================================================================================

return {
  "hrsh7th/cmp-nvim-lsp",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    -- Configure lua-ls for editing nvim config
    { "folke/lazydev.nvim",
        -- Only load on lua files
        ft = "lua",
        opts = {
          library = {
            -- See the configuration section for more details
            -- Load luvit types when the `vim.uv` word is found
            { path = "${3rd}/luv/library", words = { "vim%.uv" } },
          },
          enable = true,
  },
  }},
  config = function()
    local cmp_nvim_lsp = require("cmp_nvim_lsp")
    local capabilities = cmp_nvim_lsp.default_capabilities()

    -- Enable auto-completion across all LSP servers
    vim.lsp.config("*", {
      capabilities = capabilities,
    })
  end,
}
