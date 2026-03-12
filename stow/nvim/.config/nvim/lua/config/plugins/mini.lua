-- =============================================================================
-- FILE: lua/config/plugins/mini.lua
--
-- PURPOSE:
--   Configures mini.nvim, a library of 40+ small, focused Lua plugins that
--   can be used independently. Instead of installing many separate plugins,
--   mini.nvim provides commonly-needed features in one well-maintained package.
--
-- ENABLED MODULES:
--   - mini.statusline  : Status line at bottom of window
--   - mini.comment     : Toggle comments with gcc
--   - mini.pairs       : Auto-insert closing brackets/quotes
--   - mini.cursorword  : Highlight word under cursor
--   - mini.trailspace  : Highlight/trim trailing whitespace
--   - mini.icons       : File type icons
--   - mini.indentscope : Visual indentation guide
--   - mini.hipatterns  : Highlight TODO, FIXME, etc.
--   - mini.surround    : Add/change/delete surrounding pairs
--
-- DOCUMENTATION:
--   > GitHub : https://github.com/echasnovski/mini.nvim
--   > Each module has its own README in the mini.nvim repo
--
-- =============================================================================

return {
  {
    -- Plugin identifier from GitHub
    "echasnovski/mini.nvim",

    config = function()
      -- =====================================================================
      -- MINI.STATUSLINE
      -- =====================================================================
      -- Adds a status line at the bottom of each window showing mode, file
      -- name, cursor position, git status, and diagnostics.
      -- See: https://github.com/echasnovski/mini.nvim/blob/main/readmes/mini-statusline.md
      local statusline = require("mini.statusline")

      -- Initialize with icons enabled (requires Nerd Font)
      statusline.setup({ use_icons = vim.g.have_nerd_font })

      -- Customize the location section to show "line:column" format
      -- %2l = line number (2 char min width)
      -- %-2v = column number (2 char min, left-aligned)
      statusline.section_location = function()
        return "%2l:%-2v"
      end

      -- =====================================================================
      -- MINI.COMMENT
      -- =====================================================================
      -- Toggle comments on lines or selections.
      -- See: https://github.com/echasnovski/mini.nvim/blob/main/readmes/mini-comment.md
      --
      -- Keymaps:
      --   gcc        : Toggle comment on current line
      --   gc{motion} : Toggle comment on motion (e.g., gcip for paragraph)
      --   gc         : Toggle comment on visual selection
      require("mini.comment").setup()

      -- =====================================================================
      -- MINI.PAIRS
      -- =====================================================================
      -- Automatically insert closing brackets, quotes, etc.
      -- See: https://github.com/echasnovski/mini.nvim/blob/main/readmes/mini-pairs.md
      --
      -- Behavior:
      --   Type (  -> Get ()  with cursor between
      --   Type "  -> Get ""  with cursor between
      --   Type {  -> Get {}  with cursor between
      require("mini.pairs").setup()

      -- =====================================================================
      -- MINI.CURSORWORD
      -- =====================================================================
      -- Highlight all occurrences of the word under the cursor.
      -- See: https://github.com/echasnovski/mini.nvim/blob/main/readmes/mini-cursorword.md
      --
      -- This makes it easy to see where a variable or function is used
      -- throughout the visible portion of your code.
      require("mini.cursorword").setup()

      -- =====================================================================
      -- MINI.TRAILSPACE
      -- =====================================================================
      -- Highlight trailing whitespace in red.
      -- See: https://github.com/echasnovski/mini.nvim/blob/main/readmes/mini-trailspace.md
      --
      -- Trailing whitespace (spaces/tabs at end of lines) is usually unwanted.
      -- This makes it visible so you can remove it.
      require("mini.trailspace").setup()

      -- Automatically remove trailing whitespace and blank lines at end
      -- of file when saving. This uses an autocommand to run before each save.
      vim.api.nvim_create_autocmd("BufWritePre", {
        desc = "Trim trailing whitespace and final blank lines before saving",
        group = vim.api.nvim_create_augroup("MiniTrailspaceTrim", { clear = true }),
        callback = function()
          require("mini.trailspace").trim()           -- Remove trailing spaces
          require("mini.trailspace").trim_last_lines() -- Remove trailing blank lines
        end,
      })

      -- =====================================================================
      -- MINI.ICONS
      -- =====================================================================
      -- Provide file type icons for use by other plugins.
      -- See: https://github.com/echasnovski/mini.nvim/blob/main/readmes/mini-icons.md
      --
      -- Requires a Nerd Font to display icons correctly.
      require("mini.icons").setup()

      -- =====================================================================
      -- MINI.INDENTSCOPE
      -- =====================================================================
      -- Draw a vertical line showing the current indentation scope.
      -- See: https://github.com/echasnovski/mini.nvim/blob/main/readmes/mini-indentscope.md
      --
      -- This visual guide helps you see code block boundaries at a glance.
      -- The line animates as you move between scopes.
      require("mini.indentscope").setup({
        draw = {
          -- Disable animation (instant display)
          animation = require("mini.indentscope").gen_animation.none(),
        },
        options = {
          -- Show scope border on both sides (top and bottom of block)
          border = "both",
          -- Calculate scope based on cursor position
          indent_at_cursor = true,
          -- When cursor isn't in any scope, try to show border
          try_as_border = true,
        },
        -- Character used to draw the vertical scope line
        symbol = "|",
      })

      -- =====================================================================
      -- MINI.HIPATTERNS
      -- =====================================================================
      -- Highlight specific patterns in text, like TODO and FIXME keywords.
      -- See: https://github.com/echasnovski/mini.nvim/blob/main/readmes/mini-hipatterns.md
      local hipatterns = require("mini.hipatterns")
      hipatterns.setup({
        highlighters = {
          -- Highlight TODO, FIXME, HACK, NOTE keywords.
          -- Pattern explanation: %f[%w]()WORD()%f[%W]
          --   %f[%w] : Word boundary (transition TO word char)
          --   ()     : Capture group start (highlights just the word)
          --   WORD   : The keyword to match
          --   ()     : Capture group end
          --   %f[%W] : Word boundary (transition TO non-word char)
          fixme = { pattern = "%f[%w]()FIXME()%f[%W]", group = "MiniHipatternsFixme" },
          hack = { pattern = "%f[%w]()HACK()%f[%W]", group = "MiniHipatternsHack" },
          todo = { pattern = "%f[%w]()TODO()%f[%W]", group = "MiniHipatternsTodo" },
          note = { pattern = "%f[%w]()NOTE()%f[%W]", group = "MiniHipatternsNote" },

          -- Highlight hex color strings and show the actual color.
          -- Example: #ff0000 will have a red background
          hex_color = hipatterns.gen_highlighter.hex_color(),
        },
      })

      -- =====================================================================
      -- MINI.SURROUND
      -- =====================================================================
      -- Add, delete, and change surrounding pairs (brackets, quotes, tags).
      -- See: https://github.com/echasnovski/mini.nvim/blob/main/readmes/mini-surround.md
      -- See also: docs/how_to_use_mini_surround.md
      --
      -- Keymaps (default):
      --   sa{motion}{char} : Add surrounding (e.g., saiw" adds quotes around word)
      --   sd{char}         : Delete surrounding (e.g., sd" deletes surrounding quotes)
      --   sr{old}{new}     : Replace surrounding (e.g., sr"' changes " to ')
      --
      -- Examples:
      --   saiw"     : word     -> "word"
      --   saf)"     : (word)   -> "(word)"
      --   sd"       : "word"   -> word
      --   sr'_      : 'word'   -> _word_
      require("mini.surround").setup()
    end,
  },
}
