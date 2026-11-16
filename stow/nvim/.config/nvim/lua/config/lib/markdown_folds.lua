-- =============================================================================
-- FILE: lua/config/lib/markdown_folds.lua
-- MODULE: require("config.lib.markdown_folds")
--
-- Heading-only treesitter folds for markdown and quarto buffers.
--
-- PROBLEM 1: DEFAULT FOLDS ARE TOO AGGRESSIVE
--   nvim-treesitter's default markdown folds query folds every (section),
--   including the headingless body below front matter, plus code blocks and
--   lists. You want folds based only on ATX headings.
--
-- PROBLEM 2: FOLDEXPR DESCENDS INTO INJECTED PARSERS
--   vim.treesitter.foldexpr() descends into injected parsers (YAML, Python, R,
--   ...), creating unwanted folds inside front matter and fenced code blocks.
--   Those sections should inherit their enclosing fold level.
--
-- SOLUTION:
--   Register a custom folds query that targets ATX heading sections only. Wrap
--   foldexpr() to detect and suppress folds in front matter and code blocks by
--   returning "=" (inherit enclosing fold level).
--
-- Note: quarto-nvim registers the markdown grammar for filetype=quarto, so one
-- "markdown" query serves both filetypes.
-- =============================================================================

local markdown_folds = {}

local FOLDS_QUERY = "((section (atx_heading)) @fold)"

local HEADING_MARKER_QUERY = [[
  [
    (atx_h1_marker)
    (atx_h2_marker)
    (atx_h3_marker)
    (atx_h4_marker)
    (atx_h5_marker)
    (atx_h6_marker)
  ] @marker
]]

-- Node types whose lines must not open folds of their own
local SUPPRESSED_NODE_TYPES = {
    fenced_code_block = true,
    list = true,
    minus_metadata = true, -- YAML front matter (---)
    plus_metadata = true, -- TOML front matter (+++)
}

-- <localleader>z1 .. z<N> fold to heading level 1 .. N
local MAX_FOLD_KEYMAP_LEVEL = 4

-- Reused across foldexpr calls; fold computation is not re-entrant, so one
-- table is safe and avoids an allocation per line.
local get_node_opts = {
    pos = { 0, 0 },
    ignore_injections = true,
}

--- 'foldexpr' callback. Referenced by module path from setup(), so it must be
--- a public function on the module table.
--- @return string|integer fold level for vim.v.lnum
function markdown_folds.foldexpr()
    local lnum = vim.v.lnum
    get_node_opts.pos[1] = lnum - 1 -- treesitter rows are 0-based
    local node = vim.treesitter.get_node(get_node_opts)
    while node do
        if SUPPRESSED_NODE_TYPES[node:type()] then return "=" end
        node = node:parent()
    end
    return vim.treesitter.foldexpr(lnum)
end

--- Fold to one level below the deepest heading, eg. a document whose deepest
--- heading is H3 opens with H1 and H2 visible.
local function set_foldlevel_below_deepest_heading()
    local parser = vim.treesitter.get_parser(0, "markdown", { error = false })
    if not parser then return end -- no markdown parser; keep foldlevel from options.lua
    local tree = parser:parse()[1]
    if not tree then return end
    local query = vim.treesitter.query.parse("markdown", HEADING_MARKER_QUERY)

    local max_level = 0
    for _, node in query:iter_captures(tree:root(), 0) do
        local level = tonumber(node:type():match("atx_h(%d)_marker"))
        max_level = math.max(max_level, level)
    end

    if max_level > 0 then vim.opt_local.foldlevel = max_level - 1 end
end

--- Enable heading folds in the current buffer.
---
--- Idempotent by design: after/ftplugin runs on every FileType event for a
--- buffer, and lazy.nvim re-fires FileType when it loads an ft-triggered
--- plugin, so this runs more than once per buffer. Keymaps overwrite
--- themselves; the autocmd lives in a per-buffer augroup with clear = true so
--- the previous one is replaced instead of stacked.
function markdown_folds.setup()
    -- Registering the query is global and cheap (a one-line query); doing it
    -- unconditionally keeps this module free of mutable state.
    vim.treesitter.query.set("markdown", "folds", FOLDS_QUERY)

    local bufnr = vim.api.nvim_get_current_buf()
    vim.opt_local.foldmethod = "expr"
    vim.opt_local.foldexpr = "v:lua.require'config.lib.markdown_folds'.foldexpr()"

    vim.api.nvim_create_autocmd("BufWinEnter", {
        desc = "Open markdown folds one level below the deepest heading",
        group = vim.api.nvim_create_augroup("MarkdownFoldsGroup" .. bufnr, { clear = true }),
        buffer = bufnr,
        callback = set_foldlevel_below_deepest_heading,
    })

    for level = 1, MAX_FOLD_KEYMAP_LEVEL do
        local heading = string.rep("#", level)
        vim.keymap.set("n", "<localleader>z" .. level, "<cmd>setlocal foldlevel=" .. (level - 1) .. "<CR>", {
            buffer = bufnr,
            desc = "Fold to " .. heading .. " headings",
        })
    end
end

return markdown_folds
