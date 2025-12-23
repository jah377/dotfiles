-- [[ Auto-commands ]]
-- See :help autocmds

local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- Highlight text when yanking
-- See `:help vim.highlight.on_yank()`
augroup("HighlightYankGroup", { clear = true })
autocmd("TextYankPost", {
  desc = "Highlight when yanking (copying) text",
  group = "HighlightYankGroup",
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- Restore last cursor position when reopening a file
-- From https://www.youtube.com/watch?v=cdAMq2KcF4w&t=3324s
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


-- Show cursorline only on active windows
-- From https://github.com/folke/dot/blob/master/nvim/lua/config/autocmds.lua
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

-- Use 'q' to close special buffer types
-- From https://www.reddit.com/r/neovim/comments/1i2xw2m/share_your_favorite_autocmds/
augroup("CloseSpecialBufferGroup", { clear = true })
autocmd("FileType", {
  group = "CloseSpecialBufferGroup",
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

-- Disable auto-commenting on new lines
-- See `:help formatoptions`
augroup("AutoCommentGroup", { clear = true })
autocmd("FileType", {
  desc = "Disable auto-commenting on new line",
  group = "AutoCommentGroup",
  callback = function()
    vim.opt_local.formatoptions:remove({ "c", "r", "o" })
  end,
})

-- Create parent directories when saving (if they don't exist)
augroup("CreateParentDirGroup", { clear = true })
autocmd("BufWritePre", {
  desc = "Create parent directories on save",
  group = "CreateParentDirGroup",
  callback = function(event)
    if event.match:match("^%w%w+:[\\/][\\/]") then
      return
    end
    local file = vim.uv.fs_realpath(event.match) or event.match
    vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
  end,
})

-- Remove trailing whitespace on save
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
