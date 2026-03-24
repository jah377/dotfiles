-- =============================================================================
-- FILE: lua/config/plugins/mini/comment.lua
-- Toggle comments on lines or sections
--
-- DOCUMENTATION:
--  > https://github.com/echasnovski/mini.nvim/blob/main/readmes/mini-comment.md
--
-- KEYBINDINGS:
--  > gcc         : Toggle comment on current line
--  > gc{motion}  : Toggle comment on motion (eg. `gcip`)
--  > gc          : Toggle comment on visual selection
--  > dgc         : Delete whole comment block
--
-- =============================================================================

return {
  "echasnovski/mini.nvim",
  config = function()
    require("mini.comment").setup()
  end,
}
