-- =============================================================================
-- FILE: lua/config/plugins/mini/indentscope.lua
-- Draw vertical lines showing current indentation
--
-- DOCUMENTATION:
--  > https://github.com/echasnovski/mini.nvim/blob/main/readmes/mini-indentscope.md
--
-- =============================================================================

return {
  "echasnovski/mini.nvim",
  config = function()
    require("mini.indentscope").setup({
      -- Disable animation (instant display)
      draw = { animation = require("mini.indentscope").gen_animation.none() },
      options = { border = "both", indent_at_cursor = true, try_as_border = true },
      symbol = "|",
    })
  end,
}
