-- =============================================================================
-- FILE: lua/config/lib/quarto_extras.lua
-- MODULE: require("config.lib.quarto_extras")
-- Navigate and edit code cells in .qmd (Quarto markdown) buffers. Used by
-- plugins/notebook/molten.lua for buffer-local keymaps.
--
-- A cell is a fenced block whose opening fence carries a language in braces:
-- ```{python}
-- code
-- ```
-- Rows in this module are 1-based (cursor API). nvim_buf_get_lines and
-- nvim_buf_set_lines take 0-based, end-exclusive ranges; comments mark the
-- conversions.
-- =============================================================================

local quarto_extras = {}

local FENCE_OPEN = "^```{"
local FENCE_CLOSE = "^```%s*$"

-- Inserted by insert_cell_* and run_cell_and_advance: blank separator,
-- opening fence, one empty content line, closing fence. The cursor lands on
-- the content line, CELL_TEMPLATE_CURSOR_OFFSET rows below the insertion row.
local CELL_TEMPLATE = { "", "```{python}", "", "```" }
local CELL_TEMPLATE_CURSOR_OFFSET = 3

--- @param message string
local function warn(message)
    vim.notify(message, vim.log.levels.WARN)
end

--- Row of the first content line of the next cell after `row`, or nil.
--- Searches from the line after `row`, so the current fence is never
--- re-matched. Shared by goto_next_cell and run_cell_and_advance, which used
--- to carry one copy each of this loop.
--- @param row integer 1-based cursor row
--- @return integer|nil
local function next_cell_content_row(row)
    local total = vim.api.nvim_buf_line_count(0)
    local lines_below = vim.api.nvim_buf_get_lines(0, row, -1, false) -- rows row+1 .. total
    for i, line in ipairs(lines_below) do
        if line:match(FENCE_OPEN) then
            local fence_row = row + i
            return math.min(fence_row + 1, total)
        end
    end
    return nil
end

--- Boundaries of the cell containing `row`.
--- @param row integer 1-based cursor row
--- @param opts { silent: boolean }|nil silent suppresses the warning
--- @return integer|nil cell_start row of the opening fence
--- @return integer|nil cell_end row of the closing fence
local function find_cell_boundaries(row, opts)
    opts = opts or {}
    local function fail(message)
        if not opts.silent then warn(message) end
        return nil
    end

    local lines_above = vim.api.nvim_buf_get_lines(0, 0, row, false) -- rows 1 .. row
    local cell_start
    for i = #lines_above, 1, -1 do
        if lines_above[i]:match(FENCE_OPEN) then
            cell_start = i
            break
        end
    end
    if not cell_start then return fail("Not inside a code cell") end

    local lines_below = vim.api.nvim_buf_get_lines(0, cell_start, -1, false) -- rows cell_start+1 .. total
    local cell_end
    for i, line in ipairs(lines_below) do
        if line:match(FENCE_CLOSE) then
            cell_end = cell_start + i
            break
        end
    end
    if not cell_end then return fail("Could not find end of code cell") end

    -- The nearest opening fence above may belong to a cell that already closed
    if cell_end < row then return fail("Not inside a code cell") end

    return cell_start, cell_end
end

--- Jump to the first content line of the next cell.
function quarto_extras.goto_next_cell()
    local row = vim.api.nvim_win_get_cursor(0)[1]
    local target = next_cell_content_row(row)
    if not target then
        warn("No next cell")
        return
    end
    vim.api.nvim_win_set_cursor(0, { target, 0 })
end

--- Jump to the first content line of the previous cell.
---
--- DECISION: from prose between cells, "previous" means the cell just above,
--- mirroring goto_next_cell. Only when the cursor is inside a cell is that
--- cell's own fence skipped. The earlier implementation always skipped the
--- nearest fence, which jumped one cell too far from prose and did not move
--- at all from an opening fence.
function quarto_extras.goto_prev_cell()
    local row = vim.api.nvim_win_get_cursor(0)[1]
    local current_cell_start = find_cell_boundaries(row, { silent = true })
    -- Search strictly above the current cell's fence, or above the cursor
    local search_end = current_cell_start and current_cell_start - 1 or row - 1

    local lines = vim.api.nvim_buf_get_lines(0, 0, search_end, false) -- rows 1 .. search_end
    for i = #lines, 1, -1 do
        if lines[i]:match(FENCE_OPEN) then
            vim.api.nvim_win_set_cursor(0, { i + 1, 0 })
            return
        end
    end
    warn("No previous cell")
end

