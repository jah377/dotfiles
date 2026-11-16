-- =============================================================================
-- FILE: lua/config/lib/lazy_ft.lua
-- MODULE: require("config.lib.lazy_ft")
--
-- Attach buffer-local setup to filetypes, even when lazy-loading a plugin
-- after some buffers have already been opened.
--
-- PROBLEM:
--   When a lazy.nvim plugin loads on-demand, its config() function typically
--   sets up a FileType autocmd to initialize buffers of that filetype. But if
--   buffers of that type already exist when the plugin loads (e.g., `nvim
--   file1.qmd file2.qmd`, session restore, hidden splits), their FileType
--   events have already fired and won't trigger the autocmd.
--
-- SOLUTION:
--   Register the FileType autocmd for future buffers, then scan all currently
--   loaded buffers and run setup on any that match the filetype pattern.
-- =============================================================================

local lazy_ft = {}

--- Run on_buf for every loaded buffer matching pattern, and for every future
--- FileType event matching it. The replay and the scan may both hit the
--- triggering buffer, so on_buf must be idempotent: keymaps and buffer
--- variables are; autocmds need a per-buffer augroup.
--- @param group string augroup name; cleared, so calling twice does not stack autocmds
--- @param pattern string|string[] filetype(s)
--- @param on_buf fun(bufnr: integer)
function lazy_ft.on_filetypes(group, pattern, on_buf)
    assert(type(group) == "string", "group must be an augroup name")
    assert(type(on_buf) == "function", "on_buf must be a function")

    vim.api.nvim_create_autocmd("FileType", {
        pattern = pattern,
        group = vim.api.nvim_create_augroup(group, { clear = true }),
        callback = function(event) on_buf(event.buf) end,
    })

    local wanted_filetypes = {}
    local patterns = type(pattern) == "table" and pattern or { pattern }
    for _, filetype in ipairs(patterns) do
        wanted_filetypes[filetype] = true
    end
    for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
        if vim.api.nvim_buf_is_loaded(bufnr) and wanted_filetypes[vim.bo[bufnr].filetype] then on_buf(bufnr) end
    end
end

return lazy_ft
