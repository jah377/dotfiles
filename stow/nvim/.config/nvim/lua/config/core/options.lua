-- =============================================================================
-- FILE: lua/config/core/options.lua
--
-- PURPOSE:
--   This file configures Neovim's built-in options - settings that control
--   how the editor behaves and displays content. These are the equivalent of
--   running `:set option=value` commands in Vim.
--
--   Options are organized into logical groups:
--   - Performance (timing)
--   - Colors (terminal colors)
--   - Indentation (tabs, spaces, auto-indent)
--   - Line wrapping
--   - Line numbers
--   - Window splitting
--   - Cursor behavior
--   - Command-line display
--   - Completion menu
--   - Searching
--   - Spell checking
--   - File handling
--   - Text formatting
--   - Messages
--   - Miscellaneous
--
--   For file-type-specific settings, see: after/ftplugin/<filetype>.lua
--
-- DOCUMENTATION:
--   > vim.opt         : https://neovim.io/doc/user/lua.html#vim.opt
--   > Option index    : https://neovim.io/doc/user/options.html
--   > :help <option>  : Run in Neovim for any specific option
--
-- =============================================================================

-- Create a local alias for vim.opt to reduce typing.
-- `vim.opt` provides a Lua-friendly way to set Vim options.
-- Using `opt.foo = bar` is equivalent to running `:set foo=bar`.
local opt = vim.opt

-- =============================================================================
-- PERFORMANCE
-- =============================================================================

-- Time in milliseconds to wait before triggering CursorHold event and writing
-- swap file. Lower values make the editor feel more responsive but use more
-- CPU. Default is 4000ms (4 seconds), which feels sluggish for features like
-- diagnostics that update on CursorHold.
opt.updatetime = 250

-- Time in milliseconds to wait for a mapped key sequence to complete.
-- This affects how long which-key waits before showing the popup.
-- Lower values show the popup faster but may trigger during normal typing.
-- Default is 1000ms. 300ms feels responsive without being too aggressive.
opt.timeoutlen = 300

-- =============================================================================
-- COLORS
-- =============================================================================

-- Enable 24-bit RGB color in the terminal UI.
-- This allows themes to use millions of colors instead of the basic 256.
-- Your terminal emulator must support "true color" for this to work.
-- Most modern terminals (iTerm2, Alacritty, Kitty, Windows Terminal) do.
opt.termguicolors = true

-- =============================================================================
-- INDENTATION
-- =============================================================================

-- Convert Tab key presses to spaces. When you press Tab, Neovim inserts
-- spaces instead of an actual tab character. This ensures consistent display
-- across different editors and viewers.
opt.expandtab = true

-- Number of spaces inserted when you press the Tab key. This only affects
-- the Tab key behavior in insert mode, not how existing tabs are displayed.
opt.softtabstop = 4

-- Number of spaces used for each step of (auto)indent. This controls how
-- many spaces the << and >> commands add or remove, and how auto-indent
-- aligns new lines.
opt.shiftwidth = 4

-- Number of spaces that a <Tab> character displays as. This only affects
-- how existing tab characters appear, not how new tabs are inserted.
opt.tabstop = 4

-- Insert the appropriate number of spaces when Tab is pressed at the start
-- of a line (based on shiftwidth). In the middle of a line, uses softtabstop.
opt.smarttab = true

-- Automatically insert indentation when starting a new line. Neovim analyzes
-- the current line's syntax (like { or : in code) to determine the indent.
opt.smartindent = true

-- Copy the indentation from the previous line when starting a new line.
-- This is simpler than smartindent and serves as a fallback.
opt.autoindent = true

-- =============================================================================
-- WHITESPACE DISPLAY
-- =============================================================================

-- Show invisible characters (whitespace) in the editor. This makes it easier
-- to spot issues like trailing spaces, mixed tabs/spaces, or non-breaking
-- spaces that can cause subtle bugs.
vim.opt.list = true

-- Define how invisible characters are displayed when 'list' is enabled:
--   tab   = "» " : Show tabs as » followed by spaces to fill the tab width
--   trail = "·"  : Show trailing spaces (at end of line) as middle dots
--   nbsp  = "␣"  : Show non-breaking spaces as the "open box" symbol
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

-- =============================================================================
-- LINE WRAPPING
-- =============================================================================

