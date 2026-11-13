-- ============================================================================
-- FILE: lua/config/core/keymaps.lua
-- Plugin-independent keymaps. Plugin keymaps live in their spec files. Leader
-- key is Space (set in globals.lua). Notation: <C-x>=Ctrl+x, n=normal.
--
-- CONVENTION:
--   Call vim.keymap.set directly. Earlier revisions aliased it under different
--   names in different files (kbd, keymap, map), so the same word meant
--   different things. A local `map` helper is introduced only where it adds
--   behaviour, eg. a buffer-local map with a description prefix.
--   vim.keymap.set is non-recursive by default, so `noremap` is never passed.
-- ============================================================================

-- Editing --------------------------------------------------------------------

-- Transfer macOS keyboard habits to Neovim
vim.keymap.set("n", "<C-s>", "<cmd>w<CR>", { silent = true, desc = "Save file" })
vim.keymap.set({ "i", "c" }, "<M-BS>", "<C-w>", { desc = "Delete word before cursor" })
vim.keymap.set("n", "<M-BS>", "db", { desc = "Delete word before cursor" })

-- Keep the selection after indenting so the same text can be shifted again.
-- Mode "x" is visual only; "v" would also apply to select mode.
vim.keymap.set("x", "<", "<gv", { desc = "Indent left and reselect" })
vim.keymap.set("x", ">", ">gv", { desc = "Indent right and reselect" })

-- Clipboard ------------------------------------------------------------------

vim.keymap.set("n", "<leader>ym", function() vim.fn.setreg("+", vim.fn.execute("messages")) end, { desc = "[Y]ank [M]essages" })

vim.keymap.set("n", "<leader>yf", function() vim.fn.setreg("+", vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":t")) end, { desc = "[Y]ank [F]ile name" })

vim.keymap.set("n", "<leader>yp", function() vim.fn.setreg("+", vim.api.nvim_buf_get_name(0)) end, { desc = "[Y]ank [P]ath" })

-- Navigation -----------------------------------------------------------------

-- Move by display line through soft-wrapped text, but keep real-line motion
-- when a count is given so `10j` still agrees with 'relativenumber'.
-- `expr = true`: the function returns the keys to execute.
vim.keymap.set("n", "j", function() return vim.v.count == 0 and "gj" or "j" end, { expr = true, desc = "Move down (display line unless counted)" })
vim.keymap.set("n", "k", function() return vim.v.count == 0 and "gk" or "k" end, { expr = true, desc = "Move up (display line unless counted)" })

vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Half page down (centered)" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Half page up (centered)" })

-- Search ---------------------------------------------------------------------

vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear search highlight" })

vim.keymap.set("n", "n", "nzzzv", { desc = "Next search result (centered)" })
vim.keymap.set("n", "N", "Nzzzv", { desc = "Previous search result (centered)" })

-- Buffers --------------------------------------------------------------------

vim.keymap.set("n", "<leader>bn", "<cmd>bnext<CR>", { desc = "[B]uffer [N]ext" })
vim.keymap.set("n", "<leader>bp", "<cmd>bprevious<CR>", { desc = "[B]uffer [P]revious" })
vim.keymap.set("n", "<leader>bd", "<cmd>bdelete<CR>", { desc = "[B]uffer [D]elete" })
vim.keymap.set("n", "<leader>bD", "<cmd>%bd<CR>", { desc = "[B]uffer [D]elete all" })
vim.keymap.set("n", "<leader>ba", "<cmd>wa | %bd<CR>", { desc = "[B]uffer delete [A]ll (save first)" })
vim.keymap.set("n", "<leader>bo", "<cmd>wa | %bd | e#<CR>", { desc = "[B]uffer delete [O]thers (save first)" })

-- Quickfix -------------------------------------------------------------------

-- The quickfix list is the built-in way to step through a list of locations
vim.keymap.set("n", "<leader>qn", "<cmd>cnext<CR>", { desc = "[Q]uickfix [N]ext" })
vim.keymap.set("n", "<leader>qp", "<cmd>cprev<CR>", { desc = "[Q]uickfix [P]revious" })
vim.keymap.set("n", "<leader>qo", "<cmd>copen<CR>", { desc = "[Q]uickfix [O]pen" })
vim.keymap.set("n", "<leader>qc", "<cmd>cclose<CR>", { desc = "[Q]uickfix [C]lose" })

-- Spelling -------------------------------------------------------------------

-- Toggle spell checking, navigate misspellings, and manage the dictionary
vim.keymap.set("n", "<leader>ss", "<cmd>set spell!<CR>", { desc = "[S]pell toggle" })
vim.keymap.set("n", "<leader>sn", "]s", { desc = "[S]pell [N]ext misspelling" })
vim.keymap.set("n", "<leader>sp", "[s", { desc = "[S]pell [P]revious misspelling" })
vim.keymap.set("n", "<leader>sa", "zg", { desc = "[S]pell [A]dd word to dictionary" })
vim.keymap.set("n", "<leader>sA", "zug", { desc = "[S]pell undo [A]dd (remove from dictionary)" })
vim.keymap.set("n", "<leader>sr", "zw", { desc = "[S]pell [R]emove word (mark wrong)" })
vim.keymap.set("n", "<leader>sR", "zuw", { desc = "[S]pell undo [R]emove (unmark wrong)" })
vim.keymap.set("n", "<leader>sf", "z=", { desc = "[S]pell [F]ix (suggest corrections)" })
