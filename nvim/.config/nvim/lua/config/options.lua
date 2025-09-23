local opt = vim.opt

vim.g.have_nerd_font = true -- must have NF installed & selected in terminal

-- Indentation
opt.expandtab = true -- convert tabs to spaces
opt.softtabstop = 4 -- n spaces applied with <Tab>
opt.shiftwidth = 4 -- n spaces when indenting with << & >
opt.tabstop = 4 -- n spaces shown per tab
opt.smarttab = true -- context-aware <Tab> indentation
opt.smartindent = true -- contaxt-aware indentation on new line
opt.autoindent = true -- copy indentation from prev. line

-- Whitespace
opt.list = true -- show whitespace
opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

-- Line wrapping
opt.textwidth = 79 -- max line length before hard wrapping
opt.wrap = true -- visually break long lines (soft-wrap)
opt.breakindent = true -- soft-wrap maintains indentation as previous line
opt.linebreak = true -- soft-wrap at word boundary
opt.formatoptions:append("tcqvb]") --

-- Line numbers
opt.number = true -- add line numbers
opt.relativenumber = true -- display relative line numbers

-- Window splitting
opt.splitright = true -- vertical splits to the right
opt.splitbelow = true -- horizontal splits below
opt.winborder = "rounded" -- border style of float window

-- Cursor
opt.cursorline = true -- highlight line at point
opt.cursorcolumn = false -- highlight column at point
opt.scrolloff = 10 -- min. lines displayed above/below point

-- Command-line
opt.showmode = false -- defer to statusline
opt.cmdheight = 0 -- disable until needed

-- Searching and Substitutions
opt.ignorecase = true -- case-insensitive searching
opt.smartcase = true -- override if \C or 1+ uppercase in search term
opt.inccommand = "split" -- live preview substitutions

-- Language and Spellcheck
-- `]s` (next), `[s` (prev), `]zq` (add to dict), `zw` (rm from dict)
opt.spelllang = "en"
opt.spell = true

-- Misc.
opt.undofile = true -- store undos between sessions
opt.mouse = "a" -- enable mouse-mode; useful for resizing splits
opt.clipboard = "unnamedplus" -- sync clipboard between OS and nvim
opt.signcolumn = "yes" -- avoid buffer shifting when sign displayed