-- Maximum line length before Neovim automatically inserts a line break.
-- This is "hard wrapping" - it actually modifies the text. Set to 79 to
-- match PEP 8 (Python style guide) and many other conventions.
opt.textwidth = 79

-- Visually wrap lines that exceed the window width. This is "soft wrapping" -
-- it only affects display, not the actual text. The line will appear to
-- continue on the next screen line.
opt.wrap = true

-- When soft-wrapping, preserve the indentation level of the original line.
-- This makes wrapped code much easier to read because indentation is maintained.
opt.breakindent = true

-- When soft-wrapping, break lines at word boundaries rather than in the
-- middle of words. This prevents words from being split across lines.
opt.linebreak = true

-- =============================================================================
-- LINE NUMBERS
-- =============================================================================

-- Show line numbers in the left margin. Essential for navigating code,
-- reporting errors, and using commands like :42 to jump to line 42.
opt.number = true

-- Show line numbers relative to the current cursor position instead of
-- absolute line numbers. This makes it easier to use motion commands like
-- 10j (move down 10 lines) because you can see exactly how many lines away
-- your target is.
opt.relativenumber = true

-- =============================================================================
-- WINDOW SPLITTING
-- =============================================================================

-- When splitting vertically (:vsplit), put the new window to the right of
-- the current one. Default behavior puts it to the left, which can be
-- disorienting.
opt.splitright = true

-- When splitting horizontally (:split), put the new window below the current
-- one. Default behavior puts it above, which can be disorienting.
opt.splitbelow = true

-- Border style for floating windows (like LSP hover information, completion
-- menus, etc.). "rounded" gives a smooth, modern appearance.
opt.winborder = "rounded"

-- =============================================================================
-- CURSOR
-- =============================================================================

-- Highlight the entire line where the cursor is positioned. This makes it
-- easier to track your position in the document, especially in long files.
opt.cursorline = true

-- Don't highlight the column where the cursor is positioned. While this can
-- be useful for alignment, it creates visual clutter for most editing tasks.
opt.cursorcolumn = false

-- Keep at least 10 lines visible above and below the cursor when scrolling.
-- This prevents the cursor from getting too close to the edge of the screen,
-- giving you context about surrounding code.
opt.scrolloff = 10

-- =============================================================================
-- VISUAL GUIDES
-- =============================================================================

-- Column position(s) to display a vertical line as a visual guide. Commonly
-- set to "80" or "88" to mark recommended line length limits. Empty string
-- disables the guide.
opt.colorcolumn = ""

-- =============================================================================
-- COMMAND-LINE
-- =============================================================================

-- Don't show mode indicator (-- INSERT --, -- VISUAL --, etc.) in the
-- command line. This information is typically shown in the statusline
-- instead, making the command line display redundant.
opt.showmode = false

-- Set the command-line height to 0 lines. This hides the command line until
-- you actually need it (like when typing :commands or searching). Provides
-- more screen space for editing.
opt.cmdheight = 0

-- =============================================================================
-- COMPLETION MENU
-- =============================================================================

-- Configure how the completion popup menu behaves:
--   menu     : Show a popup menu even if there's only one match
--   menuone  : Show the menu even when there's only one match
--   noselect : Don't automatically select the first match; wait for user input
opt.completeopt = "menu,menuone,noselect"

-- Maximum number of items to show in the completion popup menu. 10 items is
-- enough to see options without taking over the screen.
opt.pumheight = 10

-- Transparency level of the completion popup menu (0-100). 10 provides subtle
-- transparency so you can see code behind the menu while still being readable.
opt.pumblend = 10

-- =============================================================================
-- SEARCHING AND SUBSTITUTIONS
-- =============================================================================

-- Highlight all matches when searching with / or ?. This makes it easy to
-- see where all occurrences of your search term appear in the file.
opt.hlsearch = true

-- Show a live preview of substitution commands (:s/old/new/) in a split
-- window. This lets you see exactly what will change before confirming.
opt.inccommand = "split"

-- Make searches case-insensitive by default. Searching for "foo" will match
-- "foo", "Foo", "FOO", etc.
opt.ignorecase = true

