-- [[ Mini: Library of 40+ independent Lua modules ]]
-- See https://github.com/nvim-mini/mini.nvim

return {
  {
    "echasnovski/mini.nvim",
    config = function()
      -- [[ Add statusline at bottom of window ]]
      -- See https://github.com/nvim-mini/mini.nvim/blob/main/readmes/mini-statusline.md
      local statusline = require("mini.statusline")
      statusline.setup({ use_icons = vim.g.have_nerd_font })
      statusline.section_location = function()
        return "%2l:%-2v"
      end

      -- [[ Comment text-objects in normal-mode ]]
      -- See https://github.com/nvim-mini/mini.nvim/blob/main/readmes/mini-comment.md
      -- >> `gcc` to comment entire line
      -- >> `gcip` to comment inner-paragraph
      -- >> `dgc` to delete whole comment block
      require("mini.comment").setup()

      -- [[ Automatically insert pairs ]]
      -- See https://github.com/nvim-mini/mini.nvim/blob/main/readmes/mini-pairs.md
      require("mini.pairs").setup()

      -- [[ Underline word at point ]]
      -- See https://github.com/nvim-mini/mini.nvim/blob/main/readmes/mini-cursorword.md
      require("mini.cursorword").setup()

      -- [[ Highlight trailing whitespace ]]
      -- See https://github.com/nvim-mini/mini.nvim/blob/main/readmes/mini-trailspace.md
      require("mini.trailspace").setup()

      -- Remove trailing whitespace before saving
      vim.api.nvim_create_autocmd("BufWritePre", {
        desc = "Trim trailing whitespace and final blank lines before saving",
        group = vim.api.nvim_create_augroup("MiniTrailspaceTrim", { clear = true }),
        callback = function()
          require("mini.trailspace").trim()
          require("mini.trailspace").trim_last_lines()
        end,
      })

      -- [[ Provide icons ]]
      -- See https://github.com/nvim-mini/mini.nvim/blob/main/readmes/mini-icons.md
      require("mini.icons").setup()

      -- [[ Visualize indentation lines ]]
      -- See https://github.com/nvim-mini/mini.nvim/blob/main/readmes/mini-indentscope.md
      require("mini.indentscope").setup({
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

      -- [[ Highlight keywords defined by regex patterns ]]
      -- See https://github.com/nvim-mini/mini.nvim/blob/main/readmes/mini-hipatterns.md
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

      -- [[ Surround actions ]]
      -- See https://github.com/nvim-mini/mini.nvim/blob/main/readmes/mini-surround.md
      -- >> `saiw"      |word -> "word"
      -- >> `savf)"`    |(word) -> "(word)"
      -- >> `sd"`       |"word" -> word
      -- >> `sr'_`      `"|'word'"` -> `"_word_"`
      require("mini.surround").setup()
    end,
  },
}
