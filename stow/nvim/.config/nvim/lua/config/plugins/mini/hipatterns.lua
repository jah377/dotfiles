-- =============================================================================
-- FILE: lua/config/plugins/mini/hipatterns.lua
-- Highlight specific patterns in text, like TODO, FIXME, etc.
--
-- DOCUMENTATION:
--  > https://github.com/echasnovski/mini.nvim/blob/main/readmes/mini-hipatterns.md
--
-- =============================================================================

return {
  "echasnovski/mini.nvim",
  config = function()
    local hipatterns = require("mini.hipatterns")

    vim.api.nvim_set_hl(0, "MiniHipatternsAssumptions", { fg = "#ffffff", bg = "#9d7cd8", bold = true })

    hipatterns.setup({
      highlighters = {
        fixme = { pattern = "%f[%w]()FIXME()%f[%W]", group = "MiniHipatternsFixme" },
        hack = { pattern = "%f[%w]()HACK()%f[%W]", group = "MiniHipatternsHack" },
        todo = { pattern = "%f[%w]()TODO()%f[%W]", group = "MiniHipatternsTodo" },
        note = { pattern = "%f[%w]()NOTE()%f[%W]", group = "MiniHipatternsNote" },
        assumptions = { pattern = "%f[%w]()ASSUMPTIONS()%f[%W]", group = "MiniHipatternsAssumptions" },
        hex_color = hipatterns.gen_highlighter.hex_color(),
      },
    })
  end,
}
