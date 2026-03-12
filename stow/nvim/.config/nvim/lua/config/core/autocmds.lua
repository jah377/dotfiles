-- =============================================================================
-- FILE: lua/config/core/autocmds.lua
--
-- PURPOSE:
--   This file defines autocommands - automatic actions that execute in response
--   to specific events. Think of them as "triggers" that run code when certain
--   things happen (file opened, text yanked, window changed, etc.).
--
--   Autocommands are powerful for:
--   - Maintaining consistent editor behavior
--   - Automating repetitive tasks
--   - Customizing behavior per file type
--
-- KEY CONCEPTS:
--   Event   : What triggers the autocommand (BufReadPost, TextYankPost, etc.)
--   Pattern : Which files/buffers the autocommand applies to (* = all)
--   Group   : A named collection of autocommands (for easy management)
--   clear   : Remove existing autocommands in the group before adding new ones
--
-- DOCUMENTATION:
--   > :help autocmd       : https://neovim.io/doc/user/autocmd.html
--   > :help autocmd-events: https://neovim.io/doc/user/autocmd.html#autocmd-events
--   > vim.api.nvim_create_autocmd : Neovim Lua API for autocommands
--
-- =============================================================================

-- Create local aliases for the autocommand API functions.
-- These make the code more readable by shortening the function names.
local augroup = vim.api.nvim_create_augroup -- Creates a named group of autocmds
local autocmd = vim.api.nvim_create_autocmd -- Creates an individual autocmd

-- =============================================================================
-- HIGHLIGHT YANKED TEXT
-- =============================================================================

-- Briefly highlight text when you "yank" (copy) it.
--
-- This provides visual feedback so you can see exactly what was copied.
-- The highlight lasts about 150ms by default (configurable in on_yank()).
--
-- Why this is useful:
--   - Confirms your yank command worked
--   - Shows you selected the right text (especially with text objects like yap)
--   - Helps catch accidental yanks

-- Create an autocommand group to prevent duplicate autocommands when
-- reloading the config. The `clear = true` option removes any existing
-- autocommands in this group before adding new ones.
augroup("HighlightYankGroup", { clear = true })

-- The TextYankPost event fires AFTER text is yanked (copied) to a register.
autocmd("TextYankPost", {
  desc = "Highlight when yanking (copying) text",
  group = "HighlightYankGroup",  -- Associate with our group
  callback = function()
    -- vim.highlight.on_yank() temporarily highlights the yanked region.
    -- You can customize it: vim.highlight.on_yank({ timeout = 200, higroup = "Visual" })
    vim.highlight.on_yank()
  end,
})

-- =============================================================================
-- RESTORE CURSOR POSITION
-- =============================================================================

-- When reopening a file, jump to the last position you were at.
--
-- Neovim stores the last cursor position in a special mark called '"'.
-- This autocommand reads that mark and moves the cursor there.
--
-- This saves you from having to navigate back to where you were every
-- time you reopen a file. Very helpful for long files.

-- Create a group for this autocommand
augroup("LastCursorGroup", { clear = true })