--- Visually select the content lines of the current cell.
function quarto_extras.select_cell_contents()
    local row = vim.api.nvim_win_get_cursor(0)[1]
    local cell_start, cell_end = find_cell_boundaries(row)
    if not (cell_start and cell_end) then return end

    local content_start = cell_start + 1
    local content_end = cell_end - 1
    if content_start > content_end then
        warn("Code cell is empty")
        return
    end

    vim.api.nvim_win_set_cursor(0, { content_start, 0 })
    vim.cmd("normal! V")
    vim.api.nvim_win_set_cursor(0, { content_end, 0 })
end

--- Replace the content of the current cell with one empty line, keeping the fences.
function quarto_extras.delete_current_cell_contents()
    local row = vim.api.nvim_win_get_cursor(0)[1]
    local cell_start, cell_end = find_cell_boundaries(row)
    if not (cell_start and cell_end) then return end

    -- 0-based, end-exclusive: rows cell_start+1 .. cell_end-1 are the content
    vim.api.nvim_buf_set_lines(0, cell_start, cell_end - 1, false, { "" })
    vim.api.nvim_win_set_cursor(0, { cell_start + 1, 0 })
end

--- Delete the current cell including both fences.
function quarto_extras.delete_current_cell()
    local row = vim.api.nvim_win_get_cursor(0)[1]
    local cell_start, cell_end = find_cell_boundaries(row)
    if not (cell_start and cell_end) then return end

    vim.api.nvim_buf_set_lines(0, cell_start - 1, cell_end, false, {}) -- rows cell_start .. cell_end
    local total = vim.api.nvim_buf_line_count(0)
    vim.api.nvim_win_set_cursor(0, { math.min(cell_start, total), 0 })
end

--- Insert CELL_TEMPLATE after row `after_row` and start insert mode on the
--- new content line.
--- @param after_row integer 1-based row; 0 inserts at the top of the buffer
local function insert_cell_after(after_row)
    vim.api.nvim_buf_set_lines(0, after_row, after_row, false, CELL_TEMPLATE)
    vim.api.nvim_win_set_cursor(0, { after_row + CELL_TEMPLATE_CURSOR_OFFSET, 0 })
    vim.cmd("startinsert")
end

--- Insert a new cell below the current cell, or below the cursor when outside a cell.
function quarto_extras.insert_cell_below()
    local row = vim.api.nvim_win_get_cursor(0)[1]
    local _, cell_end = find_cell_boundaries(row, { silent = true })
    insert_cell_after(cell_end or row)
end

--- Insert a new cell above the current cell, or above the cursor when outside a cell.
function quarto_extras.insert_cell_above()
    local row = vim.api.nvim_win_get_cursor(0)[1]
    local cell_start = find_cell_boundaries(row, { silent = true })
    insert_cell_after((cell_start or row) - 1)
end

--- Run the current cell with quarto.runner, then move to the next cell,
--- creating one after the current cell when none exists.
function quarto_extras.run_cell_and_advance()
    local ok, runner = pcall(require, "quarto.runner")
    if not ok then
        vim.notify("quarto.runner is not available", vim.log.levels.ERROR)
        return
    end
    runner.run_cell()

    local row = vim.api.nvim_win_get_cursor(0)[1]
    local target = next_cell_content_row(row)
    if target then
        vim.api.nvim_win_set_cursor(0, { target, 0 })
        return
    end

    -- No next cell: append one after the current cell. One silent lookup
    -- replaces the earlier non-silent one, which produced two warnings when
    -- the cursor was outside any cell.
    local _, cell_end = find_cell_boundaries(row, { silent = true })
    if not cell_end then
        warn("Not inside a code cell; nothing to advance from")
        return
    end
    vim.api.nvim_buf_set_lines(0, cell_end, cell_end, false, CELL_TEMPLATE)
    vim.api.nvim_win_set_cursor(0, { cell_end + CELL_TEMPLATE_CURSOR_OFFSET, 0 })
end

--- Restart the first running Molten kernel. The bang clears all outputs.
function quarto_extras.restart_kernel()
    local ok, kernels = pcall(vim.fn.MoltenRunningKernels, true)
    if not ok then
        vim.notify("Molten is not loaded. Run :UpdateRemotePlugins and restart Neovim", vim.log.levels.ERROR)
        return
    end
    if #kernels == 0 then
        warn("No active kernel")
        return
    end
    vim.cmd({ cmd = "MoltenRestart", args = { kernels[1] }, bang = true })
end

--- Replace the language inside the braces of the current cell's opening fence.
function quarto_extras.replace_block_lang()
    local row = vim.api.nvim_win_get_cursor(0)[1]
    local cell_start = find_cell_boundaries(row)
    if not cell_start then return end

    vim.api.nvim_win_set_cursor(0, { cell_start, 0 })
    vim.cmd("normal! 0f{di{") -- jump to `{`, delete inside the braces
    vim.cmd("startinsert")
end

return quarto_extras
