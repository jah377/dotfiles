-- ============================================================================
-- TITLE: NeoVim keymaps
--
-- ABOUT:
--    File sets some quality-of-life keymaps. Package-specific keymaps are
--    define in `~/.config/plugins/<plugin>.lua`
--
-- ============================================================================

local kbd = vim.keymap.set

-- Move by visual line (not actual line) for wrapped text
kbd("n", "j", "gj", { desc = "Move down (visual line)" })
kbd("n", "k", "gk", { desc = "Move up (visual line)" })

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

-- Quickfix navigation
kbd("n", "<leader>qn", ":cnext<CR>", { desc = "[Q]uickfix [N]ext" })
kbd("n", "<leader>qp", ":cprev<CR>", { desc = "[Q]uickfix [P]revious" })
kbd("n", "<leader>qo", ":copen<CR>", { desc = "[Q]uickfix [O]pen" })
kbd("n", "<leader>qc", ":cclose<CR>", { desc = "[Q]uickfix [C]lose" })
