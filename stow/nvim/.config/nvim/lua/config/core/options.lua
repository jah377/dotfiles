-- =============================================================================
-- FILE: lua/config/core/options.lua
-- Neovim editor options (vim.opt). Filetype overrides: after/ftplugin/
-- Docs: :help options, :help <option>
-- =============================================================================

local opt = vim.opt

-- PERFORMANCE --
opt.updatetime = 250   -- CursorHold delay (ms). Affects diagnostic popups.
opt.timeoutlen = 300   -- Key sequence timeout (ms). Affects which-key popup.

-- COLORS --
opt.termguicolors = true  -- 24-bit color. Requires modern terminal.

-- INDENTATION --
opt.expandtab = true      -- Insert spaces when pressing Tab
opt.softtabstop = 4       -- Spaces per Tab keypress
opt.shiftwidth = 4        -- Spaces for auto-indent (>>, <<)
opt.tabstop = 4           -- Display width of <Tab> characters
opt.smarttab = true       -- Tab at line start uses shiftwidth
opt.smartindent = true    -- Auto-indent based on syntax
opt.autoindent = true     -- Copy indent from current line

-- WHITESPACE DISPLAY --
vim.opt.list = true       -- Show invisible characters
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

-- LINE WRAPPING --
opt.textwidth = 79        -- Hard wrap at column (PEP 8)
opt.wrap = true           -- Soft wrap long lines visually
opt.breakindent = true    -- Preserve indent on wrapped lines
opt.linebreak = true      -- Wrap at word boundaries

-- LINE NUMBERS --
opt.number = true         -- Show line numbers
opt.relativenumber = true -- Relative to cursor (easier motions like 10j)

-- WINDOW SPLITTING --
opt.splitright = true     -- :vsplit opens right
opt.splitbelow = true     -- :split opens below
opt.winborder = "rounded" -- Floating window borders

-- CURSOR --
opt.cursorline = true     -- Highlight current line
opt.cursorcolumn = false
opt.scrolloff = 10        -- Keep 10 lines visible above/below cursor

-- VISUAL GUIDES --
opt.colorcolumn = ""      -- Column guide (e.g., "80" for line limit)

-- COMMAND-LINE --
opt.showmode = false      -- Mode shown in statusline instead
opt.cmdheight = 0         -- Hide command line until needed

-- COMPLETION MENU --
opt.completeopt = "menu,menuone,noselect"
opt.pumheight = 10        -- Max items in popup
opt.pumblend = 10         -- Popup transparency (0-100)

-- SEARCHING --
opt.hlsearch = true       -- Highlight search matches
opt.inccommand = "split"  -- Live preview of :s/old/new/
opt.ignorecase = true     -- Case-insensitive search
opt.smartcase = true      -- ...unless pattern has uppercase
opt.grepprg = "rg --vimgrep"  -- Use ripgrep for :grep
opt.grepformat = "%f:%l:%c:%m"

-- SPELLCHECK --
-- Commands: ]s/[s (next/prev), z= (suggest), zg (add to dict)
opt.spelllang = "en"
opt.spell = false         -- Enable per-filetype in after/ftplugin/

-- FILE HANDLING --
opt.backup = false        -- No backup files (use git)
opt.writebackup = false
opt.swapfile = false      -- No swap files (use undofile)
opt.confirm = true        -- Prompt to save on :q with unsaved changes

-- FORMATTING --
-- :help fo-table for flag meanings
vim.opt.formatoptions = vim.opt.formatoptions
  + "t"  -- Auto-wrap text at textwidth
  + "c"  -- Auto-wrap comments
  - "r"  -- No comment leader on Enter
  - "o"  -- No comment leader on o/O
  + "q"  -- Format comments with gq
  - "a"  -- No auto-format paragraphs
  + "n"  -- Recognize numbered lists
  + "j"  -- Remove comment leader when joining

-- MESSAGES --
opt.shortmess:append("IWc")  -- Suppress intro, "written", completion msgs

-- MISCELLANEOUS --
opt.undofile = true       -- Persist undo history across sessions
opt.mouse = "a"           -- Enable mouse in all modes
opt.clipboard = "unnamedplus"  -- Use system clipboard
opt.signcolumn = "yes"    -- Always show sign column (prevents shifting)
