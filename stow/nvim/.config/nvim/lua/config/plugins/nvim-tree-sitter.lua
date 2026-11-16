-- =============================================================================
-- FILE: lua/config/plugins/nvim-tree-sitter.lua
-- Parser installation (nvim-treesitter `main` branch). Highlighting and
-- folding are Neovim built-ins; this spec installs parsers and starts the
-- highlighter for filetypes Neovim does not auto-enable.
--
-- MAIN-BRANCH API (differs from the archived `master` branch):
--   setup() accepts only `install_dir`. Parsers are installed with
--   require("nvim-treesitter").install({...}), which is asynchronous and a
--   no-op when everything is present. The old `ensure_installed`,
--   `sync_install` and `auto_install` keys are silently ignored, which is how
--   an earlier revision of this file installed nothing at all.
--
-- USEFUL COMMANDS:
--  > :checkhealth nvim-treesitter : verify installation and parsers
--  > :Inspect                     : highlight groups at cursor
--  > :TSUpdate                    : update all parsers
--  > :TSInstall <lang>            : install one parser
--
-- Incremental node selection (built-in, visual mode):
--   an : select parent (outer) node, expand selection
--   in : select child (inner) node, shrink selection
-- =============================================================================

local PARSERS = {
    "bash",
    "comment",
    "dockerfile",
    "json",
    "kitty",
    "lua",
    "markdown",
    "markdown_inline",
    "python",
    "query",
    "regex",
    "toml",
    "vim",
    "vimdoc",
    "yaml",
}

return {
    "nvim-treesitter/nvim-treesitter",
    event = { "BufReadPre", "BufNewFile" },
    branch = "main",
    build = ":TSUpdate",

    config = function()
        local treesitter = require("nvim-treesitter")
        treesitter.setup({}) -- default install_dir
        treesitter.install(PARSERS) -- async; no-op for parsers already installed

        -- zsh has no parser of its own; bash is close enough
        vim.treesitter.language.register("bash", "zsh")

        -- Neovim only auto-starts the highlighter for bundled languages (lua,
        -- markdown, vimdoc, query). Start it for every filetype that has a
        -- parser; language.add() reports a missing parser instead of raising.
        vim.api.nvim_create_autocmd("FileType", {
            desc = "Start treesitter highlighting when a parser exists",
            group = vim.api.nvim_create_augroup("TreesitterStartGroup", { clear = true }),
            callback = function(event)
                local lang = vim.treesitter.language.get_lang(event.match) or event.match
                if vim.treesitter.language.add(lang) then vim.treesitter.start(event.buf, lang) end
            end,
        })
    end,
}
