-- =============================================================================
-- FILE: lua/config/plugins/mini/icons.lua
-- Provide file-type icons for use by other plugins
--
-- DOCUMENTATION:
--  > https://github.com/echasnovski/mini.nvim/blob/main/readmes/mini-icons.md
--
-- =============================================================================

return {
  "echasnovski/mini.nvim",
  config = function()
    require("mini.icons").setup()
  end,
}
