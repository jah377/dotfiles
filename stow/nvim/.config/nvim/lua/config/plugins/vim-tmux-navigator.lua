-- [[ Seamless navigation between tmux panes and vim splits ]]
-- Requires corresponding tmux configuration
-- See: ~/.config/tmux/remappings.conf
-- See: https://github.com/christoomey/vim-tmux-navigator

return {
  "christoomey/vim-tmux-navigator",
  lazy = false, -- load immediately
  init = function()
    -- Keep tmux window zoomed when moving from Vim to another pane
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
