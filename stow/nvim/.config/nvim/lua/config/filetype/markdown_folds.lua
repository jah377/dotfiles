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
    if SUPPRESS[node:type()] then return "=" end
    node = node:parent()
  end
  return vim.treesitter.foldexpr(lnum)
end

-- Fold to one level below the deepest heading (eg. max heading H3 -> show H1-H2)
local function set_foldlevel_below_deepest_heading()
  local parser = vim.treesitter.get_parser(0, "markdown")
  local root = parser:parse()[1]:root()
  local query = vim.treesitter.query.parse("markdown", HEADING_MARKER_QUERY)

  local max_level = 0
  for _, node in query:iter_captures(root, 0) do
    local level = tonumber(node:type():match "atx_h(%d)_marker")
    max_level = math.max(max_level, level)
  end

  if max_level > 0 then vim.opt_local.foldlevel = max_level - 1 end
end

function M.setup()
  if not query_set then
    vim.treesitter.query.set("markdown", "folds", FOLDS_QUERY)
    query_set = true
  end
  vim.opt_local.foldmethod = "expr"
  vim.opt_local.foldexpr = "v:lua.require'config.filetype.markdown_folds'.foldexpr()"

  vim.api.nvim_create_autocmd("BufWinEnter", {
    buffer = 0,
    callback = set_foldlevel_below_deepest_heading,
  })

  local opts = { buffer = 0 }
  vim.keymap.set(
    "n",
    "<localleader>z1",
    "<cmd>setlocal foldlevel=0<CR>",
    vim.tbl_extend("force", opts, { desc = "Fold to # header" })
  )
  vim.keymap.set(
    "n",
    "<localleader>z2",
    "<cmd>setlocal foldlevel=1<CR>",
    vim.tbl_extend("force", opts, { desc = "Fold to ## header" })
  )
  vim.keymap.set(
    "n",
    "<localleader>z3",
    "<cmd>setlocal foldlevel=2<CR>",
    vim.tbl_extend("force", opts, { desc = "Fold to ### header" })
  )
  vim.keymap.set(
    "n",
    "<localleader>z4",
    "<cmd>setlocal foldlevel=3<CR>",
    vim.tbl_extend("force", opts, { desc = "Fold to #### header" })
  )
end

return M
