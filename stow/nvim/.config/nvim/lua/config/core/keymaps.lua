-- =============================================================================
-- FILE: lua/config/core/keymaps.lua
-- Plugin-independent keymaps. Plugin keymaps are in their config files.
-- Leader key is Space (set in globals.lua). Notation: <C-x>=Ctrl+x, n=normal
-- =============================================================================

local kbd = vim.keymap.set

-- SEARCH --
kbd("n", "<Esc>", "<cmd>nohlsearch<CR>")  -- Clear search highlighting

-- LINE NAVIGATION (wrapped text) --
-- j/k move by display line, not actual line (useful for soft-wrapped prose)
kbd("n", "j", "gj", { desc = "Move down (visual line)" })
kbd("n", "k", "gk", { desc = "Move up (visual line)" })

-- SCREEN CENTERING --
-- Keep cursor centered after jumps
kbd("n", "n", "nzzzv", { desc = "Next search result (centered)" })
kbd("n", "N", "Nzzzv", { desc = "Previous search result (centered)" })
kbd("n", "<C-d>", "<C-d>zz", { desc = "Half page down (centered)" })
kbd("n", "<C-u>", "<C-u>zz", { desc = "Half page up (centered)" })

-- BUFFER MANAGEMENT --
kbd("n", "<leader>bn", ":bnext <cr>", { desc = "Next buffer" })
kbd("n", "<leader>bp", ":bprevious <cr>", { desc = "Previous buffer" })
kbd("n", "<leader>bd", ":bdelete <cr>", { desc = "Delete buffer" })
kbd("n", "<leader>ba", ":wa | %bd<cr>", { desc = "Save & delete all buffers" })
kbd("n", "<leader>bo", ":wa | %bd | e# <cr>", { desc = "Save & delete other buffers" })

-- VISUAL MODE INDENTATION --
-- Reselect after indent so you can repeat
kbd("v", "<", "<gv", { desc = "Indent left  and reselect" })
kbd("v", ">", ">gv", { desc = "Indent right and reselect" })

-- QUICKFIX LIST --
kbd("n", "<leader>qn", ":cnext<CR>", { desc = "[Q]uickfix [N]ext" })
kbd("n", "<leader>qp", ":cprev<CR>", { desc = "[Q]uickfix [P]revious" })
kbd("n", "<leader>qo", ":copen<CR>", { desc = "[Q]uickfix [O]pen" })
kbd("n", "<leader>qc", ":cclose<CR>", { desc = "[Q]uickfix [C]lose" })
