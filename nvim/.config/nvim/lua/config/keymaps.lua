-- Package-specific kbd defined in `config/plugins/<plugin>.lua`
local kmap = vim.keymap

--  Use CTRL+<hjkl> to switch between windows
--  See `:help wincmd` for a list of all window commands
kmap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
kmap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
kmap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
kmap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

-- Simplify saving and quitting files
kmap.set("n", "<leader>w", ":w<CR>", { noremap = true, silent = true })
kmap.set("n", "<leader>w", ":w<CR>", { noremap = true, silent = true })
kmap.set("n", "<leader>q", ":q<CR>", { noremap = true, silent = true })
kmap.set("n", "<leader>q", ":q<CR>", { noremap = true, silent = true })

-- Manipulate buffers
kmap.set("n", "<leader>bn", ":bn<cr>", { desc = "[B]uffer [N]ext" })
kmap.set("n", "<leader>bp", ":bp<cr>", { desc = "[B]uffer [P]revious" })
kmap.set("n", "<leader>bd", ":bd<cr>", { desc = "[B]uffer [D]elete" })
kmap.set("n", "<leader>bw", ":w<CR>", { desc = "Write buffer" })
kmap.set("n", "<leader>bW", ":wq<CR>", { desc = "Write and quit buffer" })
kmap.set("n", "<leader>bq", ":q<CR>", { desc = "Quit buffer" })
kmap.set("n", "<leader>bq", ":q!<CR>", { desc = "Force Quit buffer" })

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
kmap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Quickly execute file at point
kmap.set("n", "<leader>x", function()
  vim.cmd("write")
  vim.cmd("luafile %")
  print("Executed current Lua file!")
end, { desc = "Run current Lua file" })
