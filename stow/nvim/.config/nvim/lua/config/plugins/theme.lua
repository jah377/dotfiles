-- =============================================================================
-- FILE: lua/config/plugins/theme.lua
--
-- PURPOSE:
--   Configures Catppuccin, a soothing pastel color theme for Neovim. This
--   file sets up the colorscheme and configures how it integrates with
--   various plugins (LSP, Treesitter, Telescope, etc.).
--
-- CATPPUCCIN FLAVOURS:
--   - latte   : Light theme (warm beige background)
--   - frappe  : Dark theme (grey-blue background)
--   - macchiato: Dark theme (deeper blue background)
--   - mocha   : Dark theme (darkest, brown-tinted)
--
-- HOW TO SWITCH THEMES:
--   :set background=light  -> Switches to latte (light mode)
--   :set background=dark   -> Switches to mocha (dark mode)
--
-- DOCUMENTATION:
--   > GitHub        : https://github.com/catppuccin/nvim
--   > Customization : https://github.com/catppuccin/nvim#customization
--
-- =============================================================================

return {
  {
    -- Plugin identifier from GitHub
    "catppuccin/nvim",

    -- Override the plugin name (used for requiring: require("catppuccin"))
    name = "catppuccin",

    -- High priority ensures theme loads before other plugins.
    -- This prevents flickering from default colors on startup.
    priority = 1000,

    config = function()
      require("catppuccin").setup({
        -- Use "auto" to automatically choose based on vim background setting.
        -- When background=light, uses latte; when background=dark, uses mocha.
        flavour = "auto",

        -- Map vim background modes to specific catppuccin flavours
        background = {
          light = "latte",  -- Use latte for :set background=light
          dark = "mocha",   -- Use mocha for :set background=dark
        },

        -- Use solid theme colors for the editor background.
        -- Set to true if you want your terminal's background to show through.
        transparent_background = false,

        -- Configure floating window appearance
        float = {
          transparent = false, -- Floating windows use theme background
          solid = false,       -- Use default float window borders
        },

        -- Don't show ~ characters at end of buffer (after last line)
        show_end_of_buffer = false,

        -- Don't override terminal colors (keep terminal's own color scheme)
        term_colors = false,

        -- Dim windows that don't have focus (helps identify active window)
        dim_inactive = {
          enabled = true,       -- Enable dimming
          shade = "dark",       -- Dim towards dark (not light)
          percentage = 0.25,    -- 25% dimmer than active window
        },

        -- Style preferences for code elements
        -- Set to true to globally disable that style
        no_italic = false,    -- Allow italic text
        no_bold = false,      -- Allow bold text
        no_underline = false, -- Allow underlined text

        -- Configure styles for specific syntax elements
        -- Each can have: "bold", "italic", "underline" (or empty {} for default)
        styles = {
          comments = { "italic" }, -- Comments in italic (easier to distinguish)
          conditionals = {},       -- if/else/switch - default styling
          loops = {},              -- for/while - default styling
          functions = {},          -- Function names - default styling
          keywords = {},           -- Language keywords - default styling
          strings = {},            -- String literals - default styling
          variables = {},          -- Variable names - default styling
          numbers = {},            -- Number literals - default styling
          booleans = {},           -- true/false - default styling
          properties = {},         -- Object properties - default styling
          types = {},              -- Type names - default styling
          operators = {},          -- +, -, *, etc. - default styling
        },

        -- Styles for LSP-related highlighting
        lsp_styles = {
          -- Virtual text (diagnostic messages shown inline)
          virtual_text = {
            errors = { "italic" },
            hints = { "italic" },
            warnings = { "italic" },
            information = { "italic" },
            ok = { "italic" },
          },
          -- Underlines for diagnostics
          underlines = {
            errors = {},       -- Use theme default
            hints = {},
            warnings = {},
            information = {},
            ok = {},
          },
          -- Inlay hints (inline type information)
          inlay_hints = {
            background = true, -- Show background color for inlay hints
          },
        },

        -- Enable default integrations with common plugins
        default_integrations = true,

        -- Don't auto-detect all plugins (we explicitly list what we use)
        auto_integrations = false,

        -- Plugin-specific theme integrations
        -- Enable only for plugins we actually use
        integrations = {
          cmp = true,        -- nvim-cmp completion menu
          gitsigns = true,   -- Git change indicators
          treesitter = true, -- Treesitter syntax highlighting
          telescope = true,  -- Telescope fuzzy finder
          mason = true,      -- Mason package manager UI
          markdown = true,   -- Markdown highlighting

          -- LSP integration with styled diagnostic text
          native_lsp = {
            enabled = true,
            virtual_text = {
              errors = { "italic" },
              hints = { "italic" },
              warnings = { "italic" },
              information = { "italic" },
            },
            underlines = {
              errors = { "underline" },
              hints = { "underline" },
              warnings = { "underline" },
              information = { "underline" },
            },
            inlay_hints = {
              background = true,
            },
          },

          notify = true,   -- nvim-notify notifications
          whichkey = true, -- which-key popup

          -- mini.nvim integrations
          mini = {
            enabled = true,
            indentscope_color = "", -- Use default scope color
          },

          -- snacks.nvim integrations
          snacks = {
            enabled = true,
            indent_scope_color = "", -- Use default scope color
          },
        },
      })

      -- Apply the colorscheme.
      -- This must be called after setup() to apply all configurations.
      vim.cmd.colorscheme("catppuccin")
    end,
  },
}
