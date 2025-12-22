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

autocmd({ "InsertLeave", "FocusLost" }, {
  desc = "Autosave modified files",
  pattern = { "*" },
  callback = function()
    -- Only save if buffer is modifiable, modified, has a name, and isn't special
    if vim.bo.modifiable and vim.bo.modified and vim.bo.buftype == "" then
      vim.cmd("silent! write")
    end
  end,
})

autocmd("FileType", {
  desc = "Automatically Split help Buffers to the right",
  pattern = "help",
  command = "wincmd L",
})

-- Aggressively autoload files changed outside of Neovim
vim.opt.autoread = true
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold" }, {
  command = "checktime",
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

-- Disable auto-commenting on new lines
autocmd("FileType", {
  desc = "Disable auto-commenting on new line",
  callback = function()
    vim.opt_local.formatoptions:remove({ "r", "o" })
  end,
})

-- Create parent directories when saving (if they don't exist)
autocmd("BufWritePre", {
  desc = "Create parent directories on save",
  callback = function(event)
    local file = vim.loop.fs_realpath(event.match) or event.match
    vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
  end,
})

-- Remove trailing whitespace on save
autocmd("BufWritePre", {
  desc = "Remove trailing whitespace on save",
  pattern = { "*" },
  callback = function()
    local save_cursor = vim.fn.getpos(".")
    vim.cmd([[%s/\s\+$//e]])
    vim.fn.setpos(".", save_cursor)
  end,
})

-- Auto-resize splits when window is resized
autocmd("VimResized", {
  desc = "Resize splits when window is resized",
  callback = function()
    vim.cmd("tabdo wincmd =")
  end,
})

-- Use absolute line numbers in insert mode, relative in normal mode
local number_toggle_group = vim.api.nvim_create_augroup("NumberToggle", {})
autocmd({ "BufEnter", "FocusGained", "InsertLeave", "WinEnter" }, {
  group = number_toggle_group,
  callback = function()
    if vim.o.number and vim.api.nvim_get_mode().mode ~= "i" then
      vim.opt.relativenumber = true
    end
  end,
})

autocmd({ "BufLeave", "FocusLost", "InsertEnter", "WinLeave" }, {
  group = number_toggle_group,
  callback = function()
    if vim.o.number then
      vim.opt.relativenumber = false
    end
  end,
})

-- Make shell scripts executable on save
autocmd("BufWritePost", {
  desc = "Make shell scripts executable",
  pattern = { "*.sh", "*.zsh", "*.bash" },
  callback = function()
    local file = vim.fn.expand("%:p")
    vim.fn.system({ "chmod", "+x", file })
  end,
})

-- Terminal settings
autocmd("TermOpen", {
  desc = "Terminal settings",
  callback = function()
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
    vim.opt_local.signcolumn = "no"
    vim.opt_local.scrolloff = 0
  end,
})

-- Start in insert mode when entering terminal
autocmd("BufEnter", {
  pattern = "term://*",
  command = "startinsert",
})

-- Disable features for large files (>1MB)
autocmd("BufReadPre", {
  desc = "Disable certain functionality for large files",
  callback = function(args)
    local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(args.buf))
    if ok and stats and stats.size > 1000000 then -- 1MB
      vim.b.large_file = true
      vim.opt_local.spell = false
      vim.opt_local.swapfile = false
      vim.opt_local.undofile = false
      vim.opt_local.breakindent = false
      vim.opt_local.colorcolumn = ""
      vim.opt_local.statuscolumn = ""
      vim.opt_local.signcolumn = "no"
      vim.opt_local.foldcolumn = "0"
      vim.opt_local.winbar = ""
      vim.cmd("syntax clear")
    end
  end,
})

-- Close quickfix window if it's the last window
autocmd("WinEnter", {
  desc = "Close quickfix if it's the last window",
  callback = function()
    if vim.fn.winnr("$") == 1 and vim.bo.buftype == "quickfix" then
      vim.cmd("q")
    end
  end,
})

-- Highlight TODO, FIXME, NOTE, etc.
autocmd({ "BufEnter", "BufWritePost" }, {
  desc = "Highlight TODO comments",
  callback = function()
    vim.fn.matchadd("Todo", "\\(TODO\\|FIXME\\|NOTE\\|HACK\\|PERF\\):")
  end,
})

-- Go to last location in quickfix/location list
autocmd("FileType", {
  pattern = "qf",
  callback = function()
    vim.cmd("normal! G")
  end,
})

-- Automatically disable paste mode when leaving insert mode
autocmd("InsertLeave", {
  desc = "Disable paste mode on leaving insert",
  callback = function()
    if vim.o.paste then
      vim.o.paste = false
    end
  end,
})

-- Highlight URLs
autocmd({ "VimEnter", "FileType", "BufEnter", "WinEnter" }, {
  desc = "URL Highlighting",
  callback = function()
    vim.fn.matchadd("URL", "\\v\\c%(%(h?ttps?|ftp|file|ssh|git)://|[a-z]+[@][a-z]+[.][a-z]+:)%([&:#*@~%_\\-=?!+;/0-9a-z]+%(%([.;/?]|[.][.]+)[&:#*@~%_\\-=?!+/0-9a-z]+|:\\d+|,%(%(%(h?ttps?|ftp|file|ssh|git)://|[a-z]+[@][a-z]+[.][a-z]+:)@![0-9a-z]+))*|\\([&:#*@~%_\\-=?!+;/.0-9a-z]*\\)|\\[[&:#*@~%_\\-=?!+;/.0-9a-z]*\\]|\\{%([&:#*@~%_\\-=?!+;/.0-9a-z]*|\\{[&:#*@~%_\\-=?!+;/.0-9a-z]*})\\})+")
  end,
})

-- Set filetype for common config files
autocmd({ "BufRead", "BufNewFile" }, {
  pattern = { ".env*", "*.conf", "config" },
  command = "setfiletype conf",
})

autocmd({ "BufRead", "BufNewFile" }, {
  pattern = { "*.md", "*.markdown" },
  command = "setfiletype markdown",
})

-- Git commit message settings
autocmd("FileType", {
  pattern = "gitcommit",
  callback = function()
    vim.opt_local.spell = true
    vim.opt_local.colorcolumn = "72"
  end,
})
