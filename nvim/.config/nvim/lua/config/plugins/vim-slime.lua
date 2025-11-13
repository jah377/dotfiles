return {
  "jpalardy/vim-slime",
  config = function()
    vim.g.slime_target = "tmux"
    vim.g.slime_bracketed_paste = 1
    vim.g.slime_python_ipython = 1

    -- Workflow -> run nvim in a split tmux window with REPL in other pane
    vim.g.slime_default_config = {
      socket_name = vim.fn.get(vim.fn.split(vim.env.TMUX, ","), 0),
      target_pane = ":.2",
    }
  end,
}
