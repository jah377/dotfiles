-- ============================================================================
-- FILE: lua/config/core/options.lua
-- Global editor options (vim.opt). Filetype overrides live in after/ftplugin/.
-- Docs: :help options, :help <option>
--
-- Options that merely restate Neovim's defaults are deliberately omitted so
-- that every line here represents a decision.
-- ============================================================================

local opt = vim.opt

-- Misc -----------------------------------------------------------------------

opt.undofile = true -- Persist undo history across sessions
opt.mouse = "a" -- Enable mouse in all modes
opt.clipboard = "unnamedplus" -- Use system clipboard
opt.signcolumn = "yes" -- Always show sign column (prevents shifting)

-- Folding --------------------------------------------------------------------

-- The Folded highlight is linked to Normal in core/highlights.lua so folded
-- lines render like surrounding text.
opt.fillchars:append({ fold = " " }) -- drop trailing "..." when folded
opt.foldtext = "" -- drop custom text when folded
opt.foldlevel = 99 -- no folds on open

-- Performance ----------------------------------------------------------------

opt.updatetime = 250 -- CursorHold delay (ms). Affects diagnostic popups.
opt.timeoutlen = 300 -- Key sequence timeout (ms). Affects which-key popup.

-- Colors ---------------------------------------------------------------------

opt.termguicolors = true -- 24-bit color. Requires modern terminal.

-- Indentation ----------------------------------------------------------------

opt.expandtab = true -- Insert spaces when pressing Tab
opt.softtabstop = 4 -- Spaces per Tab keypress
opt.shiftwidth = 4 -- Spaces for auto-indent (>>, <<)
opt.tabstop = 4 -- Display width of <Tab> characters
opt.smartindent = true -- Auto-indent based on syntax

-- Whitespace -----------------------------------------------------------------

opt.list = true -- Show invisible characters
opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

-- Line Wrapping --------------------------------------------------------------

opt.textwidth = 79 -- Hard wrap at column (PEP 8)
opt.wrap = true -- Soft wrap long lines visually
opt.breakindent = true -- Preserve indent on wrapped lines
opt.linebreak = true -- Wrap at word boundaries

-- Line Numbers ---------------------------------------------------------------

opt.number = true -- Show line numbers
opt.relativenumber = true -- Relative to cursor (easier motions like 10j)

-- Windows --------------------------------------------------------------------

opt.splitright = true -- :vsplit opens right
opt.splitbelow = true -- :split opens below
opt.winborder = "rounded" -- Floating window borders

-- Cursor ---------------------------------------------------------------------

opt.cursorline = true -- Highlight current line (active window only, see autocmds.lua)
opt.scrolloff = 10 -- Keep 10 lines visible above/below cursor

-- Command Line ---------------------------------------------------------------

opt.showmode = false -- Mode shown in statusline instead
opt.cmdheight = 0 -- Hide command line until needed

-- Completion -----------------------------------------------------------------

opt.completeopt = "menu,menuone,noselect"
opt.pumheight = 10 -- Max items in popup
opt.pumblend = 10 -- Popup transparency (0-100)

-- Searching ------------------------------------------------------------------

opt.inccommand = "split" -- Live preview of :s/old/new/
opt.ignorecase = true -- Case-insensitive search
opt.smartcase = true -- ...unless pattern has uppercase
opt.grepprg = "rg --vimgrep" -- Use ripgrep for :grep
opt.grepformat = "%f:%l:%c:%m"

-- Spellcheck -----------------------------------------------------------------

-- Commands: ]s/[s (next/prev), z= (suggest), zg (add to dict)
opt.spelllang = "en"
opt.spell = false -- Enabled per-filetype in after/ftplugin/

-- File handling --------------------------------------------------------------

opt.backup = false -- No backup files (use git)
opt.writebackup = false
opt.swapfile = false -- No swap files (use undofile)
opt.confirm = true -- Prompt to save on :q with unsaved changes

-- Formatting -----------------------------------------------------------------

-- Global default only. Who owns 'formatoptions' (see :help fo-table):
--   1. This file sets the default for buffers whose ftplugin does not care.
--   2. Neovim's runtime ftplugins override it per filetype (lua: `croql`,
--      markdown: `tcqln`, gitcommit: `tl`; python leaves it alone).
--   3. after/ftplugin/<ft>.lua runs after the runtime ftplugin and states the
--      flags that filetype needs (python adds `t` and `c`).
--   4. The FileType autocmd in autocmds.lua runs last. It removes `r` and
--      `o` always, and `c` unless the buffer set `vim.b.wrap_comments`. It
--      must not touch any other flag, or it silently overrides steps 2 and 3.
opt.formatoptions = opt.formatoptions
    + "t" -- Auto-wrap text at textwidth
    - "c" -- No comment auto-wrap by default; per-filetype opt-in (see step 4)
    - "r" -- No comment leader on Enter
    - "o" -- No comment leader on o/O
    + "q" -- Format comments with gq
    - "a" -- No auto-format paragraphs
    + "n" -- Recognize numbered lists
    + "j" -- Remove comment leader when joining

-- Messages -------------------------------------------------------------------

opt.shortmess:append("IWc") -- Suppress intro, "written", completion msgs
