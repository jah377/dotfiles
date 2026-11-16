-- =============================================================================
-- FILE: lua/config/plugins/mini.lua
--
-- PURPOSE:
--   One lazy spec for echasnovski/mini.nvim. Keep a single spec: lazy.nvim
--   merges specs by plugin name and runs one config() (oil.lua and
--   render-markdown.lua list mini.nvim as a dependency for icons).
--
-- MODULES:
--   comment     : gcc / gc{motion} / gc / dgc
--   cursorword  : highlight word under cursor
--   hipatterns  : FIXME, HACK, TODO, NOTE, ASSUMPTIONS, hex colors
--   icons       : file-type icons (oil.nvim, render-markdown.nvim)
--   indentscope : indent guide (no animation)
--   pairs       : autoclose brackets/quotes
--   surround    : add/delete/change surrounds (see docs/how_to_use_mini_surround.md)
--   trailspace  : highlight trailing whitespace; trim on save
--
-- DOCUMENTATION:
--   > https://github.com/echasnovski/mini.nvim
-- =============================================================================

return {
    "echasnovski/mini.nvim",
    config = function()
        require("mini.comment").setup()
        require("mini.cursorword").setup()
        require("mini.icons").setup()
        require("mini.pairs").setup()
        require("mini.surround").setup()

        local indentscope = require("mini.indentscope")
        indentscope.setup({
            draw = { animation = indentscope.gen_animation.none() }, -- instant display
            options = { border = "both", indent_at_cursor = true, try_as_border = true },
            symbol = "|",
        })

        -- The MiniHipatternsAssumptions group is defined in core/highlights.lua
        -- with the other custom groups, so it survives colorscheme changes.
        local hipatterns = require("mini.hipatterns")
        hipatterns.setup({
            highlighters = {
                fixme = { pattern = "%f[%w]()FIXME()%f[%W]", group = "MiniHipatternsFixme" },
                hack = { pattern = "%f[%w]()HACK()%f[%W]", group = "MiniHipatternsHack" },
                todo = { pattern = "%f[%w]()TODO()%f[%W]", group = "MiniHipatternsTodo" },
                note = { pattern = "%f[%w]()NOTE()%f[%W]", group = "MiniHipatternsNote" },
                assumptions = { pattern = "%f[%w]()ASSUMPTIONS()%f[%W]", group = "MiniHipatternsAssumptions" },
                hex_color = hipatterns.gen_highlighter.hex_color(),
            },
        })

        local trailspace = require("mini.trailspace")
        trailspace.setup()
        vim.api.nvim_create_autocmd("BufWritePre", {
            desc = "Trim trailing whitespace on save",
            group = vim.api.nvim_create_augroup("MiniTrailspaceTrim", { clear = true }),
            callback = function(event)
                -- Same opt-out as conform's format-on-save: markdown relies on two
                -- trailing spaces for hard line breaks (after/ftplugin/markdown.lua).
                if vim.b[event.buf].disable_autoformat then return end
                trailspace.trim()
                trailspace.trim_last_lines()
            end,
        })
    end,
}
