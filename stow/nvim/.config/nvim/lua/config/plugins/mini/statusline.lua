-- =============================================================================
-- FILE: lua/config/plugins/mini/statusline.lua
-- Add status line at bottom of each window
--
-- DOCUMENTATION:
--  > https://github.com/echasnovski/mini.nvim/blob/main/readmes/mini-statusline.md
--
-- =============================================================================

return {
  "echasnovski/mini.nvim",
  config = function()
    local statusline = require("mini.statusline")
    statusline.setup({ use_icons = vim.g.have_nerd_font }) -- globals.lua
    statusline.section_location = function()
      return "%2l:%-2v" -- format line-number:column-number
    end
  end,
}
