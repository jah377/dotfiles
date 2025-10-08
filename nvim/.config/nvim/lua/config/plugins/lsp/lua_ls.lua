-- ============================================================================
-- TITLE : lua_ls (Lua Language Server) LSP Setup
--
-- LINKS :
--   > github         : https://github.com/LuaLS/lua-language-server
--
-- NOTES :
--   See 'nvim-lspconfig' repo for more info about extending 'lua_ls' config
--   > https://github.com/neovim/nvim-lspconfig/blob/master/lsp/lua_ls.lua
--
-- =============================================================================

--- @return table
return {
  -- Defined by 'nvim-lspconfig'
  -- cmd = {...},
  -- filetypes = {...},
  -- root_markers = ...,

  -- Defined in 'plugins/nvim-lspconfig.lua'
  -- capabilities = ...,
  -- on_attach = ...,

  settings = {
    Lua = {
      -- Neovim is built on LuaJIT, not plain Lua 5.1/5.3
      runtime = { version = "LuaJIT" },

      diagnostics = { globals = { "vim" } },

      workspace = {
        -- Make server aware of runtime files
        library = vim.api.nvim_get_runtime_file("", true),
      },
      -- Opt out of sending telemetry data
      telemetry = { enable = false },
    },
  },
}
