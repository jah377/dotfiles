-- =============================================================================
-- FILE: lua/config/plugins/theme.lua
--
-- CATPPUCCIN FLAVOURS:
--   - latte     : Light theme (warm beige background)
--   - frappe    : Dark theme (grey-blue background)
--   - macchiato : Dark theme (deeper blue background)
--   - mocha     : Dark theme (darkest, brown-tinted)
--
-- HOW TO SWITCH THEMES:
--   :set background=light  -> Switches to latte (light mode)
--   :set background=dark   -> Switches to mocha (dark mode)
--   Custom highlight groups survive the switch via core/highlights.lua.
--
-- DOCUMENTATION:
--   > GitHub        : https://github.com/catppuccin/nvim
--   > Customization : https://github.com/catppuccin/nvim#customization
-- =============================================================================

return {
    "catppuccin/nvim",
    -- Override the plugin name (used for requiring: require("catppuccin"))
    name = "catppuccin",

    -- High priority ensures the theme loads before other plugins, which
    -- prevents a flash of default colors on startup.
    priority = 1000,

    config = function()
        require("catppuccin").setup({
            -- "auto" picks the flavour from 'background' using the map below
            flavour = "auto",
            background = {
                light = "latte",
                dark = "mocha",
            },

            -- Solid theme background; true lets the terminal background through
            transparent_background = false,

            float = {
                transparent = false, -- Floating windows use the theme background
                solid = false, -- Default float window borders
            },

            show_end_of_buffer = false, -- No ~ after the last line
            term_colors = false, -- Keep the terminal's own palette

            -- Dim windows without focus so the active one stands out
            dim_inactive = {
                enabled = true,
                shade = "dark",
                percentage = 0.25,
            },

            -- Set to true to globally disable a style
            no_italic = false,
            no_bold = false,
            no_underline = false,

            -- Per-element styles: "bold", "italic", "underline", or {} for default
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
            },

            -- Styles for LSP highlight groups (:h lsp-highlight). This is the
            -- current option; the older `integrations.native_lsp` block no
            -- longer exists in catppuccin and was removed from this file.
            lsp_styles = {
                virtual_text = {
                    errors = { "italic" },
                    hints = { "italic" },
                    warnings = { "italic" },
                    information = { "italic" },
                    ok = { "italic" },
                },
                underlines = {
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

            default_integrations = true,

            -- Only the plugins actually installed are listed; auto-detection is
            -- off so the list stays a deliberate record.
            auto_integrations = false,
            integrations = {
                cmp = true, -- nvim-cmp completion menu
                gitsigns = true, -- Git change indicators
                treesitter = true, -- Treesitter syntax highlighting
                telescope = true, -- Telescope fuzzy finder
                mason = true, -- Mason package manager UI
                markdown = true, -- Markdown highlighting
                whichkey = true, -- which-key popup

                mini = {
                    enabled = true,
                    indentscope_color = "", -- Default scope color
                },

                snacks = {
                    enabled = true,
                    indent_scope_color = "", -- Default scope color
                },
            },
        })

        -- Must run after setup() so the configuration above is applied
        vim.cmd.colorscheme("catppuccin")
    end,
}
