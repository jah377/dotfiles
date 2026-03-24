-- =============================================================================
-- FILE: lua/config/plugins/mini/pairs.lua
-- Automatically insert closing brackets, quotes, etc.
--
-- DOCUMENTATION:
--  > https://github.com/echasnovski/mini.nvim/blob/main/readmes/mini-pairs.md
--
-- =============================================================================

return {
  "echasnovski/mini.nvim",
  config = function()
    require("mini.pairs").setup()
  end,
}
