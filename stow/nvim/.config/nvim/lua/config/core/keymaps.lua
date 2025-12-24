-- [[ Package-Agnostic Keymappings ]]
-- Package-specific keymaps defined in `plugins/<file>.lua`

local kbd = vim.keymap.set

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
kbd("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- [[ Move by visual line (not actual line) for wrapped text ]]
kbd("n", "j", "gj", { desc = "Move down (visual line)" })
kbd("n", "k", "gk", { desc = "Move up (visual line)" })

-- [[ Center screen when jumping ]]
kbd("n", "n", "nzzzv", { desc = "Next search result (centered)" })
kbd("n", "N", "Nzzzv", { desc = "Previous search result (centered)" })
kbd("n", "<C-d>", "<C-d>zz", { desc = "Half page down (centered)" })
kbd("n", "<C-u>", "<C-u>zz", { desc = "Half page up (centered)" })

-- [[ Manipulate buffers ]]
kbd("n", "<leader>bn", ":bnext <cr>", { desc = "Next buffer" })
kbd("n", "<leader>bp", ":bprevious <cr>", { desc = "Previous buffer" })
kbd("n", "<leader>bd", ":bdelete <cr>", { desc = "Delete buffer" })
-- write all | delete all buffers | edit most recent buffer
kbd("n", "<leader>ba", ":wa | %bd<cr>", { desc = "Save & delete all buffers" })
kbd("n", "<leader>bo", ":wa | %bd | e# <cr>", { desc = "Save & delete other buffers" })

-- [[ Enable re-indenting ]]
-- By default, `<` indents and deselects
kbd("v", "<", "<gv", { desc = "Indent left  and reselect" })
kbd("v", ">", ">gv", { desc = "Indent right and reselect" })

-- [[ Quickfix navigation ]]
kbd("n", "<leader>qn", ":cnext<CR>", { desc = "[Q]uickfix [N]ext" })
kbd("n", "<leader>qp", ":cprev<CR>", { desc = "[Q]uickfix [P]revious" })
kbd("n", "<leader>qo", ":copen<CR>", { desc = "[Q]uickfix [O]pen" })
kbd("n", "<leader>qc", ":cclose<CR>", { desc = "[Q]uickfix [C]lose" })
