-- =============================================================================
-- FILE: lua/config/core/keymaps.lua
-- Plugin-independent keymaps. Plugin keymaps are in their config files.
-- Leader key is Space (set in globals.lua). Notation: <C-x>=Ctrl+x, n=normal
-- =============================================================================

local kbd = vim.keymap.set

-- Clear search highlighting on <esc>
kbd("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Move cursor by visual/display lines instead of actual lines
-- Useful when text is softwrapped (eg. only visually wrapped)
kbd("n", "j", "gj", { desc = "Move down (visual line)" })
kbd("n", "k", "gk", { desc = "Move up (visual line)" })

-- Center screen after jumping to search results
kbd("n", "n", "nzzzv", { desc = "Next search result (centered)" })
kbd("n", "N", "Nzzzv", { desc = "Previous search result (centered)" })

-- Center screen after scrolling page
kbd("n", "<C-d>", "<C-d>zz", { desc = "Half page down (centered)" })
kbd("n", "<C-u>", "<C-u>zz", { desc = "Half page up (centered)" })

-- Quickly navigate, save, or delete buffers
kbd("n", "<leader>bn", ":bnext <cr>", { desc = "Next buffer" })
kbd("n", "<leader>bp", ":bprevious <cr>", { desc = "Previous buffer" })
kbd("n", "<leader>bd", ":bdelete <cr>", { desc = "Delete buffer" })
kbd("n", "<leader>ba", ":wa | %bd<cr>", { desc = "Save & delete all buffers" })
kbd("n", "<leader>bo", ":wa | %bd | e# <cr>", { desc = "Save & delete other buffers" })

-- Keep visual selection after indenting (default: deselect)
-- Useful for indenting same text multiple times
kbd("v", "<", "<gv", { desc = "Indent left  and reselect" })
kbd("v", ">", ">gv", { desc = "Indent right and reselect" })

-- Streamline working with quickfix list
-- Quickfix list built-in way to navigate through list of locations
kbd("n", "<leader>qn", ":cnext<CR>", { desc = "[Q]uickfix [N]ext" })
kbd("n", "<leader>qp", ":cprev<CR>", { desc = "[Q]uickfix [P]revious" })
kbd("n", "<leader>qo", ":copen<CR>", { desc = "[Q]uickfix [O]pen" })
kbd("n", "<leader>qc", ":cclose<CR>", { desc = "[Q]uickfix [C]lose" })

-- Spelling commands
-- Toggle spell checking, navigate misspellings, and manage spell dictionary
kbd("n", "<leader>ss", ":set spell!<CR>", { desc = "[S]pell toggle" })
kbd("n", "<leader>sn", "]s", { desc = "[S]pell [N]ext misspelling" })
kbd("n", "<leader>sp", "[s", { desc = "[S]pell [P]revious misspelling" })
kbd("n", "<leader>sa", "zg", { desc = "[S]pell [A]dd word to dictionary" })
kbd("n", "<leader>sA", "zug", { desc = "[S]pell undo [A]dd (remove from dictionary)" })
kbd("n", "<leader>sr", "zw", { desc = "[S]pell [R]emove word (mark wrong)" })
kbd("n", "<leader>sR", "zuw", { desc = "[S]pell undo [R]emove (unmark wrong)" })
kbd("n", "<leader>sf", "z=", { desc = "[S]pell [F]ix (suggest corrections)" })

-- Markdown navigation
-- Jump between headings and toggle checkboxes (works in any markdown file)
kbd("n", "<leader>mn", "/^#\\+ <CR>:nohlsearch<CR>", { desc = "[M]arkdown [N]ext heading" })
kbd("n", "<leader>mp", "?^#\\+ <CR>:nohlsearch<CR>", { desc = "[M]arkdown [P]revious heading" })
kbd("n", "<leader>mc", function()
  local line = vim.api.nvim_get_current_line()
  local new_line
  if line:match("%[x%]") then
    new_line = line:gsub("%[x%]", "[ ]", 1)
  else
    new_line = line:gsub("%[ %]", "[x]", 1)
  end
  if new_line and new_line ~= line then
    vim.api.nvim_set_current_line(new_line)
  end
end, { desc = "[M]arkdown toggle [C]heckbox" })

-- Markdown folding
-- Requires treesitter or foldmethod=expr with markdown support
kbd("n", "<leader>mft", "za", { desc = "[M]arkdown [F]old [T]oggle" })
kbd("n", "<leader>mfo", "zR", { desc = "[M]arkdown [F]olds [O]pen all" })
kbd("n", "<leader>mfc", "zM", { desc = "[M]arkdown [F]olds [C]lose all" })

-- Section navigation (top-level headings only)
kbd("n", "<leader>m1n", "/^# <CR>:nohlsearch<CR>", { desc = "[M]arkdown H[1] [N]ext" })
kbd("n", "<leader>m1p", "?^# <CR>:nohlsearch<CR>", { desc = "[M]arkdown H[1] [P]revious" })
kbd("n", "<leader>m2n", "/^## <CR>:nohlsearch<CR>", { desc = "[M]arkdown H[2] [N]ext" })
kbd("n", "<leader>m2p", "?^## <CR>:nohlsearch<CR>", { desc = "[M]arkdown H[2] [P]revious" })