-- Override ignorecase if the search pattern contains uppercase letters OR
-- uses \C. Searching for "Foo" will only match "Foo", not "foo" or "FOO".
-- This gives you case-insensitive search by default with case-sensitive
-- when you explicitly use uppercase.
opt.smartcase = true

-- Use ripgrep (rg) for the :grep command instead of the default grep.
-- Ripgrep is much faster, respects .gitignore, and has better defaults.
-- PREREQUISITE: ripgrep must be installed (brew install ripgrep)
opt.grepprg = "rg --vimgrep"

-- Format string for parsing ripgrep output. This tells Neovim how to
-- extract the filename, line number, column number, and match text from
-- ripgrep's output so the quickfix list works correctly.
opt.grepformat = "%f:%l:%c:%m"

-- =============================================================================
-- LANGUAGE AND SPELLCHECK
-- =============================================================================
-- Spell checking highlights misspelled words. Use these commands:
--   ]s  : Jump to next misspelled word
--   [s  : Jump to previous misspelled word
--   z=  : Show spelling suggestions for word under cursor
--   zg  : Add word under cursor to dictionary (mark as "good")
--   zw  : Remove word from dictionary (mark as "wrong")

-- Set the language(s) for spell checking. "en" uses the English dictionary.
opt.spelllang = "en"

-- Disable spell checking globally. Enable it per-filetype in the
-- after/ftplugin/ directory for files where it makes sense (markdown,
-- text files, comments in code).
opt.spell = false

-- =============================================================================
-- FILE HANDLING
-- =============================================================================

-- Don't create backup files (filename~). Backups can clutter your directory
-- and are unnecessary with modern version control (git).
opt.backup = false

-- Don't create a backup before overwriting a file. This prevents issues
-- with some file watchers and build tools that monitor file changes.
opt.writebackup = false

-- Don't create swap files (.swp). Swap files protect against crashes but
-- can cause issues with file watchers. We use undofile instead for
-- persistence between sessions.
opt.swapfile = false

-- When a command would fail because of unsaved changes (like :q or :e),
-- prompt to save instead of showing an error. This is more user-friendly.
opt.confirm = true

-- =============================================================================
-- FORMATTING
-- =============================================================================
-- Configure automatic text formatting behavior. formatoptions is a string
-- where each character enables a specific formatting feature.
-- Run `:help fo-table` for the complete list of options.

vim.opt.formatoptions = vim.opt.formatoptions
  + "t" -- Auto-wrap text using 'textwidth' setting (hard wrap)
  + "c" -- Auto-wrap comments using 'textwidth' and insert comment leader
  - "r" -- DON'T insert comment leader after pressing <Enter> in insert mode
  - "o" -- DON'T insert comment leader after pressing 'o' or 'O' in normal mode
  + "q" -- Allow formatting of comments with 'gq' command
  - "a" -- DON'T automatically format paragraphs as you type
  + "n" -- Recognize numbered lists when formatting (maintains list structure)
  + "j" -- Remove comment leader when joining lines (makes code cleaner)

-- =============================================================================
-- MESSAGES
-- =============================================================================

-- Customize which messages Neovim shows. shortmess is a string where each
-- character suppresses a specific type of message. This reduces visual noise.
opt.shortmess:append("IWc")
-- I : Don't show the intro message when starting Neovim
-- W : Don't show "written" message after saving a file
-- c : Don't show completion-related messages ("match 1 of 2", etc.)

-- =============================================================================
-- MISCELLANEOUS
-- =============================================================================

-- Persist undo history to a file so you can undo changes even after closing
-- and reopening a file. Neovim stores these in ~/.local/share/nvim/undo/.
opt.undofile = true

-- Enable mouse support in all modes (normal, visual, insert, command-line).
-- Useful for resizing splits, scrolling, and selecting text. You can still
-- use the keyboard for everything; the mouse is just an additional option.
opt.mouse = "a"

-- Synchronize Neovim's clipboard with the system clipboard. When you yank
-- (copy) text in Neovim, it goes to the system clipboard. When you paste
-- in Neovim, it uses the system clipboard. This makes it easy to copy/paste
-- between Neovim and other applications.
opt.clipboard = "unnamedplus"

-- Always show the sign column (left margin where diagnostic icons appear).
-- This prevents the text from shifting left/right when signs appear or
-- disappear, which can be visually distracting.
opt.signcolumn = "yes"
