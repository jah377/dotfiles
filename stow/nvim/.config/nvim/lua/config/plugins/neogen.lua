-- =============================================================================
-- FILE: lua/config/plugins/neogen.lua
--
-- PURPOSE:
--   Configures Neogen, a documentation generator that creates docstring
--   templates for functions, classes, and methods. It analyzes your code
--   using Treesitter and generates properly formatted documentation stubs
--   with parameter placeholders.
--
-- WHY USE NEOGEN?
--   - Automatically detects function parameters and return types
--   - Generates language-specific docstring formats (Google, NumPy, Sphinx)
--   - Uses LuaSnip to let you tab through placeholder fields
--   - Saves time writing boilerplate documentation
--
-- HOW TO USE:
--   1. Place cursor on a function, class, or method
--   2. Press <leader>d
--   3. A docstring template appears above the function
--   4. Tab through the placeholders to fill in descriptions
--
-- DOCUMENTATION:
--   > GitHub : https://github.com/danymat/neogen
--
-- =============================================================================

return {
  {
    "danymat/neogen",

    -- Neogen uses Treesitter to analyze code structure.
    -- Treesitter must be loaded before Neogen can work.
    dependencies = { "nvim-treesitter/nvim-treesitter" },

    opts = {
      -- Use LuaSnip as the snippet engine for navigating docstring placeholders.
      -- This integrates with our existing LuaSnip setup from nvim-cmp.lua.
      -- When a docstring is generated, you can Tab through fields like
      -- {param_description}, {return_description}, etc.
      snippet_engine = "luasnip",

      languages = {
        python = {
          template = {
            -- Use Google-style docstrings for Python.
            -- Google style uses 'Args:', 'Returns:', 'Raises:' sections.
            -- Example:
            --   def foo(bar):
            --       """Short description.
            --
            --       Args:
            --           bar: Description of bar.
            --
            --       Returns:
            --           Description of return value.
            --       """
            annotation_convention = "google_docstrings",
          },
        },
      },
    },

    keys = {
      {
        "<leader>d",
        function()
          require("neogen").generate()
        end,
        desc = "Generate docstring",
      },
    },
  },
}
