-- =============================================================================
-- FILE: lua/config/plugins/vim-tmux-navigator.lua
--
-- PURPOSE:
--   Configures vim-tmux-navigator, which enables seamless navigation between
--   Neovim splits and tmux panes using the same keyboard shortcuts. Without
--   this plugin, you'd need different keys to move between Vim splits vs
--   tmux panes.
--
-- WHY USE THIS?
--   - Use Ctrl+h/j/k/l to move in any direction
--   - Works identically whether moving between:
--     - Neovim splits (windows within Neovim)
--     - tmux panes (windows within tmux)
--   - No need to remember which context you're in
--
-- KEYMAPS:
--   Ctrl-h : Move to the split/pane on the left
--   Ctrl-j : Move to the split/pane below
--   Ctrl-k : Move to the split/pane above
--   Ctrl-l : Move to the split/pane on the right
--   Ctrl-\ : Move to the previous split/pane
--
-- PREREQUISITE:
--   You must also configure tmux to work with this plugin.
--   See: ~/.config/tmux/remappings.conf for the tmux side configuration.
--
-- DOCUMENTATION:
--   > GitHub : https://github.com/christoomey/vim-tmux-navigator
--
-- =============================================================================

return {
  -- Plugin identifier from GitHub
  "christoomey/vim-tmux-navigator",

  -- Load immediately at startup (not lazy loaded).
  -- Navigation keymaps should be available from the moment Neovim starts.
  lazy = false,

  -- 'init' runs BEFORE the plugin loads (unlike 'config' which runs after).
  -- We set global variables here that the plugin reads during its setup.
  init = function()
    -- Preserve tmux zoom state when navigating from Neovim to a tmux pane.
    --
    -- By default, navigating from Vim to tmux would unzoom a zoomed pane.
    -- With this setting, if you have a tmux pane zoomed and navigate away
    -- from Neovim, the pane stays zoomed. This prevents accidentally
    -- losing your zoomed state.
    vim.g.tmux_navigator_preserve_zoom = 1
  end,

  -- Define the navigation keymaps.
  -- These override Vim's default Ctrl+h/j/k/l behavior to also work with tmux.
  keys = {
    -- Navigate left (to the split/pane on the left)
    -- <C-U> clears any count prefix before running the command
    { "<C-h>", "<cmd><C-U>TmuxNavigateLeft<cr>" },

    -- Navigate down (to the split/pane below)
    { "<C-j>", "<cmd><C-U>TmuxNavigateDown<cr>" },

    -- Navigate up (to the split/pane above)
    { "<C-k>", "<cmd><C-U>TmuxNavigateUp<cr>" },

    -- Navigate right (to the split/pane on the right)
    { "<C-l>", "<cmd><C-U>TmuxNavigateRight<cr>" },

    -- Navigate to the previous split/pane (like Alt-Tab for windows)
    { "<C-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>" },
  },
}
