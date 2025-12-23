-- [[ Catppuccin: Soothing pastel theme for Neovim ]]
-- See: https://github.com/catppuccin/nvim

return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    -- Load before all other plugins
    priority = 1000,
    config = function()
      require("catppuccin").setup({
        -- Auto-detects based on vim background setting
        -- See `:set background=light/dark`
        flavour = "auto", -- latte, frappe, macchiato, mocha

        -- Map vim background modes to catppuccin flavours
        background = {
          light = "latte",
          dark = "mocha",
        },

        -- Transparency settings
        transparent_background = false, -- use theme colors for background

        -- Floating window styling
        float = {
          transparent = false, -- use theme colors for float backgrounds
          solid = false,       -- use default float window borders
        },

        show_end_of_buffer = false, -- don't show `~` at end of buffer
        term_colors = false,        -- don't set terminal colors

        -- Dim inactive windows for better focus
        dim_inactive = {
          enabled = true,
          shade = "dark",
          percentage = 0.25,
        },

        -- Global style overrides (set to true to force disable)
        no_italic = false,    -- false = allow italics
        no_bold = false,      -- false = allow bold
        no_underline = false, -- false = allow underlines

        -- Customize syntax highlighting styles
        -- Empty {} = use theme defaults
        -- Available styles: "bold", "italic", "underline"
        -- See `:h highlight-args` for more options
        styles = {
          comments = { "italic" }, -- Italic comments
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
          -- miscs = {},            -- Uncomment to turn off hard-coded styles
        },

        -- Handles style of specific LSP hl groups (see `:help lsp-highlight`)
        lsp_styles = {
          virtual_text = {
            errors = { "italic" },
            hints = { "italic" },
            warnings = { "italic" },
            information = { "italic" },
            ok = { "italic" },
          },
          underlines = {
            -- default: "underline"
            errors = {},
            hints = {},
            warnings = {},
            information = {},
            ok = {},
          },
          inlay_hints = {
            background = true,
          },
        },

        -- Uncomment to override palette colors (e.g., change accent colors)
        -- See: https://github.com/catppuccin/nvim#customization
        -- color_overrides = {},

        -- Uncomment to customize specific highlight groups
        -- See: https://github.com/catppuccin/nvim#highlight-overrides
        -- custom_highlights = {},

        default_integrations = true, -- Enable default plugin integrations
        auto_integrations = false,   -- Don't auto-detect all plugins

        -- Plugin integrations - enable for plugins you use
        -- See: https://github.com/catppuccin/nvim#integrations
        integrations = {
          cmp = true,        -- nvim-cmp completion menu
          gitsigns = true,   -- Git signs in gutter
          treesitter = true, -- Treesitter syntax highlighting
          telescope = true,  -- Telescope fuzzy finder
          mason = true,      -- Mason LSP/tool installer
          markdown = true,   -- Markdown highlighting

          -- LSP integration with styled virtual text
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

          notify = true,   -- nvim-notify (not using)
          whichkey = true, -- which-key popup

          -- mini.nvim integrations
          mini = {
            enabled = true,
            indentscope_color = "", -- "" = use default scope color
          },

          -- snacks.nvim integrations
          snacks = {
            enabled = true,
            indent_scope_color = "", -- use default scope color
          },
        },
      })

      -- Apply the colorscheme
      vim.cmd.colorscheme("catppuccin")
    end,
  },
}
