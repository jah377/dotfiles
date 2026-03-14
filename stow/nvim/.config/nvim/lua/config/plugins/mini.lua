-- =============================================================================
-- FILE: lua/config/plugins/mini.lua
-- Library of 40+ small, focused Lua plugins. Not all enabled.
--
-- DOCUMENTATION:
--  > GitHub: https://github.com/echasnovski/mini.nvim
--  > Each module has its own README in the mini.nvim repo
--
-- =============================================================================

return {
  {
    "echasnovski/mini.nvim",

    config = function()
      -- Add status line at bottom of each window
      local statusline = require("mini.statusline")
      statusline.setup({ use_icons = vim.g.have_nerd_font }) -- globals.lua
      statusline.section_location = function()
        return "%2l:%-2v" -- format line-number:column-number
      end

      -- COMMENT: gcc=line, gc{motion}, gc=visual --
      -- Toggle comments on lines or sections
      --  > gcc         : Toggle comment on current line
      --  > gc{motion}  : Toggle comment on motion (eg. `gcip`)
      --  > gc          : Toggle comment on visual selection
      --  > dgc         : Delete whole comment block
      require("mini.comment").setup()

      -- Automatically insert closing brackets, quotes, etc.
      require("mini.pairs").setup()

      -- Highlight word under cursor
      require("mini.cursorword").setup()

      -- Highlight and delete trailing whitespace
      require("mini.trailspace").setup()
      vim.api.nvim_create_autocmd("BufWritePre", {
        desc = "Trim trailing whitespace on save",
        group = vim.api.nvim_create_augroup("MiniTrailspaceTrim", { clear = true }),
        callback = function()
          require("mini.trailspace").trim()
          require("mini.trailspace").trim_last_lines()
        end,
      })

      -- Provide file-type icons for use by other plugins
      require("mini.icons").setup()

      -- Draw vertical lines showing current indentation
      require("mini.indentscope").setup({
        -- Disable animation (instant display)
        draw = { animation = require("mini.indentscope").gen_animation.none() },
        options = { border = "both", indent_at_cursor = true, try_as_border = true },
        symbol = "|",
      })

      -- Highlight specific patterns in text, like TODO, FIXME, etc.
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

      -- Add, delete, and change surrounding pairs (brackets, quotes, etc)
      -- See: docs/how_to_use_mini_surround.md
      require("mini.surround").setup()
    end,
  },
}
