-- =============================================================================
-- FILE: lua/config/core/options.lua
-- Neovim editor options (vim.opt). Filetype overrides: after/ftplugin/
-- Docs: :help options, :help <option>
-- =============================================================================

local opt = vim.opt

-- Performance options
opt.updatetime = 250 -- CursorHold delay (ms). Affects diagnostic popups.
opt.timeoutlen = 300 -- Key sequence timeout (ms). Affects which-key popup.

-- Colors
opt.termguicolors = true -- 24-bit color. Requires modern terminal.

-- Indentation
opt.expandtab = true -- Insert spaces when pressing Tab
opt.softtabstop = 4 -- Spaces per Tab keypress
opt.shiftwidth = 4 -- Spaces for auto-indent (>>, <<)
opt.tabstop = 4 -- Display width of <Tab> characters
opt.smarttab = true -- Tab at line start uses shiftwidth
opt.smartindent = true -- Auto-indent based on syntax
opt.autoindent = true -- Copy indent from current line

-- Whitespace Display
vim.opt.list = true -- Show invisible characters
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

-- Line Wrapping
opt.textwidth = 79 -- Hard wrap at column (PEP 8)
opt.wrap = true -- Soft wrap long lines visually
opt.breakindent = true -- Preserve indent on wrapped lines
opt.linebreak = true -- Wrap at word boundaries

-- Visualizing Line Numbers
opt.number = true -- Show line numbers
opt.relativenumber = true -- Relative to cursor (easier motions like 10j)

-- Window Splitting
opt.splitright = true -- :vsplit opens right
opt.splitbelow = true -- :split opens below
opt.winborder = "rounded" -- Floating window borders

-- Cursor
opt.cursorline = true -- Highlight current line
opt.cursorcolumn = false
opt.scrolloff = 10 -- Keep 10 lines visible above/below cursor

-- Visual Guides
opt.colorcolumn = "" -- Column guide (e.g., "80" for line limit)

-- Command-line
opt.showmode = false -- Mode shown in statusline instead
opt.cmdheight = 0 -- Hide command line until needed

-- Completion Menu
opt.completeopt = "menu,menuone,noselect"
opt.pumheight = 10 -- Max items in popup
opt.pumblend = 10 -- Popup transparency (0-100)

-- Searching
opt.hlsearch = true -- Highlight search matches
opt.inccommand = "split" -- Live preview of :s/old/new/
opt.ignorecase = true -- Case-insensitive search
opt.smartcase = true -- ...unless pattern has uppercase
opt.grepprg = "rg --vimgrep" -- Use ripgrep for :grep
opt.grepformat = "%f:%l:%c:%m"

-- Spellcheck
-- Commands: ]s/[s (next/prev), z= (suggest), zg (add to dict)
opt.spelllang = "en"
opt.spell = false -- Enable per-filetype in after/ftplugin/

-- File handling
opt.backup = false -- No backup files (use git)
opt.writebackup = false
opt.swapfile = false -- No swap files (use undofile)
opt.confirm = true -- Prompt to save on :q with unsaved changes

-- Formatting
-- :help fo-table for flag meanings
-- Note: ftplugins reset formatoptions, so autocmds.lua re-applies -r -o
vim.opt.formatoptions = vim.opt.formatoptions
  + "t" -- Auto-wrap text at textwidth
  + "c" -- Auto-wrap comments
  - "r" -- No comment leader on Enter
  - "o" -- No comment leader on o/O
  + "q" -- Format comments with gq
  - "a" -- No auto-format paragraphs
  + "n" -- Recognize numbered lists
  + "j" -- Remove comment leader when joining

-- Messages
opt.shortmess:append("IWc") -- Suppress intro, "written", completion msgs

-- Other
opt.undofile = true -- Persist undo history across sessions
opt.mouse = "a" -- Enable mouse in all modes
opt.clipboard = "unnamedplus" -- Use system clipboard
opt.signcolumn = "yes" -- Always show sign column (prevents shifting)
