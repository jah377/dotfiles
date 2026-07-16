-- =============================================================================
-- FILE: lua/config/core/keymaps.lua
-- Plugin-independent keymaps. Plugin keymaps are in their config files.
-- Leader key is Space (set in globals.lua). Notation: <C-x>=Ctrl+x, n=normal
-- =============================================================================

local kbd = vim.keymap.set

-- Editing ---------------------------------------------------------------------

-- Transfer MacOS kbd to Neovim
kbd("n", "<C-s>", "<cmd>w<CR>", { silent = true }) -- `C-s` to save file
kbd({ "i", "c" }, "<M-BS>", "<C-w>", { noremap = true }) -- `M-del` to del. word
kbd("n", "<M-BS>", "db", { noremap = true }) -- `M-del` to del. word

-- Keep visual selection after indenting (default: deselect)
-- Useful for indenting same text multiple times
kbd("v", "<", "<gv", { desc = "Indent left  and reselect" })
kbd("v", ">", ">gv", { desc = "Indent right and reselect" })

-- Clipboard -------------------------------------------------------------------

kbd("n", "<leader>ym", function()
  local messages = vim.fn.execute "messages"
  vim.fn.setreg("+", messages)
end, { desc = "[Y]ank [M]essages" })

kbd("n", "<leader>yf", function()
  vim.fn.setreg("+", vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":t"))
end, { desc = "[Y]ank [F]ile" })

kbd("n", "<leader>yp", function()
  vim.fn.setreg("+", vim.api.nvim_buf_get_name(0))
end, { desc = "[Y]ank [P]ath" })

-- Navigation ------------------------------------------------------------------

-- Move cursor by visual/display lines instead of actual lines
-- Useful when text is softwrapped (eg. only visually wrapped)
kbd("n", "j", "gj", { desc = "Move down (visual line)" })
kbd("n", "k", "gk", { desc = "Move up (visual line)" })

kbd("n", "<C-d>", "<C-d>zz", { desc = "Half page down (centered)" })
kbd("n", "<C-u>", "<C-u>zz", { desc = "Half page up (centered)" })

-- Search ----------------------------------------------------------------------

-- Clear search highlighting on <esc>
kbd("n", "<Esc>", "<cmd>nohlsearch<CR>")

kbd("n", "n", "nzzzv", { desc = "Next search result (centered)" })
kbd("n", "N", "Nzzzv", { desc = "Previous search result (centered)" })

-- Buffers ---------------------------------------------------------------------

kbd("n", "<leader>bn", "<cmd>bnext<CR>", { desc = "[B]uffer [N]ext" })
kbd("n", "<leader>bp", "<cmd>bprevious<CR>", { desc = "[B]uffer [P]revious" })
kbd("n", "<leader>bd", "<cmd>bdelete<CR>", { desc = "[B]uffer [D]elete" })
kbd("n", "<leader>ba", "<cmd>wa | %bd<CR>", { desc = "[B]uffer [D]elete (save)" })
kbd("n", "<leader>bD", "<cmd>%bd<CR>", { desc = "[B]uffer [D]elete all" })
kbd("n", "<leader>bo", "<cmd>wa | %bd | e#<CR>", { desc = "[B]uffer [D]elete all others (save)" })

-- Quickfix --------------------------------------------------------------------

-- Streamline working with quickfix list
-- Quickfix list built-in way to navigate through list of locations
kbd("n", "<leader>qn", "<cmd>cnext<CR>", { desc = "[Q]uickfix [N]ext" })
kbd("n", "<leader>qp", "<cmd>cprev<CR>", { desc = "[Q]uickfix [P]revious" })
kbd("n", "<leader>qo", "<cmd>copen<CR>", { desc = "[Q]uickfix [O]pen" })
kbd("n", "<leader>qc", "<cmd>cclose<CR>", { desc = "[Q]uickfix [C]lose" })

-- Spelling --------------------------------------------------------------------

-- Spelling commands
-- Toggle spell checking, navigate misspellings, and manage spell dictionary
kbd("n", "<leader>ss", "<cmd>set spell!<CR>", { desc = "[S]pell toggle" })
kbd("n", "<leader>sn", "]s", { desc = "[S]pell [N]ext misspelling" })
kbd("n", "<leader>sp", "[s", { desc = "[S]pell [P]revious misspelling" })
kbd("n", "<leader>sa", "zg", { desc = "[S]pell [A]dd word to dictionary" })
kbd("n", "<leader>sA", "zug", { desc = "[S]pell undo [A]dd (remove from dictionary)" })
kbd("n", "<leader>sr", "zw", { desc = "[S]pell [R]emove word (mark wrong)" })
kbd("n", "<leader>sR", "zuw", { desc = "[S]pell undo [R]emove (unmark wrong)" })
kbd("n", "<leader>sf", "z=", { desc = "[S]pell [F]ix (suggest corrections)" })
