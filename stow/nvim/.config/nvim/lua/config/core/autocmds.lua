-- =============================================================================
-- FILE: lua/config/core/autocmds.lua
-- Autocommands: automatic actions triggered by events.
-- Groups with clear=true prevent duplicates on config reload.
-- =============================================================================

local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- HIGHLIGHT YANKED TEXT --
augroup("HighlightYankGroup", { clear = true })
autocmd("TextYankPost", {
  desc = "Highlight yanked text",
  group = "HighlightYankGroup",
  callback = function() vim.highlight.on_yank() end,
})

-- RESTORE CURSOR POSITION --
augroup("LastCursorGroup", { clear = true })
autocmd("BufReadPost", {
  group = "LastCursorGroup",
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local lcount = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- SMART CURSORLINE --
-- Show cursorline only in active window
augroup("ActiveCursorlineGroup", { clear = true })
autocmd({ "InsertLeave", "WinEnter" }, {
  group = "ActiveCursorlineGroup",
  callback = function()
    if vim.w.auto_cursorline then
      vim.wo.cursorline = true
      vim.w.auto_cursorline = false
    end
  end,
})
autocmd({ "InsertEnter", "WinLeave" }, {
  group = "ActiveCursorlineGroup",
  callback = function()
    if vim.wo.cursorline then
      vim.w.auto_cursorline = true
      vim.wo.cursorline = false
    end
  end,
})

-- QUICK-CLOSE SPECIAL BUFFERS --
-- Press q or Esc to close help, quickfix, plugin windows, etc.
augroup("CloseSpecialBufferGroup", { clear = true })
autocmd("FileType", {
  group = "CloseSpecialBufferGroup",
  pattern = { "help", "startuptime", "qf", "lspinfo", "man", "Oil", "checkhealth", "lazy" },
  command = [[
          nnoremap <buffer><silent> q :close<CR>
          nnoremap <buffer><silent> <ESC> :close<CR>
          set nobuflisted
      ]],
})

-- DISABLE AUTO-COMMENTING --
-- Prevent auto-inserting comment chars on Enter/o/O
augroup("AutoCommentGroup", { clear = true })
autocmd("FileType", {
  desc = "Disable auto-commenting on new line",
  group = "AutoCommentGroup",
  callback = function()
    vim.opt_local.formatoptions:remove({ "c", "r", "o" })
  end,
})

-- AUTO-CREATE PARENT DIRECTORIES --
augroup("CreateParentDirGroup", { clear = true })
autocmd("BufWritePre", {
  desc = "Create parent directories on save",
  group = "CreateParentDirGroup",
  callback = function(event)
    if event.match:match("^%w%w+:[\\/][\\/]") then return end  -- Skip URLs
    local file = vim.uv.fs_realpath(event.match) or event.match
    local dir = vim.fn.fnamemodify(file, ":p:h")
    vim.fn.mkdir(dir, "p")
  end,
})

-- REMOVE TRAILING WHITESPACE --
augroup("TrailingSpaceGroup", { clear = true })
autocmd("BufWritePre", {
  desc = "Remove trailing whitespace on save",
  group = "TrailingSpaceGroup",
  pattern = { "*" },
  callback = function()
    local save_cursor = vim.fn.getpos(".")
    vim.cmd([[%s/\s\+$//e]])
    vim.fn.setpos(".", save_cursor)
  end,
})
