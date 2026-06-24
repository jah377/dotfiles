-- Quarto (.qmd) filetype settings (overrides options.lua)

local set = vim.opt_local

vim.b.overlength_disabled = true

-- Spell: ]s/[s (next/prev), z= (suggest), zg (add to dict)
set.spell = true

set.shiftwidth = 2 -- Standard for nested lists

-- Treesitter-based folding (fold by heading)
set.foldmethod = "expr"
set.foldexpr = "v:lua.vim.treesitter.foldexpr()"

-- Autoformat on save stays enabled; conform.nvim handles quarto via injected + prettier.

-- quarto-nvim activates otter in its ftplugin, which can run before treesitter
-- has parsed fenced code blocks. Retry once when otter-ls did not attach.
local function otter_attached(bufnr)
  for _, client in ipairs(vim.lsp.get_clients({ bufnr = bufnr })) do
    if client.name:match("^otter%-ls") then
      return true
    end
  end
  return false
end

vim.defer_fn(function()
  local bufnr = vim.api.nvim_get_current_buf()
  if vim.bo[bufnr].filetype ~= "quarto" or otter_attached(bufnr) then
    return
  end

  require("quarto").activate()
end, 200)
