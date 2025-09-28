-- ============================================================================
-- TITLE: NeoVim keymaps
--
-- ABOUT:
--    File sets some quality-of-life keymaps. Package-specific keymaps are
--    define in `~/.config/plugins/<plugin>.lua`
--
-- ============================================================================

local kmap = vim.keymap

--  Use CTRL+<hjkl> to switch between windows
--  See `:help wincmd` for a list of all window commands
kmap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
kmap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
kmap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
kmap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

-- Center screen when jumping
vim.keymap.set("n", "n", "nzzzv", { desc = "Next search result (centered)" })
vim.keymap.set("n", "N", "Nzzzv", { desc = "Previous search result (centered)" })
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Half page down (centered)" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Half page up (centered)" })

-- Manipulate buffers
kmap.set("n", "<leader>bn", ":bn<cr>", { desc = "[B]uffer [N]ext" })
kmap.set("n", "<leader>bp", ":bp<cr>", { desc = "[B]uffer [P]revious" })
kmap.set("n", "<leader>bd", ":bd<cr>", { desc = "[B]uffer [D]elete" })

-- Enable re-indenting; by default, indenting exists visual mode
vim.keymap.set("v", "<", "<gv", { desc = "Indent left  and reselect" })
vim.keymap.set("v", ">", ">gv", { desc = "Indent right and reselect" })

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
kmap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")
