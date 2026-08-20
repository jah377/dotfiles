-- =============================================================================
-- FILE: lua/config/plugins/notebook/quarto.lua
--
-- PURPOSE:
--   .qmd filetype wiring, otter.nvim LSP for {python} blocks, and a one-shot
--   otter-ls retry when quarto-nvim activates before treesitter has parsed
--   fenced code blocks.
--
-- OTTER RETRY:
--   quarto-nvim activates otter on FileType before treesitter has parsed
--   {python} fences, so otter-ls can miss the buffer. Retry once after 200ms.
--   Lives next to lspFeatures so activate() runs after quarto.setup().
--   Coalesce FileType replay + loaded-buffer scan: two activate() calls in
--   the same window both see otter_attached == false (LSP attach is async).
--
-- NOTES:
--   - If .qmd syntax highlighting looks wrong: :TSInstall quarto
--   - Preview is intentionally not configured
--
-- DOCUMENTATION:
--   > otter.nvim   : https://github.com/jmbuhr/otter.nvim
--   > quarto-nvim  : https://github.com/quarto-dev/quarto-nvim
--
-- =============================================================================

-- otter.nvim names its client otter-ls-<lang>; match the prefix only.
local function otter_attached(bufnr)
  for _, client in ipairs(vim.lsp.get_clients { bufnr = bufnr }) do
    if client.name:match "^otter%-ls" then return true end
  end
  return false
end

-- One pending timer per buf. Guards inside the callback, not before defer,
-- so we observe attach state after treesitter has had time to parse.
local pending = {}

local function schedule_otter_retry(bufnr)
  if pending[bufnr] then return end
  pending[bufnr] = true
  vim.defer_fn(function()
    pending[bufnr] = nil
    if not vim.api.nvim_buf_is_valid(bufnr) then return end
    if vim.bo[bufnr].filetype ~= "quarto" or otter_attached(bufnr) then return end

    -- activate() reads the current buffer
    vim.api.nvim_buf_call(bufnr, function()
      require("quarto").activate()
    end)
  end, 200)
end

return {
  -- quarto-nvim: .qmd filetype wiring and otter.nvim integration.
  -- otter nested here so it is not a start plugin; it loads with quarto.
  {
    "quarto-dev/quarto-nvim",
    ft = "quarto",
    dependencies = {
      { "jmbuhr/otter.nvim", opts = {} },
      "nvim-treesitter/nvim-treesitter",
    },
    opts = {
      -- LSP features: activate pyright inside {python} blocks via otter.nvim
      lspFeatures = {
        languages = { "python" },
        chunks = "all",
        diagnostics = {
          enabled = true,
          -- Run diagnostics on save (not on every keystroke)
          triggers = { "BufWritePost" },
        },
        completion = {
          enabled = true,
        },
      },
      -- Cell execution delegates to molten-nvim
      codeRunner = {
        enabled = true,
        default_method = "molten",
      },
    },
    config = function(_, opts)
      require("quarto").setup(opts)
      require("config.plugins.custom.lazy_ft").on_filetypes("quarto-otter-retry", "quarto", schedule_otter_retry)
    end,
  },
}
