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
  "nvim-treesitter/nvim-treesitter-textobjects",
  branch = "main",

  dependencies = {
    "nvim-treesitter/nvim-treesitter",
  },

  config = function()
    local select = require("nvim-treesitter-textobjects.select")
    local move = require("nvim-treesitter-textobjects.move")
    local swap = require("nvim-treesitter-textobjects.swap")

    -- =========================================================================
    -- CONFIGURATION
    -- =========================================================================
    -- In the new API (main branch), setup() only accepts select/move options.
    -- Keymaps must be registered separately via vim.keymap.set().
    require("nvim-treesitter-textobjects").setup({
      select = {
        lookahead = true,
        include_surrounding_whitespace = false,
        selection_modes = {
          ["@parameter.outer"] = "v", -- Parameters: characterwise (inline)
          ["@function.outer"] = "V", -- Functions: linewise (multiple lines)
          ["@class.outer"] = "V", -- Classes: linewise
          ["@conditional.outer"] = "V", -- Conditionals: linewise
          ["@loop.outer"] = "V", -- Loops: linewise
        },
      },
      move = {
        set_jumps = true,
      },
    })

    -- =========================================================================
    -- TEXT OBJECT SELECTION
    -- =========================================================================
    -- Use these with operators like d, y, c, v
    -- Example: "daf" deletes around function, "yic" yanks inner class
    local function sel(keys, query, desc)
      vim.keymap.set({ "x", "o" }, keys, function()
        select.select_textobject(query, "textobjects")
      end, { desc = desc })
    end

    -- Function text objects
    sel("af", "@function.outer", "Select outer part of function")
    sel("if", "@function.inner", "Select inner part of function")

    -- Class text objects
    sel("ac", "@class.outer", "Select outer part of class")
    sel("ic", "@class.inner", "Select inner part of class")

    -- Parameter/argument text objects
    sel("aa", "@parameter.outer", "Select outer part of parameter")
    sel("ia", "@parameter.inner", "Select inner part of parameter")

    -- Conditional text objects (if/else/switch)
    sel("ai", "@conditional.outer", "Select outer part of conditional")
    sel("ii", "@conditional.inner", "Select inner part of conditional")

    -- Loop text objects (for/while/do)
    sel("al", "@loop.outer", "Select outer part of loop")
    sel("il", "@loop.inner", "Select inner part of loop")

    -- Comment text objects
    sel("a/", "@comment.outer", "Select comment")

    -- =========================================================================
    -- NAVIGATION (move between text objects)
    -- =========================================================================
    -- Jump to the start/end of functions, classes, parameters
    local modes = { "n", "x", "o" }

    -- Jump to the START of the next textobject
    vim.keymap.set(modes, "]m", function()
      move.goto_next_start("@function.outer", "textobjects")
    end, { desc = "Next function start" })
    vim.keymap.set(modes, "]c", function()
      move.goto_next_start("@class.outer", "textobjects")
    end, { desc = "Next class start" })
    vim.keymap.set(modes, "]a", function()
      move.goto_next_start("@parameter.inner", "textobjects")
    end, { desc = "Next parameter start" })

    -- Jump to the END of the next textobject
    vim.keymap.set(modes, "]M", function()
      move.goto_next_end("@function.outer", "textobjects")
    end, { desc = "Next function end" })
    vim.keymap.set(modes, "]C", function()
      move.goto_next_end("@class.outer", "textobjects")
    end, { desc = "Next class end" })
    vim.keymap.set(modes, "]A", function()
      move.goto_next_end("@parameter.inner", "textobjects")
    end, { desc = "Next parameter end" })

    -- Jump to the START of the previous textobject
    vim.keymap.set(modes, "[m", function()
      move.goto_previous_start("@function.outer", "textobjects")
    end, { desc = "Previous function start" })
    vim.keymap.set(modes, "[c", function()
      move.goto_previous_start("@class.outer", "textobjects")
    end, { desc = "Previous class start" })
    vim.keymap.set(modes, "[a", function()
      move.goto_previous_start("@parameter.inner", "textobjects")
    end, { desc = "Previous parameter start" })

    -- Jump to the END of the previous textobject
    vim.keymap.set(modes, "[M", function()
      move.goto_previous_end("@function.outer", "textobjects")
    end, { desc = "Previous function end" })
    vim.keymap.set(modes, "[C", function()
      move.goto_previous_end("@class.outer", "textobjects")
    end, { desc = "Previous class end" })
    vim.keymap.set(modes, "[A", function()
      move.goto_previous_end("@parameter.inner", "textobjects")
    end, { desc = "Previous parameter end" })

    -- =========================================================================
    -- SWAP (swap adjacent text objects)
    -- =========================================================================
    -- Useful for reordering function parameters
    -- Example: foo(a, b, c) with cursor on 'a', press <leader>ca
    -- Result:  foo(b, a, c)
    vim.keymap.set("n", "<leader>ca", function()
      swap.swap_next("@parameter.inner")
    end, { desc = "Swap parameter with next" })
    vim.keymap.set("n", "<leader>cA", function()
      swap.swap_previous("@parameter.inner")
    end, { desc = "Swap parameter with previous" })
  end,
}
