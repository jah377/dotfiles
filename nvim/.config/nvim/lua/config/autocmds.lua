-- ============================================================================
-- TITLE : Auto-commands
--
-- ABOUT : Automatically run code on defined events (eg. save, yank)
--
-- ============================================================================

local autocmd = vim.api.nvim_create_autocmd

autocmd("TextYankPost", {
  desc = "Highlight when yanking (copying) text",
  group = vim.api.nvim_create_augroup("highlight_yank", { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

autocmd("FileType", {
  desc = "Automatically Split help Buffers to the right",
  pattern = "help",
  command = "wincmd L",
})

-- Show cursorline only on active windows
-- From https://github.com/folke/dot/blob/master/nvim/lua/config/autocmds.lua
autocmd({ "InsertLeave", "WinEnter" }, {
  callback = function()
    if vim.w.auto_cursorline then
      vim.wo.cursorline = true
      vim.w.auto_cursorline = false
    end
  end,
})

autocmd({ "InsertEnter", "WinLeave" }, {
  callback = function()
    if vim.wo.cursorline then
      vim.w.auto_cursorline = true
      vim.wo.cursorline = false
    end
  end,
})

-- Use 'q' to close special buffer types. '' catches a lot of transient plugin windows.
-- From https://www.reddit.com/r/neovim/comments/1i2xw2m/share_your_favorite_autocmds/
autocmd("FileType", {
  pattern = {
    "help",
    "startuptime",
    "qf",
    "lspinfo",
    "man",
    "Oil",
    "checkhealth",
    "neotest-output-panel",
    "neotest-summary",
    "lazy",
  },
  command = [[
          nnoremap <buffer><silent> q :close<CR>
          nnoremap <buffer><silent> <ESC> :close<CR>
          set nobuflisted
      ]],
})

-- Restore last cursor position when reopening a file
-- From https://www.youtube.com/watch?v=cdAMq2KcF4w&t=3324s
local last_cursor_group = vim.api.nvim_create_augroup("LastCursorGroup", {})
vim.api.nvim_create_autocmd("BufReadPost", {
  group = last_cursor_group,
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local lcount = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})
