-- =============================================================================
-- FILE: lua/config/plugins/mason.lua
--
-- PURPOSE:
--   Mason + mason-lspconfig install LSP servers and enable them through
--   nvim-lspconfig. Client capabilities shared by every server are set here
--   too, because this is the one place that runs before any server attaches.
--
-- HOW TO ADD A SERVER:
--   1. Add its Mason name to ensure_installed below (:Mason lists names)
--   2. :Lazy sync installs it; mason-lspconfig enables it automatically
--   3. Per-server overrides go in after/lsp/<server>.lua (:help lsp-config)
--
-- RELATED FILES:
--   - plugins/mason-tool-installer.lua : formatters (non-LSP tools)
--   - plugins/lazydev.lua              : lua_ls setup for Neovim config files
--   - lsp/diagnostics.lua, lsp/keymaps.lua
--
-- DOCUMENTATION:
--   > mason.nvim      : https://github.com/williamboman/mason.nvim
--   > mason-lspconfig : https://github.com/williamboman/mason-lspconfig.nvim
--   > nvim-lspconfig  : https://github.com/neovim/nvim-lspconfig
--   > fidget.nvim     : https://github.com/j-hui/fidget.nvim
-- =============================================================================

return {
    "williamboman/mason-lspconfig.nvim",
    event = { "BufReadPre", "BufNewFile" },

    dependencies = {
        -- Default server configurations; overridden per server in after/lsp/
        "neovim/nvim-lspconfig",

        -- The package manager itself. `opts` makes lazy.nvim call setup(),
        -- which must happen before mason-lspconfig initialises.
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

        -- LSP progress messages in the bottom-right corner
        { "j-hui/fidget.nvim", opts = {} },

        -- Completion capabilities advertised to servers (consumed in config).
        -- Its after/plugin file requires "cmp", so nvim-cmp loads here as
        -- well, before the first server attaches; nvim-cmp's own InsertEnter
        -- trigger only matters for buffers without an LSP.
        "hrsh7th/cmp-nvim-lsp",
    },

    opts = {
        -- Names must match Mason's registry (:Mason)
        ensure_installed = {
            "lua_ls", -- Lua (this config)
            "pyright", -- Python
            "marksman", -- Markdown
            "yamlls", -- YAML
        },
    },

    config = function(_, opts)
        -- Capabilities for every server ("*"), set BEFORE mason-lspconfig calls
        -- vim.lsp.enable(), so no server can attach with the defaults.
        local capabilities = require("cmp_nvim_lsp").default_capabilities()

        -- Offer UTF-16 as the only position encoding. Neovim advertises
        -- utf-8/16/32 by default and lets each server pick, which made pyright
        -- (utf-16) and ruff (utf-8) disagree in the same buffer and triggered
        -- "multiple different client offset_encodings" warnings. Every server
        -- used here supports utf-16, the encoding the LSP spec makes
        -- mandatory. vim.tbl_deep_extend replaces lists rather than merging
        -- them, so this assignment is total.
        capabilities.general = capabilities.general or {}
        capabilities.general.positionEncodings = { "utf-16" }

        vim.lsp.config("*", { capabilities = capabilities })

        require("mason-lspconfig").setup(opts)
    end,
}
