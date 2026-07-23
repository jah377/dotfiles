-- =============================================================================
-- FILE: lua/config/plugins/custom/quarto_extras.lua
--
-- PURPOSE:
--   Utility functions for navigating and manipulating code cells in .qmd
--   (Quarto markdown) files. Used by molten.lua for buffer-local keymaps.
--
-- =============================================================================

local M = {}

local FENCE_OPEN = "^```{"
local FENCE_CLOSE = "^```%s*$"

-- Returns (cell_start, cell_end) as 1-based line numbers, or (nil, nil).
-- Warns unless opts.silent is set. Validates cursor is inside the found range.
local function find_cell_boundaries(row, opts)
  opts = opts or {}
  local lines_above = vim.api.nvim_buf_get_lines(0, 0, row, false)
  local cell_start = nil
  for i = #lines_above, 1, -1 do
    if lines_above[i]:match(FENCE_OPEN) then
      cell_start = i
      break
    end
  end

  if not cell_start then
    if not opts.silent then
      vim.notify("Not inside a code cell", vim.log.levels.WARN)
    end
    return nil, nil
  end

  local lines_below = vim.api.nvim_buf_get_lines(0, cell_start, -1, false)
  local cell_end = nil
  for i, line in ipairs(lines_below) do
    if line:match(FENCE_CLOSE) then
      cell_end = cell_start + i
      break
    end
  end

  if not cell_end then
    if not opts.silent then
      vim.notify("Could not find end of code cell", vim.log.levels.WARN)
    end
    return nil, nil
  end

  -- Verify cursor is actually inside the detected cell
  if cell_end < row then
    if not opts.silent then
      vim.notify("Not inside a code cell", vim.log.levels.WARN)
    end
    return nil, nil
  end

  return cell_start, cell_end
end

-- Searches from the line after the cursor so the current fence is never re-matched.
-- Lands on the first content line inside the next cell.
function M.goto_next_cell()
  local row = vim.api.nvim_win_get_cursor(0)[1]
  local total = vim.api.nvim_buf_line_count(0)
  local lines = vim.api.nvim_buf_get_lines(0, row, -1, false)
  for i, line in ipairs(lines) do
    if line:match(FENCE_OPEN) then
      vim.api.nvim_win_set_cursor(0, { math.min(row + i + 1, total), 0 })
      return
    end
  end
  vim.notify("No next cell", vim.log.levels.WARN)
end

-- Two-pass: pass 1 skips the current cell's opening fence, pass 2 finds the one before it.
function M.goto_prev_cell()
  local row = vim.api.nvim_win_get_cursor(0)[1]
  local lines = vim.api.nvim_buf_get_lines(0, 0, row - 1, false)

  local search_end = #lines
  for i = #lines, 1, -1 do
    if lines[i]:match(FENCE_OPEN) then
      search_end = i - 1
      break
    end
  end

  for i = search_end, 1, -1 do
    if lines[i]:match(FENCE_OPEN) then
      vim.api.nvim_win_set_cursor(0, { i + 1, 0 })
      return
    end
  end
  vim.notify("No previous cell", vim.log.levels.WARN)
end

function M.select_cell_contents()
  local row = vim.api.nvim_win_get_cursor(0)[1]
  local cell_start, cell_end = find_cell_boundaries(row)
  if not cell_start then return end

  local content_start = cell_start + 1
  local content_end = cell_end - 1

  if content_start > content_end then
    vim.notify("Code cell is empty", vim.log.levels.WARN)
    return
  end

  vim.api.nvim_win_set_cursor(0, { content_start, 0 })
  vim.cmd "normal! V"
  vim.api.nvim_win_set_cursor(0, { content_end, 0 })
end

function M.delete_current_cell_contents()
  local row = vim.api.nvim_win_get_cursor(0)[1]
  local cell_start, cell_end = find_cell_boundaries(row)
  if not cell_start then return end

  vim.api.nvim_buf_set_lines(0, cell_start, cell_end - 1, false, { "" })
  vim.api.nvim_win_set_cursor(0, { cell_start + 1, 0 })
