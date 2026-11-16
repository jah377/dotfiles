-- =============================================================================
-- FILE: lua/config/plugins/conform.lua
--
-- PURPOSE:
--   conform.nvim runs external formatters (stylua, ruff, prettier, ...) on
--   save and on demand. LSP formatting is only a fallback.
--
-- WHY CONFORM INSTEAD OF LSP FORMATTING?
--   - Any CLI formatter, not only what the language server offers
--   - Per-filetype chains with fallbacks
--   - One code path for format-on-save and range formatting (<leader>lf)
--
-- RELATED FILES:
--   - plugins/mason-tool-installer.lua : installs the formatter binaries
--   - plugins/mason.lua                : installs LSP servers (separate concern)
--   - after/ftplugin/markdown.lua      : sets vim.b.disable_autoformat
--
-- DOCUMENTATION:
--   > GitHub : https://github.com/stevearc/conform.nvim
-- =============================================================================

--- First formatter in `...` that is available for bufnr, else the first name
--- so conform reports the missing tool instead of silently skipping. This is
--- conform's documented recipe for "prettierd, else prettier". It is used
--- instead of `stop_after_first` because that flag applies to a whole chain,
--- and quarto needs `injected` to run as well as one prettier variant.
--- @param bufnr integer
--- @param ... string formatter names in order of preference
--- @return string
local function first_available(bufnr, ...)
    local conform = require("conform")
    for i = 1, select("#", ...) do
        local formatter = select(i, ...)
        if conform.get_formatter_info(formatter, bufnr).available then return formatter end
    end
    return (select(1, ...))
end

--- @param bufnr integer
--- @return string "prettierd" when its daemon can run, else "prettier"
local function prettier_for(bufnr) return first_available(bufnr, "prettierd", "prettier") end

return {
    "stevearc/conform.nvim",

    -- After the initial UI render; formatting is not needed before editing
    event = "VeryLazy",

    dependencies = {
        "WhoIsSethDaniel/mason-tool-installer.nvim", -- installs the tools below
        "williamboman/mason.nvim", -- puts Mason's bin directory on PATH
    },

    opts = {
        formatters_by_ft = {
            lua = { "stylua" },

            -- DECISION: isort stays alongside ruff. ruff's import sorting (the
            -- `I` rules) is off by default and must be enabled per project;
            -- isort sorts regardless, so dropping it would stop import sorting
            -- in every project that never opted in.
            python = {
                "isort", -- organise imports
                "ruff_fix", -- auto-fix lint findings
                "ruff_format", -- Black-compatible formatting
            },

            markdown = function(bufnr) return { prettier_for(bufnr) } end,

            -- injected: formats fenced {python} blocks with the python chain
            -- above via treesitter; prettier then formats the surrounding
            -- markdown. Only one prettier variant runs per save.
            quarto = function(bufnr) return { "injected", prettier_for(bufnr) } end,

            yaml = { "yamlfmt" },
        },

        -- Prettier does not infer a parser for .qmd. The two formatters expose
        -- different knobs: conform's prettier definition reads ext_parsers,
        -- while prettierd only takes raw CLI arguments.
        formatters = {
            prettier = {
                options = {
                    ext_parsers = { qmd = "markdown" },
                    ft_parsers = { quarto = "markdown" },
                },
            },
            prettierd = {
                prepend_args = function(_, ctx)
                    if vim.fn.fnamemodify(ctx.filename, ":e") == "qmd" then return { "--parser=markdown" } end
                end,
            },
        },

        -- Filetypes without a formatter above fall back to LSP formatting
        default_format_opts = {
            lsp_format = "fallback",
        },

        -- Returning nil skips format-on-save; buffers opt out with
        -- vim.b.disable_autoformat (after/ftplugin/markdown.lua).
        format_on_save = function(bufnr)
            if vim.b[bufnr].disable_autoformat then return end
            return { timeout_ms = 3000 } -- a slow formatter must not hang the write
        end,

        notify_on_error = true,
        notify_no_formatters = true, -- explains why nothing happened on save
    },
}
