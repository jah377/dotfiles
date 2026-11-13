-- ============================================================================
-- FILE: lua/config/core/autocmds.lua
-- Autocommands: automatic actions triggered by events.
-- Every autocmd belongs to a group created with `clear = true`, so reloading
-- this file replaces the previous definitions instead of duplicating them.
--
-- ORDERING (verified on Neovim 0.12):
--   Neovim registers its ftplugin autocmd before init.lua runs, so on a
--   FileType event the runtime ftplugin AND after/ftplugin/<ft>.lua both run
--   BEFORE any FileType autocmd defined here. Autocmds in this file are
--   therefore the last writer of buffer-local options and must only change
--   what no filetype should ever override.
--
-- DOCUMENTATION:
--  > :help autocmd        : https://neovim.io/doc/user/autocmd/
--  > :help autocmd-events : https://neovim.io/doc/user/autocmd/#_5.-events
--  > vim.api.nvim_create_autocmd : Neovim Lua API for auto-commands
-- ============================================================================

local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

-- Highlight text when yanking ------------------------------------------------

-- See `:help vim.hl.on_yank` (vim.highlight was renamed to vim.hl in 0.11)
autocmd("TextYankPost", {
    desc = "Highlight yanked text",
    group = augroup("HighlightYankGroup", { clear = true }),
    callback = function() vim.hl.on_yank() end,
})

-- Restore last cursor position when reopening a file -------------------------

autocmd("BufReadPost", {
    desc = "Jump to the last cursor position",
    group = augroup("LastCursorGroup", { clear = true }),
    callback = function()
        local mark = vim.api.nvim_buf_get_mark(0, '"')
        local line_count = vim.api.nvim_buf_line_count(0)
        -- The mark can point past the end of a file that shrank; pcall also
        -- covers a column that no longer exists on the restored line.
        if mark[1] > 0 and mark[1] <= line_count then pcall(vim.api.nvim_win_set_cursor, 0, mark) end
    end,
})

-- Show cursorline only in the active window ----------------------------------

local cursorline_group = augroup("ActiveCursorlineGroup", { clear = true })
autocmd({ "InsertLeave", "WinEnter" }, {
    desc = "Restore cursorline when the window becomes active",
    group = cursorline_group,
    callback = function()
        if vim.w.auto_cursorline then
            vim.wo.cursorline = true
            vim.w.auto_cursorline = false
        end
    end,
})
autocmd({ "InsertEnter", "WinLeave" }, {
    desc = "Hide cursorline when the window becomes inactive",
    group = cursorline_group,
    callback = function()
        if vim.wo.cursorline then
            vim.w.auto_cursorline = true
            vim.wo.cursorline = false
        end
    end,
})

-- Use `q` to close "special" buffers -----------------------------------------

-- oil.nvim is not listed: it maps `q` itself (plugins/oil.lua), and its
-- filetype is the lowercase "oil", so the earlier "Oil" entry never matched.
autocmd("FileType", {
    desc = "Close special buffers with q or <Esc>",
    group = augroup("CloseSpecialBufferGroup", { clear = true }),
    pattern = {
        "help", -- Neovim help documentation (:help)
        "startuptime", -- :StartupTime profiling window
        "qf", -- Quickfix and location list windows
        "lspinfo", -- :LspInfo diagnostic window
        "man", -- man pages (:Man)
        "checkhealth", -- :checkhealth diagnostic window
        "lazy", -- lazy.nvim plugin manager window
    },
    callback = function(event)
        vim.bo[event.buf].buflisted = false -- keep out of :bnext and buffer pickers
        local opts = { buffer = event.buf, silent = true, desc = "Close window" }
        vim.keymap.set("n", "q", "<cmd>close<CR>", opts)
        vim.keymap.set("n", "<Esc>", "<cmd>close<CR>", opts)
    end,
})

-- Create parent directories when saving to a new path ------------------------

