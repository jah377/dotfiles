-- =============================================================================
-- FILE: lua/config/plugins/nvim-treesitter-textobjects.lua
--
-- PURPOSE:
--   Configures nvim-treesitter-textobjects, which provides syntax-aware text
--   objects for Vim motions. Instead of operating on words or paragraphs,
--   you can operate on functions, classes, parameters, and other code
--   structures that Treesitter understands.
--
-- WHAT ARE TEXT OBJECTS?
--   Text objects define regions of text that Vim commands operate on.
--   Standard text objects include:
--   - iw (inner word), aw (a word)
--   - ip (inner paragraph), ap (a paragraph)
--   - i" (inside quotes), a" (around quotes)
--
--   This plugin adds CODE-AWARE text objects:
--   - if (inner function), af (around function)
--   - ic (inner class), ac (around class)
--   - ia (inner argument/parameter), aa (around argument)
--
-- USAGE EXAMPLES:
--   daf  - Delete a function (including signature and body)
--   yif  - Yank inner function (just the body)
--   caa  - Change around argument (replace a function parameter)
--   vai  - Visually select around conditional (if statement)
--
-- NAVIGATION:
--   ]m  - Jump to next function start
--   [m  - Jump to previous function start
--   ]c  - Jump to next class start
--   [c  - Jump to previous class start
--
-- SWAPPING:
--   <leader>a  - Swap current parameter with next
--   <leader>A  - Swap current parameter with previous
--
-- SEE ALSO:
--   Additional documentation in docs/how_to_use_treesitter_text_objects.md
--
-- DOCUMENTATION:
--   > GitHub : https://github.com/nvim-treesitter/nvim-treesitter-textobjects
--
-- =============================================================================

return {
  -- Plugin identifier from GitHub
  "nvim-treesitter/nvim-treesitter-textobjects",

  -- This plugin requires nvim-treesitter to work
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
  },

  config = function()
    require("nvim-treesitter-textobjects").setup({
      -- =====================================================================
      -- TEXT OBJECT SELECTION
      -- =====================================================================
      -- Use these with operators like d, y, c, v
      -- Example: "daf" deletes around function, "yic" yanks inner class
      select = {
          enable = true,

          -- Jump forward to find a textobject if cursor isn't on one.
          -- Similar to how targets.vim works.
          -- Example: typing "daf" will find the next function even if cursor
          -- isn't currently inside one.
          lookahead = true,

          -- Don't include surrounding whitespace when selecting.
          -- "Inner" selections will be tight to the code.
          include_surrounding_whitespace = false,

          -- Define the textobject keymaps.
          -- Format: ["keys"] = { query = "@treesitter.query", desc = "..." }
          keymaps = {
            -- Function text objects
            -- "af" = around function (includes def/function keyword and body)
            -- "if" = inner function (just the body/implementation)
            ["af"] = { query = "@function.outer", desc = "Select outer part of function" },
            ["if"] = { query = "@function.inner", desc = "Select inner part of function" },

            -- Class text objects
            -- "ac" = around class (includes class keyword and entire body)
            -- "ic" = inner class (just the class body)
            ["ac"] = { query = "@class.outer", desc = "Select outer part of class" },
            ["ic"] = { query = "@class.inner", desc = "Select inner part of class" },

            -- Parameter/argument text objects
            -- "aa" = around argument (includes comma separator if present)
            -- "ia" = inner argument (just the argument itself)
            ["aa"] = { query = "@parameter.outer", desc = "Select outer part of parameter" },
            ["ia"] = { query = "@parameter.inner", desc = "Select inner part of parameter" },

            -- Conditional text objects (if/else/switch)
            -- "ai" = around conditional (entire if statement including else)
            -- "ii" = inner conditional (just the body of the if block)
            ["ai"] = { query = "@conditional.outer", desc = "Select outer part of conditional" },
            ["ii"] = { query = "@conditional.inner", desc = "Select inner part of conditional" },

            -- Loop text objects (for/while/do)
            -- "al" = around loop (entire loop including header)
            -- "il" = inner loop (just the loop body)
            ["al"] = { query = "@loop.outer", desc = "Select outer part of loop" },
            ["il"] = { query = "@loop.inner", desc = "Select inner part of loop" },

            -- Comment text objects
            -- "a/" = around comment (selects entire comment block)
            ["a/"] = { query = "@comment.outer", desc = "Select comment" },
          },

          -- Define which visual mode to use for each textobject type.
          -- "v" = characterwise, "V" = linewise, "<c-v>" = blockwise
          selection_modes = {
            ["@parameter.outer"] = "v", -- Parameters: characterwise (inline)
            ["@function.outer"] = "V", -- Functions: linewise (multiple lines)
            ["@class.outer"] = "V", -- Classes: linewise
            ["@conditional.outer"] = "V", -- Conditionals: linewise
            ["@loop.outer"] = "V", -- Loops: linewise
          },
        },

        -- =====================================================================
        -- NAVIGATION (move between text objects)
        -- =====================================================================
        -- Jump to the start/end of functions, classes, parameters
        move = {
          enable = true,

          -- Add jumps to the jumplist (so Ctrl-O returns to previous position)
          set_jumps = true,

          -- Jump to the START of the next textobject
          goto_next_start = {
            ["]m"] = { query = "@function.outer", desc = "Next function start" },
            ["]c"] = { query = "@class.outer", desc = "Next class start" },
            ["]a"] = { query = "@parameter.inner", desc = "Next parameter start" },
          },

          -- Jump to the END of the next textobject
          goto_next_end = {
            ["]M"] = { query = "@function.outer", desc = "Next function end" },
            ["]C"] = { query = "@class.outer", desc = "Next class end" },
            ["]A"] = { query = "@parameter.inner", desc = "Next parameter end" },
          },

          -- Jump to the START of the previous textobject
          goto_previous_start = {
            ["[m"] = { query = "@function.outer", desc = "Previous function start" },
            ["[c"] = { query = "@class.outer", desc = "Previous class start" },
            ["[a"] = { query = "@parameter.inner", desc = "Previous parameter start" },
          },

          -- Jump to the END of the previous textobject
          goto_previous_end = {
            ["[M"] = { query = "@function.outer", desc = "Previous function end" },
            ["[C"] = { query = "@class.outer", desc = "Previous class end" },
            ["[A"] = { query = "@parameter.inner", desc = "Previous parameter end" },
          },
        },

        -- =====================================================================
        -- SWAP (swap adjacent text objects)
        -- =====================================================================
        -- Useful for reordering function parameters
        swap = {
          enable = true,

          -- Swap current parameter with the next one
          -- Example: foo(a, b, c) with cursor on 'a', press <leader>a
          -- Result:  foo(b, a, c)
          swap_next = {
            ["<leader>ca"] = { query = "@parameter.inner", desc = "Swap parameter with next" },
          },

          -- Swap current parameter with the previous one
          swap_previous = {
            ["<leader>cA"] = { query = "@parameter.inner", desc = "Swap parameter with previous" },
          },
        },
    })
  end,
}
