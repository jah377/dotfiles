-- =============================================================================
-- FILE: lua/config/plugins/mini/cursorword.lua
-- Highlight word under cursor
--
-- DOCUMENTATION:
--  > https://github.com/echasnovski/mini.nvim/blob/main/readmes/mini-cursorword.md
--
-- =============================================================================

return {
  "echasnovski/mini.nvim",
  config = function()
    require("mini.cursorword").setup()
  end,
}
