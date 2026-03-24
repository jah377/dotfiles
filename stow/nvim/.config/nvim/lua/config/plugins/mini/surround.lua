-- =============================================================================
-- FILE: lua/config/plugins/mini/surround.lua
-- Add, delete, and change surrounding pairs (brackets, quotes, etc)
--
-- DOCUMENTATION:
--  > https://github.com/echasnovski/mini.nvim/blob/main/readmes/mini-surround.md
--  > See: docs/how_to_use_mini_surround.md
--
-- =============================================================================

return {
  "echasnovski/mini.nvim",
  config = function()
    require("mini.surround").setup()
  end,
}
