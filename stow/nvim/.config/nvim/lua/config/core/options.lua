-- [[ Settings options ]]
-- File-specific settings in 'after/ftplugin/<ft>.lua'

-- See `:help vim.o`
local opt = vim.opt

-- Performance
opt.updatetime = 250 -- faster completion/events (default: 4000ms)
opt.timeoutlen = 300 -- time to wait for mapped sequence (affects which-key)

-- Colors
opt.termguicolors = true -- enable 24-bit RGB colors

-- Indentation
opt.expandtab = true -- convert tabs to spaces
opt.softtabstop = 4 -- n spaces applied with <Tab>
opt.shiftwidth = 4 -- n spaces when indenting with << & >
opt.tabstop = 4 -- n spaces shown per tab
opt.smarttab = true -- context-aware <Tab> indentation
opt.smartindent = true -- context-aware indentation on new line
opt.autoindent = true -- copy indentation from previous line

-- Sets how neovim will display certain whitespace characters in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
vim.opt.list = true -- show white space
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

-- Line wrapping
opt.textwidth = 79 -- max line length before hard wrapping
opt.wrap = true -- visually break long lines (soft-wrap)
opt.breakindent = true -- soft-wrap maintains indentation as previous line
opt.linebreak = true -- soft-wrap at word boundary

-- Line numbers
opt.number = true -- display line numbers
opt.relativenumber = true -- use "relative" line numbers instead

-- Window splitting
opt.splitright = true -- vertical splits to the right
opt.splitbelow = true -- horizontal splits below
opt.winborder = "rounded" -- border style of float window

-- Cursor
opt.cursorline = true -- highlight line at point
opt.cursorcolumn = false -- highlight column at point
opt.scrolloff = 10 -- min. lines displayed above/below point

-- Visual guides
opt.colorcolumn = "" -- visual guide at 80 chars

-- Command-line
opt.showmode = false -- defer to statusline
opt.cmdheight = 0 -- disable until needed

-- Completion menu
opt.completeopt = "menu,menuone,noselect" -- better completion experience
opt.pumheight = 10 -- max items to show in popup menu
opt.pumblend = 10 -- popup menu transparency (0-100)

-- Searching and Substitutions
opt.hlsearch = true -- highlight search results
opt.inccommand = "split" -- live preview substitutions
opt.ignorecase = true -- case-insensitive searching
opt.smartcase = true -- override if \C or 1+ uppercase in search
opt.grepprg = "rg --vimgrep" -- use ripgrep for :grep
opt.grepformat = "%f:%l:%c:%m" -- format for ripgrep results

-- Language and Spellcheck
-- ']s' to jump to next mistake
-- '[s' to jump to previous mistake
-- 'z=' to see suggestions
-- 'zg' to add to dictionary
-- 'zw' to remove from dictionary
opt.spelllang = "en"
opt.spell = false -- enable per-ft in 'after/ftplugin/'

-- File handling
opt.backup = false -- don't create backup files
opt.writebackup = false -- don't backup before overwriting
opt.swapfile = false -- don't use swapfile (we have undofile)
opt.confirm = true -- ask to save instead of failing commands

-- Formatting (default: 'tcqj')
vim.opt.formatoptions = vim.opt.formatoptions
  + "t" -- auto-wrap text using 'textwidth'
  + "c" -- auto-wrap comment + insert comment leader
  - "r" -- insert comment leader after <enter>
  - "o" -- insert comment leader after 'o' or 'O'
  + "q" -- allow formatting with 'gq'
  - "a" -- auto format paragraphs (only comments if 'c' set)
  + "n" -- recognize number lists when formatting
  + "j" -- auto-remove comments when joining lines

-- Messages
opt.shortmess:append("IWc")
-- I: don't show intro message
-- W: don't show "written" when saving
-- c: don't show completion messages

-- Misc.
opt.undofile = true -- store undos between sessions
opt.mouse = "a" -- enable mouse-mode; useful for resizing splits
opt.clipboard = "unnamedplus" -- sync clipboard between OS and nvim
opt.signcolumn = "yes" -- avoid buffer shifting when sign displayed
