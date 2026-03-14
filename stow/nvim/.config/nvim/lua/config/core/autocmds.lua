-- =============================================================================
-- FILE: lua/config/core/autocmds.lua
-- Autocommands: automatic actions triggered by events.
-- Groups with clear=true prevent duplicates on config reload.
--
-- DOCUMENTATION:
--  > :help autocmd : https://neovim.io/doc/user/autocmd/
--  > :help autocmd-events : https://neovim.io/doc/user/autocmd/#_5.-events
--  > vim.api.nvim_create_autocmd : Neovim Lua API for auto-commands
-- =============================================================================

-- Create local alias to make code more readable
local autocmd = vim.api.nvim_create_autocmd

-- Using autocmd groups prevent duplicate autocmds when reloading config
-- `{ clear = true }` removes existing autocmds for group
local augroup = vim.api.nvim_create_augroup

-- Highlight text when yanking
-- See `:help vim.highlight.on_yank`
augroup("HighlightYankGroup", { clear = true })
autocmd("TextYankPost", {
  desc = "Highlight yanked text",
  group = "HighlightYankGroup",
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- Restore last cursor position when reopening a file
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

-- Show cursorline only in active window
-- Requires autocmds for entering and leaving windows
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

-- Use `q` to quickly close "special" buffers
-- "Special" buffer types defined in autocmd
augroup("CloseSpecialBufferGroup", { clear = true })
autocmd("FileType", {
  group = "CloseSpecialBufferGroup",
  pattern = {
    "help", -- Neovim help documentation (:help)
    "startuptime", -- :StartupTime profiling window
    "qf", -- Quickfix and location list windows
    "lspinfo", -- :LspInfo diagnostic window
    "man", -- man pages (:Man)
    "Oil", -- Oil.nvim file explorer
    "checkhealth", -- :checkhealth diagnostic window
    "lazy", -- lazy.nvim plugin manager window
  },
  command = [[
          nnoremap <buffer><silent> q :close<CR>
          nnoremap <buffer><silent> <ESC> :close<CR>
          set nobuflisted
      ]],
})

-- Automatically create parent directories when saving file to new path
augroup("CreateParentDirGroup", { clear = true })
autocmd("BufWritePre", {
  desc = "Create parent directories on save",
  group = "CreateParentDirGroup",
  callback = function(event)
    if event.match:match("^%w%w+:[\\/][\\/]") then
      return
    end -- Skip URLs
    local file = vim.uv.fs_realpath(event.match) or event.match
    local dir = vim.fn.fnamemodify(file, ":p:h")
    vim.fn.mkdir(dir, "p")
  end,
})

-- Automatically remove trailing whitespaces when saving buffers
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

-- Disable auto-commenting when opening a new line from comment
-- Still required despite settings in `core/options.lua`
-- See `:help formatoptions`
augroup("AutoCommentGroup", { clear = true })
autocmd("FileType", {
  desc = "Disable auto-commenting on new line",
  group = "AutoCommentGroup",
  callback = function()
    vim.opt_local.formatoptions:remove({ "c", "r", "o" })
  end,
})
