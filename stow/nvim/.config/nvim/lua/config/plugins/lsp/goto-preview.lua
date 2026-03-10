-- ================================================================================================
-- TITLE : Goto Preview
--
-- ABOUT : Preview LSP definitions, references, etc. in floating windows
--
-- LINKS :
--   > https://github.com/rmagatti/goto-preview
--
-- ================================================================================================

return {
  "rmagatti/goto-preview",
  dependencies = { "rmagatti/logger.nvim" },
  event = "LspAttach",
  opts = {
    width = 120,
    height = 15,
    references = {
      provider = "telescope",
    },
    post_open_hook = function(buf, win)
      vim.keymap.set("n", "<Esc>", function()
        vim.api.nvim_win_close(win, true)
      end, { buffer = buf, desc = "Close Preview" })
    end,
  },
}
