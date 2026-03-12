-- =============================================================================
-- FILE: lua/config/plugins/vim-slime.lua
--
-- PURPOSE:
--   Configures vim-slime, which sends code from Neovim to a REPL (Read-Eval-
--   Print-Loop) running in another terminal pane. This enables interactive
--   development where you write code in Neovim and execute it in IPython.
--
-- WHAT IS A REPL?
--   A REPL is an interactive programming environment (like IPython for Python).
--   You type code, it executes immediately, and you see the result. Slime lets
--   you send code from your editor to the REPL without copy-pasting.
--
-- WORKFLOW:
--   1. Split your tmux window: Neovim on left, IPython on right
--   2. Write Python code in Neovim
--   3. Use keymaps to send code to IPython
--   4. See results immediately in the REPL
--
-- KEYMAPS:
--   Ctrl-c l     : Send current line to REPL
--   Ctrl-c Ctrl-c: Send visual selection to REPL
--   Ctrl-c c     : Send current cell and move to next
--   Ctrl-c j     : Jump to next cell
--   Ctrl-c k     : Jump to previous cell
--   Ctrl-c i     : Insert new cell below cursor
--   Ctrl-c I     : Insert new cell above cursor
--
-- CELL SYNTAX:
--   Cells are delimited by special comments (like Jupyter notebooks):
--   # %%    <- This marks the start of a new cell
--   code here
--   # %%    <- Next cell starts here
--
-- PREREQUISITES:
--   - tmux must be running
--   - IPython should be in the pane to the right of Neovim
--
-- DOCUMENTATION:
--   > vim-slime       : https://github.com/jpalardy/vim-slime
--   > vim-slime-cells : https://github.com/klafyvel/vim-slime-cells
--
-- =============================================================================

return {
  -- vim-slime: The core plugin for sending text to a REPL
  {
    "jpalardy/vim-slime",

    -- Only load for Python files (our primary REPL use case)
    ft = { "python" },

    -- Keymaps that also trigger lazy loading
    keys = {
      -- Send the current line to the REPL
      { "<C-C>l", "<Plug>SlimeLineSend", desc = "Slime: Send Line", buffer = true },
    },

    config = function()
      -- Configure slime to use tmux as the target terminal.
      -- Slime supports many targets (tmux, screen, neovim terminal, etc.)
      vim.g.slime_target = "tmux"

      -- Enable bracketed paste mode for IPython.
      -- This prevents IPython from executing code as it's being pasted,
      -- which would cause issues with multi-line code blocks.
      vim.g.slime_bracketed_paste = 1

      -- Enable IPython-specific features (smart indentation handling)
      vim.g.slime_python_ipython = 1

      -- Disable slime's default keymaps (we define our own below)
      vim.g.slime_no_mappings = 1

      -- Don't prompt for tmux target configuration.
      -- Uses slime_default_config instead.
      vim.g.slime_dont_ask_config = 1

      -- Configure the default tmux target.
      -- This tells slime where to send the code.
      vim.g.slime_default_config = {
        socket_name = "default",    -- tmux socket name
        target_pane = "{right-of}", -- Send to the pane on the right
      }

      -- Visual mode: Send selection to REPL
      vim.keymap.set("v", "<C-c><C-c>", ":SlimeSend", { desc = "Slime: Send", buffer = true })

      -- Insert cell delimiter below current line
      -- Creates a new cell boundary for notebook-style development
      vim.keymap.set({ "n", "i" }, "<C-c>i", function()
        local line = vim.api.nvim_win_get_cursor(0)[1]  -- Get current line number
        -- Insert blank line and cell delimiter after current line
        vim.api.nvim_buf_set_lines(0, line, line, false, { "", vim.b.slime_cell_delimiter })
      end, { desc = "Slime: Create Cell Below", buffer = true })

      -- Insert cell delimiter above current line
      vim.keymap.set({ "n", "i" }, "<C-c>I", function()
        local line = vim.api.nvim_win_get_cursor(0)[1]  -- Get current line number
        -- Insert cell delimiter and blank line before current line
        vim.api.nvim_buf_set_lines(0, line - 1, line - 1, false, { vim.b.slime_cell_delimiter, "" })
      end, { desc = "Slime: Create Cell Above", buffer = true })
    end,
  },

  -- vim-slime-cells: Adds cell navigation and execution
  -- Provides notebook-like cell workflow for Python development
  {
    "klafyvel/vim-slime-cells",

    -- Keymaps for cell operations
    keys = {
      -- Send current cell to REPL and move to next cell
      -- Great for stepping through code cell by cell
      { "<C-c>c", "<Plug>SlimeCellsSendAndGoToNext", desc = "Slime: Send Cell", buffer = true },

      -- Navigate to the next cell (without executing)
      { "<C-c>j", "<Plug>SlimeCellsNext", desc = "Slime: Next Cell", buffer = true },

      -- Navigate to the previous cell
      { "<C-c>k", "<Plug>SlimeCellsPrev", desc = "Slime: Previous Cell", buffer = true },
    },
  },
}

-- NOTE: The commented-out code below is an alternative configuration using
-- vim-slime-cells.nvim instead of vim-slime-cells. It's kept for reference
-- but not currently used.
