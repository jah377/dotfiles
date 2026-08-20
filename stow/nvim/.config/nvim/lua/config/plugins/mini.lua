-- =============================================================================
-- FILE: lua/config/plugins/mini.lua
--
-- PURPOSE:
--   One lazy spec for echasnovski/mini.nvim. Keep a single spec: lazy.nvim
--   merges by plugin name and runs one config() (oil.lua also lists mini.nvim).
--
-- MODULES:
--   comment     : gcc / gc{motion} / gc / dgc
--   cursorword  : highlight word under cursor
--   hipatterns  : FIXME, HACK, TODO, NOTE, ASSUMPTIONS, hex colors
--   icons       : file-type icons (oil.nvim, render-markdown.nvim)
--   indentscope : indent guide (no animation)
--   pairs       : autoclose brackets/quotes
--   surround    : add/delete/change surrounds (see docs/how_to_use_mini_surround.md)
--   trailspace  : highlight trailing whitespace; trim on save
--
-- DOCUMENTATION:
--   > https://github.com/echasnovski/mini.nvim
--
-- =============================================================================

return {
  "echasnovski/mini.nvim",
  config = function()
    require("mini.comment").setup()
    require("mini.cursorword").setup()
    require("mini.icons").setup()
    require("mini.pairs").setup()

    require("mini.surround").setup()

    require("mini.indentscope").setup {
      -- Disable animation (instant display)
      draw = { animation = require("mini.indentscope").gen_animation.none() },
      options = { border = "both", indent_at_cursor = true, try_as_border = true },
      symbol = "|",
    }

    local hipatterns = require "mini.hipatterns"
    vim.api.nvim_set_hl(0, "MiniHipatternsAssumptions", { fg = "#ffffff", bg = "#9d7cd8", bold = true })
    hipatterns.setup {
      highlighters = {
        fixme = { pattern = "%f[%w]()FIXME()%f[%W]", group = "MiniHipatternsFixme" },
        hack = { pattern = "%f[%w]()HACK()%f[%W]", group = "MiniHipatternsHack" },
        todo = { pattern = "%f[%w]()TODO()%f[%W]", group = "MiniHipatternsTodo" },
        note = { pattern = "%f[%w]()NOTE()%f[%W]", group = "MiniHipatternsNote" },
        assumptions = { pattern = "%f[%w]()ASSUMPTIONS()%f[%W]", group = "MiniHipatternsAssumptions" },
        hex_color = hipatterns.gen_highlighter.hex_color(),
      },
    }

    require("mini.trailspace").setup()
    vim.api.nvim_create_autocmd("BufWritePre", {
      desc = "Trim trailing whitespace on save",
      group = vim.api.nvim_create_augroup("MiniTrailspaceTrim", { clear = true }),
      callback = function()
        require("mini.trailspace").trim()
        require("mini.trailspace").trim_last_lines()
      end,
    })
  end,
}
