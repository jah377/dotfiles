return {
  {
    "echasnovski/mini.nvim",
    config = function()
      -- Add statusline at bottom of the window
      local statusline = require("mini.statusline")
      statusline.setup({ use_icons = vim.g.have_neard_font })
      statusline.section_location = function()
        return "%2l:%-2v"
      end

      -- Comment text-objects in normal-mode
      -- `gcip` to comment inner-paragraph
      -- `dgc` to delete whole comment block
      -- `dcc` to comment entire line
      require("mini.comment").setup()

      -- Automatically insert paired quotes or brackets
      require("mini.pairs").setup()

      -- Highlight word at point
      require("mini.cursorword").setup()

      -- Highlight trailing whitespace
      -- Custom autocmd removes whitespaces before saving
      require("mini.trailspace").setup()
      vim.api.nvim_create_autocmd("BufWritePre", {
        desc = "Trim trailing whitespace and final blank lines before saving",
        group = vim.api.nvim_create_augroup("MiniTrailspaceTrim", { clear = true }),
        callback = function()
          require("mini.trailspace").trim()
          require("mini.trailspace").trim_last_lines()
        end,
      })
      -- Provide icons
      require("mini.icons").setup()

      -- Visualize indentation
      require("mini.indentscope").setup({
        version = false,
        draw = {
          animation = require("mini.indentscope").gen_animation.none(),
        },
        options = {
          border = "both",
          indent_at_cursor = true,
          try_as_border = true,
        },
        symbol = "|",
      })

      -- Visualize keywords by highlighting regex patterns
      local hipatterns = require("mini.hipatterns")
      hipatterns.setup({
        highlighters = {
          -- Highlight standalone 'FIXME', 'HACK', 'TODO', 'NOTE'
          fixme = { pattern = "%f[%w]()FIXME()%f[%W]", group = "MiniHipatternsFixme" },
          hack = { pattern = "%f[%w]()HACK()%f[%W]", group = "MiniHipatternsHack" },
          todo = { pattern = "%f[%w]()TODO()%f[%W]", group = "MiniHipatternsTodo" },
          note = { pattern = "%f[%w]()NOTE()%f[%W]", group = "MiniHipatternsNote" },

          -- Highlight hex color strings (`#rrggbb`) using that color
          hex_color = hipatterns.gen_highlighter.hex_color(),
        },
      })
    end,
  },
}