end

function M.delete_current_cell()
  local row = vim.api.nvim_win_get_cursor(0)[1]
  local cell_start, cell_end = find_cell_boundaries(row)
  if not cell_start then return end

  vim.api.nvim_buf_set_lines(0, cell_start - 1, cell_end, false, {})
  local total = vim.api.nvim_buf_line_count(0)
  vim.api.nvim_win_set_cursor(0, { math.min(cell_start, total), 0 })
end

local CELL_TEMPLATE = { "", "```{python}", "", "```" }

function M.insert_cell_below()
  local row = vim.api.nvim_win_get_cursor(0)[1]
  local _, cell_end = find_cell_boundaries(row, { silent = true })

  -- If inside a cell, insert after closing fence; otherwise insert at cursor
  local insert_at = cell_end or row
  vim.api.nvim_buf_set_lines(0, insert_at, insert_at, false, CELL_TEMPLATE)
  -- Place cursor on the empty content line inside the new cell
  vim.api.nvim_win_set_cursor(0, { insert_at + 3, 0 })
  vim.cmd "startinsert"
end

function M.insert_cell_above()
  local row = vim.api.nvim_win_get_cursor(0)[1]
  local cell_start, _ = find_cell_boundaries(row, { silent = true })

  -- If inside a cell, insert before opening fence; otherwise insert at cursor
  local insert_at = cell_start and (cell_start - 1) or (row - 1)
  vim.api.nvim_buf_set_lines(0, insert_at, insert_at, false, CELL_TEMPLATE)
  vim.api.nvim_win_set_cursor(0, { insert_at + 3, 0 })
  vim.cmd "startinsert"
end

function M.run_cell_and_advance()
  local ok, runner = pcall(require, "quarto.runner")
  if not ok then
    vim.notify("quarto.runner is not available", vim.log.levels.ERROR)
    return
  end
  runner.run_cell()

  -- Inline next-cell search (instead of goto_next_cell) to avoid its "No next cell" warning
  local row = vim.api.nvim_win_get_cursor(0)[1]
  local total = vim.api.nvim_buf_line_count(0)
  local lines = vim.api.nvim_buf_get_lines(0, row, -1, false)
  for i, line in ipairs(lines) do
    if line:match(FENCE_OPEN) then
      vim.api.nvim_win_set_cursor(0, { math.min(row + i + 1, total), 0 })
      return
    end
  end

  -- No next cell — create one
  local _, cell_end = find_cell_boundaries(row)
  if cell_end then
    vim.api.nvim_buf_set_lines(0, cell_end, cell_end, false, CELL_TEMPLATE)
    vim.api.nvim_win_set_cursor(0, { cell_end + 3, 0 })
  else
    vim.notify("Could not determine cell boundaries to insert next cell", vim.log.levels.WARN)
  end
end

-- Restarts the first active Molten kernel (bang clears all outputs).
function M.restart_kernel()
  local ok, kernels = pcall(vim.fn.MoltenRunningKernels, true)
  if not ok then
    vim.notify("Molten is not loaded — run :UpdateRemotePlugins and restart Neovim", vim.log.levels.ERROR)
    return
  end
  if #kernels == 0 then
    vim.notify("No active kernel", vim.log.levels.WARN)
    return
  end
  vim.cmd({ cmd = "MoltenRestart", args = { kernels[1] }, bang = true })
end

function M.replace_block_lang()
  local row = vim.api.nvim_win_get_cursor(0)[1]
  local cell_start, _ = find_cell_boundaries(row)
  if not cell_start then return end

  vim.api.nvim_win_set_cursor(0, { cell_start, 0 })
  vim.cmd "normal! 0f{di{"
  vim.cmd "startinsert"
end

return M
