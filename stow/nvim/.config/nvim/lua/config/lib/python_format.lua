-- =============================================================================
-- FILE: lua/config/lib/python_format.lua
-- MODULE: require("config.lib.python_format")
--
-- Custom text wrapping for Python: wrap comments and strings at textwidth,
-- but leave code lines alone.
--
-- PROBLEM:
--   Vim's default text wrapping (gq, formatoptions t/c) treats all lines the
--   same way. For Python code, you want docstrings and comments to wrap at
--   textwidth, but keep code lines unbroken.
--
-- SOLUTION:
--   Provide a formatexpr that uses treesitter to detect the node type at the
--   current line:
--   - If comment or string: return 1 (Vim wraps it)
--   - If code: return 0 (Vim leaves it alone)
--
-- See :h formatexpr for how Vim calls and interprets the expression.
-- =============================================================================

local python_format = {}

--- @return integer 0 to suppress wrapping, 1 to let Vim wrap
function python_format.formatexpr()
    local row = vim.v.lnum - 1 -- treesitter rows are 0-based
    local ok, node = pcall(vim.treesitter.get_node, { pos = { row, 0 }, ignore_injections = false })
    if not ok or not node then
        return 1 -- no parse tree yet; allow Vim to wrap
    end

    while node do
        local node_type = node:type()
        -- "comment" plus any string-related node: string, string_content,
        -- string_start, string_end, concatenated_string, ...
        if node_type == "comment" or node_type:find("string", 1, true) then return 1 end
        node = node:parent()
    end

    return 0 -- inside code; suppress wrapping
end

return python_format
