-- lua/config/filetype/python_format.lua
--
-- formatexpr for Python buffers.
-- Wraps comment and string lines at textwidth; leaves code lines alone.
-- Called by vim on `gq` and auto-wrap (formatoptions `t`/`c`).
--
-- Return values (see :h formatexpr):
--   0  = handled (no-op) → vim does nothing → code lines are not wrapped
--   1  = not handled     → vim wraps at textwidth → comments/strings are wrapped

local M = {}

function M.formatexpr()
  local lnum = vim.v.lnum - 1 -- treesitter is 0-based
  local ok, node = pcall(vim.treesitter.get_node, { pos = { lnum, 0 }, ignore_injections = false })
  if not ok or not node then
    return 1 -- no parse tree yet; allow vim to wrap
  end

  while node do
    local t = node:type()
    -- Match comment nodes and any string-related nodes (string, string_content,
    -- string_start, string_end, concatenated_string, etc.)
    if t == "comment" or t:find "string" then
      return 1 -- let vim wrap at textwidth
    end
    node = node:parent()
  end

  return 0 -- inside code; suppress wrapping
end

return M