autocmd("BufWritePre", {
    desc = "Create parent directories on save",
    group = augroup("CreateParentDirGroup", { clear = true }),
    callback = function(event)
        if event.match:match("^%w%w+:[\\/][\\/]") then return end -- Skip URLs (scp://, https://)
        local file = vim.uv.fs_realpath(event.match) or event.match
        local dir = vim.fn.fnamemodify(file, ":p:h")
        vim.fn.mkdir(dir, "p")
    end,
})

-- Comment formatting policy --------------------------------------------------

-- Runs after every ftplugin (see ORDERING above), so it has the last word on
-- these 'formatoptions' flags. Runtime ftplugins add them back (lua: `croql`,
-- markdown: `tcqln`), which is why the global default in options.lua is not
-- enough on its own.
--   r, o : never continue a comment on Enter / o / O.
--   c    : never auto-wrap comments while typing. A trailing comment on a long
--          line would otherwise be split onto a new line, and config files
--          here routinely run past 'textwidth'. Filetypes where wrapping is
--          safe opt in by setting `vim.b.wrap_comments = true` in their
--          after/ftplugin (python: its formatexpr wraps comments and
--          docstrings but never code).
-- DECISION: an earlier revision stripped `c` unconditionally, which silently
-- defeated the Python opt-in; a revision after that kept `c` everywhere, which
-- changed how every other filetype behaved. The flag keeps the long-standing
-- default and makes the exception explicit.

autocmd("FileType", {
    desc = "Strip comment continuation and, unless opted in, comment auto-wrap",
    group = augroup("CommentFormatPolicyGroup", { clear = true }),
    callback = function(event)
        -- Operate on the event buffer explicitly: FileType can fire for a
        -- buffer that is not in the current window.
        local flags = vim.bo[event.buf].formatoptions
        local unwanted = vim.b[event.buf].wrap_comments and "[ro]" or "[roc]"
        vim.bo[event.buf].formatoptions = (flags:gsub(unwanted, ""))
    end,
})

-- Highlight text beyond 'textwidth' ------------------------------------------

-- matchadd() is window-local, so every function below takes an explicit
-- window instead of reading the current one: FileType can fire for a buffer
-- that is not in the current window (eg. `nvim a.qmd b.qmd`), and relying on
-- implicit state attached the match to the wrong window.
-- Buffers opt out with `vim.b.overlength_disabled = true` (after/ftplugin/).

local OVERLENGTH_HL = "OverLength" -- defined in core/highlights.lua
local MATCH_DEFAULT_PRIORITY = 10 -- matchadd() default; above 'hlsearch' (0)

--- Replace the overlength match in one window.
--- @param win integer window handle
local function update_overlength_match(win)
    if not vim.api.nvim_win_is_valid(win) then return end

    local existing_id = vim.w[win].overlength_match_id
    if existing_id then
        pcall(vim.fn.matchdelete, existing_id, win) -- id may be gone after :clearmatches
        vim.w[win].overlength_match_id = nil
    end

    -- Floating windows (pickers, previews, lazy's UI) inherit the global
    -- textwidth through their scratch buffers; the marker means nothing there.
    if vim.api.nvim_win_get_config(win).relative ~= "" then return end

    local buf = vim.api.nvim_win_get_buf(win)
    if vim.b[buf].overlength_disabled then return end
    local textwidth = vim.bo[buf].textwidth
    if textwidth <= 0 then return end

    -- \%>Nv matches every character right of virtual column N
    local pattern = string.format("\\%%>%dv.\\+", textwidth)
    vim.w[win].overlength_match_id = vim.fn.matchadd(OVERLENGTH_HL, pattern, MATCH_DEFAULT_PRIORITY, -1, { window = win })
end

--- Update every window currently showing a buffer.
--- @param buf integer buffer handle
local function update_overlength_for_buffer(buf)
    for _, win in ipairs(vim.fn.win_findbuf(buf)) do
        update_overlength_match(win)
    end
end

local overlength_group = augroup("OverLengthGroup", { clear = true })
autocmd({ "BufWinEnter", "WinEnter" }, {
    desc = "Highlight text beyond textwidth in the entered window",
    group = overlength_group,
    callback = function() update_overlength_match(vim.api.nvim_get_current_win()) end,
})
autocmd("FileType", {
    desc = "Rebuild overlength highlight after ftplugins set textwidth",
    group = overlength_group,
    callback = function(event) update_overlength_for_buffer(event.buf) end,
})
autocmd("OptionSet", {
    desc = "Rebuild overlength highlight when textwidth changes",
    group = overlength_group,
    pattern = "textwidth",
    callback = function() update_overlength_for_buffer(vim.api.nvim_get_current_buf()) end,
})
