-- =============================================================================
-- FILE: lua/config/plugins/custom/lazy_ft.lua
--
-- PURPOSE:
--   Attach buffer-local behaviour when a lazy.nvim spec's config() runs after
--   FileType has already fired. The FileType autocmd covers later buffers and
--   lazy's replay of the loader buf. The loaded-buffer scan covers hidden and
--   non-current buffers (nvim a.qmd b.qmd, session restore, a split).
--
-- =============================================================================

local M = {}

--- Run on_buf for already-loaded buffers matching pattern, and for future FileType.
--- FileType replay plus the scan may call on_buf twice for the loader buf;
--- on_buf must be idempotent.
---@param group string augroup name
---@param pattern string|string[]
---@param on_buf fun(bufnr: integer)
function M.on_filetypes(group, pattern, on_buf)
  vim.api.nvim_create_autocmd("FileType", {
    pattern = pattern,
    group = vim.api.nvim_create_augroup(group, { clear = true }),
    callback = function(ev)
      on_buf(ev.buf)
    end,
  })

  local want = {}
  for _, ft in ipairs(type(pattern) == "table" and pattern or { pattern }) do
    want[ft] = true
  end
  for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_loaded(bufnr) and want[vim.bo[bufnr].filetype] then on_buf(bufnr) end
  end
end

return M
