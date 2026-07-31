-- Shared markdown/quarto heading folds.
--
-- Default markdown folds.scm folds every (section), including body below front
-- matter with no heading. nvim-treesitter also folds code blocks and lists.
-- This query folds only ATX heading sections.
--
-- vim.treesitter.foldexpr() walks injected parsers (YAML, Python, R, …), which
-- creates folds inside front matter and fenced code. The wrapper uses
-- ignore_injections and returns "=" inside suppressed nodes so those lines
-- inherit the outer fold level.
--
-- quarto-nvim registers the markdown grammar for filetype=quarto, so the folds
-- query targets "markdown" for both filetypes.

local FOLDS_QUERY = "((section (atx_heading)) @fold)"

local SUPPRESS = {
  fenced_code_block = true,
  list = true,
  minus_metadata = true,
  plus_metadata = true,
}

-- Reused across foldexpr calls (not re-entrant in normal fold compute).
local get_node_opts = {
  pos = { 0, 0 },
  ignore_injections = true,
}

local query_set = false

local M = {}

function M.foldexpr()
  local lnum = vim.v.lnum
  get_node_opts.pos[1] = lnum - 1
  local node = vim.treesitter.get_node(get_node_opts)
  while node do
    if SUPPRESS[node:type()] then
      return "="
    end
    node = node:parent()
  end
  return vim.treesitter.foldexpr(lnum)
end

function M.setup()
  if not query_set then
    vim.treesitter.query.set("markdown", "folds", FOLDS_QUERY)
    query_set = true
  end
  vim.opt_local.foldmethod = "expr"
  vim.opt_local.foldexpr = "v:lua.require'config.core.markdown_folds'.foldexpr()"
end

return M
