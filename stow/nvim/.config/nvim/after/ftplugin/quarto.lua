-- Quarto (.qmd) filetype settings (overrides options.lua)

local set = vim.opt_local

-- Mirrors `ftplugin/markdown.lua`; autoformat is intentionally NOT disabled here
-- because conform.nvim handles quarto via injected languages + prettier.
vim.b.overlength_disabled = true -- See `autocmds.lua`
set.spell = true
set.shiftwidth = 2

require("config.core.markdown_folds").setup()

-- quarto-nvim activates otter in its ftplugin, which can run before treesitter
-- has parsed fenced code blocks. Retry once when otter-ls did not attach.
local function otter_attached(bufnr)
  for _, client in ipairs(vim.lsp.get_clients { bufnr = bufnr }) do
    if client.name:match "^otter%-ls" then return true end
  end
  return false
end

local bufnr = vim.api.nvim_get_current_buf()
if not otter_attached(bufnr) then
  vim.defer_fn(function()
    if not vim.api.nvim_buf_is_valid(bufnr) then return end
    if vim.bo[bufnr].filetype ~= "quarto" or otter_attached(bufnr) then return end

    vim.api.nvim_buf_call(bufnr, function()
      require("quarto").activate()
    end)
  end, 200)
end
