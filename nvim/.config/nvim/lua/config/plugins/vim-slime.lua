return {
  "jpalardy/vim-slime",
  dependencies = { "hanschen/vim-slime-cells.nvim" },
  ft = "python",
  config = function()
    -- Only want slime available for certain file-types
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "*.py",
      callback = function()
        vim.g.slime_target = "tmux"
        vim.g.slime_bracketed_paste = 1
        vim.g.slime_python_ipython = 1
        vim.g.slime_no_mappings = 1
        vim.g.slime_dont_ask_config = 1

        -- Workflow -> run nvim in a split tmux window with REPL in other pane
        vim.g.slime_default_config = {
          socket_name = "default",
          target_pane = "{right-of}", -- Adjust based on your tmux layout
        }

        vim.keymap.set("v", "<C-C><C-c>", ":SlimeSend", { desc = "Slime: Send", buffer = true })
        vim.keymap.set(
          "n",
          "<C-C><C-c>",
          "<Plug>SlimeCellsSendAndGoToNext",
          { desc = "Slime: Send Cell", buffer = true }
        )
        vim.keymap.set("n", "<C-C>j", "<Plug>SlimeCellsNext", { desc = "Slime: Next Cell", buffer = true })
        vim.keymap.set("n", "<C-C>k", "<Plug>SlimeCellsPrev", { desc = "Slime: Prev Cell", buffer = true })
        vim.keymap.set("n", "<C-C><C-c>", function()
          vim.api.nvim_put({ vim.bslime_cell_delimiter, "" }, "c", true, true)
        end, { desc = "Slime: Insert Cell", buffer = true })
      end,
    })
  end,
}
-- return {
--   {
--     "jpalardy/vim-slime",
--     ft = { "python" },
--     config = function()
--       vim.g.slime_target = "tmux"
--       vim.g.slime_bracketed_paste = 1
--       vim.g.slime_python_ipython = 1
--       vim.g.slime_no_mappings = 1
--       vim.g.slime_dont_ask_config = 1
--
--       -- Workflow -> run nvim in a split tmux window with REPL in other pane
--       vim.g.slime_default_config = {
--         socket_name = "default",
--         target_pane = "{right-of}", -- Adjust based on your tmux layout
--       }
--
--       vim.keymap.set("v", "<C-C><C-c>", ":SlimeSend", { desc = "Slime: Send" })
--     end,
--   },
--   {
--     "klafyvel/vim-slime-cells",
--     ft = { "python" },
--     keys = {
--
--       { "<C-c><C-c>", "<Plug>SlimeCellsSendAndGoToNext", desc = "Slime: Send Cell" },
--       { "<C-c>j", "<Plug>SlimeCellsNext", desc = "Slime: Next Cell" },
--       { "<C-c>k", "<Plug>SlimeCellsPrev", desc = "Slime: Previous Cell" },
--     },
--     config = function()
--       vim.keymap.set("n", "<C-c>i", function()
--         vim.api.nvim_put({
--           vim.b.slime_cell_delimiter,
--           "",
--         }, "c", true, true)
--       end, { desc = "Slime: Insert Cell" })
--     end,
--   },
-- }
