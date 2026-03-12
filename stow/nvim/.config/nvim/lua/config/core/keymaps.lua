-- =============================================================================
-- FILE: lua/config/core/keymaps.lua
--
-- PURPOSE:
--   This file defines custom keyboard shortcuts (keymaps) that don't depend on
--   any plugins. Plugin-specific keymaps are defined in their respective plugin
--   configuration files in lua/config/plugins/.
--
--   Keymaps are organized into logical groups:
--   - Search highlighting
--   - Line navigation (for wrapped text)
--   - Screen centering (during jumps)
--   - Buffer management
--   - Visual mode indentation
--   - Quickfix list navigation
--
-- KEYMAP NOTATION:
--   <leader>  : The leader key (Space in this config)
--   <Esc>     : Escape key
--   <CR>      : Enter/Return key
--   <C-x>     : Ctrl+x
--   n         : Normal mode
--   v         : Visual mode
--   i         : Insert mode
--
-- DOCUMENTATION:
--   > vim.keymap.set : https://neovim.io/doc/user/lua.html#vim.keymap.set()
--   > Key notation   : https://neovim.io/doc/user/intro.html#key-notation
--   > Modes          : https://neovim.io/doc/user/intro.html#vim-modes
--
-- =============================================================================

-- Create a local alias for vim.keymap.set to reduce typing.
-- vim.keymap.set(mode, key, action, options) creates a new keybinding.
-- Parameters:
--   mode    : Which mode(s) the keymap applies to ("n", "v", "i", or a table)
--   key     : The key sequence to trigger the action
--   action  : What happens when the key is pressed (string command or function)
--   options : Optional table with 'desc' (description), 'silent', 'noremap', etc.
local kbd = vim.keymap.set

-- =============================================================================
-- SEARCH HIGHLIGHTING
-- =============================================================================

-- Clear search highlighting when pressing Escape in normal mode.
--
-- By default, search matches (from / or ?) remain highlighted until you
-- manually run :nohlsearch. This mapping lets you quickly dismiss the
-- highlighting by pressing Escape.
--
-- The <cmd>...<CR> syntax is more efficient than :... because it doesn't
-- trigger mode changes or update the command history.
kbd("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- =============================================================================
-- LINE NAVIGATION (for wrapped text)
-- =============================================================================

-- Move cursor by visual/display lines instead of actual lines.
--
-- When a long line is soft-wrapped across multiple screen lines, the default
-- j and k commands skip entire actual lines, which can jump many screen lines
-- at once. These mappings make j and k move by screen lines instead:
--
--   j -> gj (move down one DISPLAY line)
--   k -> gk (move up one DISPLAY line)
--
-- This feels more intuitive when editing prose or any wrapped text.
kbd("n", "j", "gj", { desc = "Move down (visual line)" })
kbd("n", "k", "gk", { desc = "Move up (visual line)" })

-- =============================================================================
-- SCREEN CENTERING (during jumps)
-- =============================================================================

-- Center the screen after jumping to the next/previous search match.
--
-- By default, n and N jump to matches but the match might end up at the edge
-- of the screen. These mappings add 'zz' to center the match on screen.
--
-- The 'zv' part opens any folds at the cursor position so you can see the
-- match even if it's inside a closed fold.
kbd("n", "n", "nzzzv", { desc = "Next search result (centered)" })
kbd("n", "N", "Nzzzv", { desc = "Previous search result (centered)" })

-- Center the screen after scrolling half a page up or down.
--
-- By default, Ctrl-D and Ctrl-U scroll but leave the cursor wherever it lands.
-- Adding 'zz' keeps the cursor vertically centered so you always have context
-- above and below.
kbd("n", "<C-d>", "<C-d>zz", { desc = "Half page down (centered)" })
kbd("n", "<C-u>", "<C-u>zz", { desc = "Half page up (centered)" })

-- =============================================================================
-- BUFFER MANAGEMENT
-- =============================================================================
-- Buffers are Neovim's way of keeping multiple files open in memory.
-- Think of them like tabs in a web browser, but more powerful.
-- Use :ls to see all open buffers, or use Telescope (<leader>fb).

-- Navigate to the next buffer in the buffer list.
-- Useful for cycling through open files without using the mouse.
kbd("n", "<leader>bn", ":bnext <cr>", { desc = "Next buffer" })

-- Navigate to the previous buffer in the buffer list.
kbd("n", "<leader>bp", ":bprevious <cr>", { desc = "Previous buffer" })

-- Delete (close) the current buffer.
-- This removes the file from memory but doesn't close the window.
-- If it's the last buffer, Neovim will show an empty buffer.
kbd("n", "<leader>bd", ":bdelete <cr>", { desc = "Delete buffer" })

-- Save all buffers and then delete all buffers.
-- Useful for "cleaning up" when you want to start fresh.
-- The 'wa' command writes (saves) all modified buffers.
-- The '%bd' command deletes all buffers.
kbd("n", "<leader>ba", ":wa | %bd<cr>", { desc = "Save & delete all buffers" })

-- Save all buffers, delete all buffers, then reopen the most recent one.
-- This closes everything except the file you were just editing.
-- The 'e#' command edits the alternate (previous) file.
kbd("n", "<leader>bo", ":wa | %bd | e# <cr>", { desc = "Save & delete other buffers" })

-- =============================================================================
-- VISUAL MODE INDENTATION
-- =============================================================================

-- Keep visual selection after indenting left with <.
--
-- By default, pressing < or > in visual mode indents the selected text but
-- then exits visual mode. These mappings re-select the text immediately
-- (gv = "go back to previous visual selection") so you can:
--   1. Keep indenting/un-indenting without re-selecting
--   2. See exactly what text is affected
kbd("v", "<", "<gv", { desc = "Indent left  and reselect" })

-- Keep visual selection after indenting right with >.
kbd("v", ">", ">gv", { desc = "Indent right and reselect" })

-- =============================================================================
-- QUICKFIX LIST NAVIGATION
-- =============================================================================
-- The quickfix list is Neovim's built-in way of navigating through a list of
-- locations (like search results, compiler errors, or grep matches).
-- Commands like :grep, :make, and :vimgrep populate the quickfix list.
-- Many plugins (Telescope, LSP) can also send results to the quickfix list.

-- Jump to the next item in the quickfix list.
-- Each item typically represents a file location (filename:line:column).
kbd("n", "<leader>qn", ":cnext<CR>", { desc = "[Q]uickfix [N]ext" })

-- Jump to the previous item in the quickfix list.
kbd("n", "<leader>qp", ":cprev<CR>", { desc = "[Q]uickfix [P]revious" })

-- Open the quickfix window at the bottom of the screen.
-- This shows all items in the list so you can see and navigate them.
kbd("n", "<leader>qo", ":copen<CR>", { desc = "[Q]uickfix [O]pen" })

-- Close the quickfix window.
kbd("n", "<leader>qc", ":cclose<CR>", { desc = "[Q]uickfix [C]lose" })
