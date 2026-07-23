-- Quarto (.qmd) filetype settings (overrides options.lua)

local set = vim.opt_local

-- Mirrors `ftplugin/markdown.lua`; autoformat is intentionally NOT disabled here
-- because conform.nvim handles quarto via injected languages + prettier.
vim.b.overlength_disabled = true -- See `autocmds.lua`
set.spell = true
set.shiftwidth = 2

-- Folding ----------------------------------------------------------------------------------

set.foldmethod = "expr"

-- Override treesitter fold query to only fold ATX heading sections (#, ##, etc.)
-- Targets "quarto" parser (not "markdown") because quarto files use a distinct parser.
-- nvim-treesitter's default folds.scm also folds code blocks and lists; this replaces it.
vim.treesitter.query.set("quarto", "folds", "((section (atx_heading)) @fold)")

-- vim.treesitter.foldexpr() evaluates ALL parsers including injected ones (Python, R, etc.),
-- creating unwanted folds inside code blocks (e.g. multi-line function args). This wrapper
-- checks only the top-level quarto tree; lines inside a fenced_code_block return "=" (inherit
-- level) to suppress injected-language folds.
_G.__quarto = _G.__quarto or {}
_G.__quarto.foldexpr = function()
  local lnum = vim.v.lnum
  local buf = vim.api.nvim_get_current_buf()
  local node = vim.treesitter.get_node({ bufnr = buf, pos = { lnum - 1, 0 }, ignore_injections = true })
  while node do
    local t = node:type()
    if t == "fenced_code_block" or t == "list" then return "=" end
    node = node:parent()
  end
  return vim.treesitter.foldexpr(lnum)
end

set.foldexpr = "v:lua.__quarto.foldexpr()"

-- quarto-nvim activates otter in its ftplugin, which can run before treesitter
-- has parsed fenced code blocks. Retry once when otter-ls did not attach.
local function otter_attached(bufnr)
  for _, client in ipairs(vim.lsp.get_clients { bufnr = bufnr }) do
    if client.name:match "^otter%-ls" then return true end
  end
  return false
end

vim.defer_fn(function()
  local bufnr = vim.api.nvim_get_current_buf()
  if vim.bo[bufnr].filetype ~= "quarto" or otter_attached(bufnr) then return end

  require("quarto").activate()
end, 200)
