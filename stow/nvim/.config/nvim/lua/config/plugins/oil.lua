-- =============================================================================
-- FILE: lua/config/plugins/oil.lua
-- File explorer that edits the filesystem like a regular Neovim buffer
--
-- DOCUMENTATION:
--   > GitHub : https://github.com/stevearc/oil.nvim
-- =============================================================================

return {
    "stevearc/oil.nvim",
    dependencies = {
        "echasnovski/mini.nvim", -- icons; configured in plugins/mini.lua
    },

    -- Lazy-loaded by the keymap below
    keys = {
        { "<leader>-", "<cmd>Oil --float<CR>", desc = "Open Oil" },
    },

    ---@module "oil"
    ---@type oil.SetupOpts
    opts = {
        columns = {
            "icon", -- File type icon (from mini.icons)
            "permissions", -- Unix permissions (rwxr-xr-x)
            "size", -- File size in human-readable format
            "mtime", -- Last modification time
        },

        view_options = {
            show_hidden = true, -- Show dotfiles
        },

        keymaps = {
            -- `q` closes Oil. core/autocmds.lua deliberately leaves oil out of
            -- its "close with q" list; this is the single definition.
            ["q"] = "actions.close",
        },

        float = {
            max_width = 0.8, -- fraction of screen width
            max_height = 0.8, -- fraction of screen height
            border = "rounded",
            padding = 2, -- cells between border and content
        },

        -- Deleting in Oil moves files to the trash instead of removing them,
        -- a safety net for accidents. Requires the `trash` CLI.
        delete_to_trash = true,
    },
}
