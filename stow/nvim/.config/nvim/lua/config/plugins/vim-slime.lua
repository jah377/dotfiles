return {
  {
    "jpalardy/vim-slime",
    ft = { "python" },
    keys = {
      { "<C-C>l", "<Plug>SlimeLineSend", desc = "Slime: Send Line", buffer = true },
    },
    config = function()
      vim.g.slime_target = "tmux"
      vim.g.slime_bracketed_paste = 1 -- if using IPython
      vim.g.slime_python_ipython = 1
      vim.g.slime_no_mappings = 1
      vim.g.slime_dont_ask_config = 1

      -- Workflow -> run nvim in a split tmux window with REPL in other pane
      vim.g.slime_default_config = {
        socket_name = "default",
        target_pane = "{right-of}", -- Adjust based on your tmux layout
      }

      vim.keymap.set("v", "<C-c><C-c>", ":SlimeSend", { desc = "Slime: Send", buffer = true })

      vim.keymap.set({ "n", "i" }, "<C-c>i", function()
        local line = vim.api.nvim_win_get_cursor(0)[1]
        vim.api.nvim_buf_set_lines(0, line, line, false, { "", vim.b.slime_cell_delimiter })
      end, { desc = "Slime: Create Cell Below", buffer = true })

      vim.keymap.set({ "n", "i" }, "<C-c>I", function()
        local line = vim.api.nvim_win_get_cursor(0)[1]
        vim.api.nvim_buf_set_lines(0, line - 1, line - 1, false, { vim.b.slime_cell_delimiter, "" })
      end, { desc = "Slime: Create Cell Above", buffer = true })
    end,
  },
  {
    "klafyvel/vim-slime-cells",
    keys = {
      { "<C-c>c", "<Plug>SlimeCellsSendAndGoToNext", desc = "Slime: Send Cell", buffer = true },
      { "<C-c>j", "<Plug>SlimeCellsNext", desc = "Slime: Next Cell", buffer = true },
      { "<C-c>k", "<Plug>SlimeCellsPrev", desc = "Slime: Previous Cell", buffer = true },
    },
  },
}

-- return {
--   "hanschen/vim-slime-cells.nvim",
--   lazy = false,
--   ft = "python",
-- dependency = {
--   "jpalardy/vim-slime",
--   config = function()
--     vim.g.slime_target = "tmux"
--     vim.g.slime_bracketed_paste = 1
--     vim.g.slime_python_ipython = 1
--     vim.g.slime_no_mappings = 1
--     vim.g.slime_dont_ask_config = 1
--
--     -- Workflow -> run nvim in a split tmux window with REPL in other pane
--     vim.g.slime_default_config = {
--       socket_name = "default",
--       target_pane = "{right-of}", -- Adjust based on your tmux layout
--       vim.keymap.set("v", "<C-C><C-c>", ":SlimeSend", { desc = "Slime: Send" }),
--     }
--   end,
-- },
-- keys = {
--   { "<C-c><C-c>", "<Plug>SlimeCellsSendAndGoToNext", desc = "Slime: Send Cell" },
--   { "<C-c>j", "<Plug>SlimeCellsNext", desc = "Slime: Next Cell" },
--   { "<C-c>k", "<Plug>SlimeCellsPrev", desc = "Slime: Previous Cell" },
-- },
-- config = function()
--   vim.keymap.set("n", "<C-c>i", function()
--     vim.api.nvim_put({
--       vim.b.slime_cell_delimiter,
--       "",
--     }, "c", true, true)
--   end, { desc = "Slime: Insert Cell" })
-- end,
-- }
--
