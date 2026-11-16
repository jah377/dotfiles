-- =============================================================================
-- FILE: lua/config/plugins/mason-tool-installer.lua
--
-- PURPOSE:
--   Installs non-LSP tools (formatters) through Mason so they exist on every
--   machine. LSP servers are installed by plugins/mason.lua instead.
--
-- TOOLS (consumer in brackets):
--   stylua    : Lua formatter                        [conform.lua]
--   ruff      : Python linter and formatter          [conform.lua]
--   isort     : Python import sorter                 [conform.lua]
--   prettierd : Prettier daemon for markdown/quarto  [conform.lua]
--   prettier  : Prettier, fallback when no daemon    [conform.lua]
--   yamlfmt   : YAML formatter                       [conform.lua]
--   yamllint was removed: nothing in this config runs it (yamlls provides
--   YAML diagnostics).
--
-- DOCUMENTATION:
--   > GitHub : https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim
--   > Mason  : https://github.com/williamboman/mason.nvim
-- =============================================================================

return {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    dependencies = { "williamboman/mason.nvim" },

    -- Start plugin (no event/keys): tools must exist before the first
    -- format-on-save.
    opts = {
        ensure_installed = {
            "stylua",
            "ruff",
            "isort",
            "prettierd",
            "prettier",
            "yamlfmt",
        },

        -- Install anything missing at startup, but never upgrade silently: a
        -- formatter update can change output in every project at once. Upgrade
        -- deliberately with :MasonToolsUpdate after reading the changelog.
        run_on_start = true,
        auto_update = false,
    },
}
