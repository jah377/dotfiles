-- =============================================================================
-- FILE: lua/config/plugins/lazydev.lua
-- lazydev.nvim teaches lua_ls about the Neovim runtime (vim.*, plugin
-- modules) when editing Lua.
--
-- LOADING:
--   A top-level spec so that `ft = "lua"` is honoured. It used to be listed
--   as a dependency of mason-lspconfig; lazy.nvim loads dependencies together
--   with their parent, which silently discarded the filetype trigger and
--   loaded it for every file.
--
-- DOCUMENTATION:
--   > GitHub : https://github.com/folke/lazydev.nvim
-- =============================================================================

return {
    "folke/lazydev.nvim",
    ft = "lua",
    opts = {
        library = {
            -- Load libuv type definitions only when `vim.uv` appears in the file
            { path = "${3rd}/luv/library", words = { "vim%.uv" } },
        },
    },
}
