-- =============================================================================
-- FILE: lua/config/plugins/mini.lua
-- mini.nvim modules: statusline, comment (gcc), pairs, cursorword,
-- trailspace, icons, indentscope, hipatterns, surround (sa/sd/sr)
-- =============================================================================

return {
  {
    "echasnovski/mini.nvim",

    config = function()
      -- STATUSLINE --
      local statusline = require("mini.statusline")
      statusline.setup({ use_icons = vim.g.have_nerd_font })  -- globals.lua
      statusline.section_location = function() return "%2l:%-2v" end

      -- COMMENT: gcc=line, gc{motion}, gc=visual --
      require("mini.comment").setup()

      -- PAIRS: auto-close brackets/quotes --
      require("mini.pairs").setup()

      -- CURSORWORD: highlight word under cursor --
      require("mini.cursorword").setup()

      -- TRAILSPACE: highlight trailing whitespace --
      require("mini.trailspace").setup()
      vim.api.nvim_create_autocmd("BufWritePre", {
        desc = "Trim trailing whitespace on save",
        group = vim.api.nvim_create_augroup("MiniTrailspaceTrim", { clear = true }),
        callback = function()
          require("mini.trailspace").trim()
          require("mini.trailspace").trim_last_lines()
        end,
      })

      -- ICONS: file type icons (requires Nerd Font) --
      require("mini.icons").setup()

      -- INDENTSCOPE: vertical line showing current scope --
      require("mini.indentscope").setup({
        draw = { animation = require("mini.indentscope").gen_animation.none() },
        options = { border = "both", indent_at_cursor = true, try_as_border = true },
        symbol = "|",
      })

      -- HIPATTERNS: highlight TODO, FIXME, hex colors --
      local hipatterns = require("mini.hipatterns")
      hipatterns.setup({
        highlighters = {
          fixme = { pattern = "%f[%w]()FIXME()%f[%W]", group = "MiniHipatternsFixme" },
          hack = { pattern = "%f[%w]()HACK()%f[%W]", group = "MiniHipatternsHack" },
          todo = { pattern = "%f[%w]()TODO()%f[%W]", group = "MiniHipatternsTodo" },
          note = { pattern = "%f[%w]()NOTE()%f[%W]", group = "MiniHipatternsNote" },
          hex_color = hipatterns.gen_highlighter.hex_color(),
        },
      })

      -- SURROUND: sa{motion}{char}=add, sd{char}=delete, sr{old}{new}=replace --
      -- See: docs/how_to_use_mini_surround.md
      require("mini.surround").setup()
    end,
  },
}