-- BufReadPost fires after a file is read into a buffer
autocmd("BufReadPost", {
  group = "LastCursorGroup",
  callback = function()
    -- Get the line and column stored in the '"' mark (last cursor position)
    -- nvim_buf_get_mark returns {line, column} where lines are 1-indexed
    local mark = vim.api.nvim_buf_get_mark(0, '"')

    -- Get the total number of lines in the current buffer
    local lcount = vim.api.nvim_buf_line_count(0)

    -- Only restore if the mark exists (line > 0) and is within the file
    if mark[1] > 0 and mark[1] <= lcount then
      -- pcall = "protected call" - catches errors if the line is invalid
      -- nvim_win_set_cursor(window, {line, column}) moves the cursor
      -- 0 = current window
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- =============================================================================
-- SMART CURSORLINE
-- =============================================================================

-- Show the cursorline only in the active window.
--
-- When you have multiple windows open, having a cursorline in ALL of them
-- can be visually confusing. This autocommand:
--   - Shows cursorline in the window you're currently editing
--   - Hides cursorline when you leave a window or enter insert mode
--
-- This makes it much easier to track which window has focus.

augroup("ActiveCursorlineGroup", { clear = true })

-- Show cursorline when entering a window or leaving insert mode
autocmd({ "InsertLeave", "WinEnter" }, {
  group = "ActiveCursorlineGroup",
  callback = function()
    -- vim.w is window-local variables (like a sticky note on this window)
    -- Check if we previously hid the cursorline in this window
    if vim.w.auto_cursorline then
      vim.wo.cursorline = true       -- Show the cursorline
      vim.w.auto_cursorline = false  -- Clear our flag
    end
  end,
})

-- Hide cursorline when leaving a window or entering insert mode
autocmd({ "InsertEnter", "WinLeave" }, {
  group = "ActiveCursorlineGroup",
  callback = function()
    -- Only act if cursorline is currently shown
    if vim.wo.cursorline then
      vim.w.auto_cursorline = true  -- Remember we're hiding it
      vim.wo.cursorline = false     -- Hide the cursorline
    end
  end,
})

-- =============================================================================
-- QUICK-CLOSE SPECIAL BUFFERS
-- =============================================================================

-- Allow pressing 'q' or Escape to close certain buffer types.
--
-- Some buffers are "special" - they show information but aren't meant to be
-- edited (help pages, quickfix lists, plugin windows, etc.). For these,
-- it's convenient to press a single key to close them instead of :q<CR>.
--
-- This also marks these buffers as "unlisted" so they don't clutter up
-- the buffer list when you run :ls or use buffer-switching commands.

augroup("CloseSpecialBufferGroup", { clear = true })

-- FileType event fires when Neovim detects the type of file in a buffer
autocmd("FileType", {
  group = "CloseSpecialBufferGroup",
  -- Only apply to these specific file types:
  pattern = {
    "help",        -- Neovim help documentation (:help)
    "startuptime", -- :StartupTime profiling window
    "qf",          -- Quickfix and location list windows
    "lspinfo",     -- :LspInfo diagnostic window
    "man",         -- Man pages (:Man)
    "Oil",         -- Oil.nvim file explorer
    "checkhealth", -- :checkhealth diagnostic window
    "lazy",        -- lazy.nvim plugin manager window
  },
  -- 'command' runs raw Vim commands (faster than callback for simple cases)
  command = [[
          nnoremap <buffer><silent> q :close<CR>
          nnoremap <buffer><silent> <ESC> :close<CR>
          set nobuflisted
      ]],
  -- Explanation of the command:
  -- nnoremap <buffer><silent> q :close<CR>
  --   Create a buffer-local, non-recursive, silent mapping:
  --   Press 'q' to close the window
  --
  -- nnoremap <buffer><silent> <ESC> :close<CR>
  --   Same for Escape key
  --
  -- set nobuflisted
  --   Remove this buffer from the buffer list (:ls)
})

-- =============================================================================
-- DISABLE AUTO-COMMENTING
-- =============================================================================

-- Prevent Neovim from automatically inserting comment characters on new lines.
--
-- By default, if you're on a comment line and press Enter or 'o', Neovim
-- continues the comment by inserting the comment character (like // or #).
-- This can be annoying when you want to write code after a comment.
--
-- This autocommand removes the format options that cause auto-commenting:
--   c : Auto-wrap comments and insert comment leader
--   r : Insert comment leader after pressing Enter
--   o : Insert comment leader after pressing 'o' or 'O'

augroup("AutoCommentGroup", { clear = true })
autocmd("FileType", {
  desc = "Disable auto-commenting on new line",
  group = "AutoCommentGroup",
  callback = function()
    -- opt_local affects only the current buffer, not globally
    -- :remove() takes away the specified options from formatoptions
    vim.opt_local.formatoptions:remove({ "c", "r", "o" })
  end,
})

-- =============================================================================
-- AUTO-CREATE PARENT DIRECTORIES
-- =============================================================================

-- Automatically create parent directories when saving a file to a new path.
--
-- Normally, if you try to save a file to a path that doesn't exist (like
-- :w /foo/bar/baz.txt where /foo/bar/ doesn't exist), Neovim gives an error.
--
-- This autocommand creates any missing directories automatically, so you
-- can save files anywhere without manually running mkdir first.

augroup("CreateParentDirGroup", { clear = true })

-- BufWritePre fires BEFORE a buffer is written to disk
autocmd("BufWritePre", {
  desc = "Create parent directories on save",
  group = "CreateParentDirGroup",
  callback = function(event)
    -- event.match is the filename being written

    -- Skip URLs (like scp://host/path or http://...) - we can't create
    -- directories on remote systems this way
    -- Pattern: starts with word chars, then ://, which indicates a URL scheme
    if event.match:match("^%w%w+:[\\/][\\/]") then
      return
    end

    -- Get the real path (resolves symlinks) or use the original if it fails
    -- vim.uv.fs_realpath returns nil for paths that don't exist yet
    local file = vim.uv.fs_realpath(event.match) or event.match

    -- Extract the directory portion of the path
    -- fnamemodify with ":p:h" = full path (:p) then head/directory (:h)
    local dir = vim.fn.fnamemodify(file, ":p:h")

    -- Create the directory and any missing parents ("p" flag = parents)
    vim.fn.mkdir(dir, "p")
  end,
})

-- =============================================================================
-- REMOVE TRAILING WHITESPACE
-- =============================================================================

-- Automatically remove trailing whitespace (spaces/tabs at end of lines)
-- before saving any file.
--
-- Trailing whitespace is generally unwanted:
--   - Makes diffs noisy
--   - Can cause issues with some tools
--   - Indicates sloppy editing
--
-- This autocommand cleans up trailing whitespace automatically so you
-- don't have to think about it.

augroup("TrailingSpaceGroup", { clear = true })
autocmd("BufWritePre", {
  desc = "Remove trailing whitespace on save",
  group = "TrailingSpaceGroup",
  pattern = { "*" },  -- Apply to all files
  callback = function()
    -- Save the current cursor position so we can restore it after the
    -- substitution (which might move the cursor)
    local save_cursor = vim.fn.getpos(".")

    -- Run a substitution to remove trailing whitespace:
    --   %       : Apply to all lines in the file
    --   s       : Substitute command
    --   \s\+$   : Match one or more whitespace chars (\s\+) at end of line ($)
    --   //      : Replace with nothing (delete)
    --   e       : Don't error if no matches found
    vim.cmd([[%s/\s\+$//e]])

    -- Restore the cursor to its original position
    vim.fn.setpos(".", save_cursor)
  end,
})
