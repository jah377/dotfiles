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
    post_open_hook = function(buf, _)
      vim.keymap.set("n", "<Esc>", function()
        require("goto-preview").close_all_win()
      end, { buffer = buf, desc = "Close Preview" })
    end,
  },
}
