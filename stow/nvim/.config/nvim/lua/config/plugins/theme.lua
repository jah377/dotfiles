return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000, -- make sure it loads first
    config = function()
      require("catppuccin").setup({
        flavour = "auto", -- latte, frappe, macchiato, mocha
        background = { -- :h background
          light = "latte",
          dark = "mocha",
        },
        transparent_background = false, -- disables setting the background color.
        float = {
          transparent = false, -- enable transparent floating windows
          solid = false, -- use solid styling for floating windows, see |winborder|
        },
        show_end_of_buffer = false, -- don't show `~` at end of buffer
        term_colors = false, -- sets terminal colors (e.g. `g:terminal_color_0`)

        -- Dim background color of inactive window
        dim_inactive = {
          enabled = true,
          shade = "dark",
          percentage = 0.15,
        },

        no_italic = false, -- Force no italic
        no_bold = false, -- Force no bold
        no_underline = false, -- Force no underline

        -- Handles styles of general hi groups (see `:h highlight-args`)
        styles = {
          comments = { "italic" },
          conditionals = {},
          loops = {},
          functions = {},
          keywords = {},
          strings = {},
          variables = {},
          numbers = {},
          booleans = {},
          properties = {},
          types = {},
          operators = {},
          -- miscs = {}, -- Uncomment to turn off hard-coded styles
        },
        -- color_overrides = {},
        -- custom_highlights = {},
        default_integrations = true,
        auto_integrations = false,

        -- See https://github.com/catppuccin/nvim#integrations
        integrations = {
          cmp = true,
          gitsigns = true,
          nvimtree = true,
          treesitter = true,
          notify = false,
          whichkey = true,
          mini = {
            enabled = true,
            indentscope_color = "",
          },
          snacks = {
            enabled = true,
            indent_scope_color = "",
          },
        },
      })

      vim.cmd.colorscheme("catppuccin")
    end,
  },
}
