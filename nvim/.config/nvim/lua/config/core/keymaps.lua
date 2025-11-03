-- ============================================================================
-- TITLE: NeoVim keymaps
--
-- ABOUT:
--    File sets some quality-of-life keymaps. Package-specific keymaps are
--    define in `~/.config/plugins/<plugin>.lua`
--
-- ============================================================================

local kbd = vim.keymap.set

--  Use CTRL+<hjkl> to switch between windows
--  See `:help wincmd` for a list of all window commands
kbd("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
kbd("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
kbd("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
kbd("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

-- Center screen when jumping
kbd("n", "n", "nzzzv", { desc = "Next search result (centered)" })
kbd("n", "N", "Nzzzv", { desc = "Previous search result (centered)" })
kbd("n", "<C-d>", "<C-d>zz", { desc = "Half page down (centered)" })
kbd("n", "<C-u>", "<C-u>zz", { desc = "Half page up (centered)" })

-- Manipulate buffers
kbd("n", "<leader>bn", ":bn<cr>", { desc = "[B]uffer [N]ext" })
kbd("n", "<leader>bp", ":bp<cr>", { desc = "[B]uffer [P]revious" })
kbd("n", "<leader>bd", ":bd<cr>", { desc = "[B]uffer [D]elete" })

-- Enable re-indenting; by default, '<' indents and deselects
kbd("v", "<", "<gv", { desc = "Indent left  and reselect" })
kbd("v", ">", ">gv", { desc = "Indent right and reselect" })

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
kbd("n", "<Esc>", "<cmd>nohlsearch<CR>")
