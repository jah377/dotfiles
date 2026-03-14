-- =============================================================================
-- FILE: lua/config/plugins/vim-tmux-navigator.lua
-- Seamless navigation between Neovim and tmux panes using j/k/h/l
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
  "christoomey/vim-tmux-navigator",
  lazy = false,

  -- Must preserve tmux zoom state before the plugin loads
  init = function()
    -- Preserve tmux zoom state when navigating from Neovim to a tmux pane.
    --
    -- By default, navigating from Vim to tmux would unzoom a zoomed pane.
    -- With this setting, if you have a tmux pane zoomed and navigate away
    -- from Neovim, the pane stays zoomed. This prevents accidentally
    -- losing your zoomed state.
    vim.g.tmux_navigator_preserve_zoom = 1
  end,

  keys = {
    { "<C-h>", "<cmd><C-U>TmuxNavigateLeft<cr>" },
    { "<C-j>", "<cmd><C-U>TmuxNavigateDown<cr>" },
    { "<C-k>", "<cmd><C-U>TmuxNavigateUp<cr>" },
    { "<C-l>", "<cmd><C-U>TmuxNavigateRight<cr>" },
    { "<C-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>" },
  },
}
