-- =============================================================================
-- FILE: lua/config/plugins/oil.lua
--
-- PURPOSE:
--   Configures oil.nvim, a file explorer that lets you edit your filesystem
--   like a regular Neovim buffer. Unlike traditional file tree explorers,
--   Oil shows files as lines of text that you can edit, delete, and rename
--   using normal Vim motions.
--
-- WHY OIL.NVIM?
--   - Edit filenames with regular Vim commands (cw to rename, dd to delete)
--   - Navigate directories by pressing Enter on a folder
--   - Preview files before opening them
--   - Safer than command-line: deleted files go to trash
--
-- HOW TO USE:
--   <leader>- : Open Oil in a floating window at the current file's directory
--   q         : Close the Oil window
--   <CR>      : Open file/directory under cursor
--   -         : Go to parent directory
--   :w        : Save changes (perform file operations)
--
-- DOCUMENTATION:
--   > GitHub : https://github.com/stevearc/oil.nvim
--
-- =============================================================================

return {
  {
    -- Plugin identifier: "username/repo" format from GitHub
    "stevearc/oil.nvim",

    -- Type annotations for Lua LSP (helps with autocompletion and type checking)
    -- These are comments that the Lua language server understands
    ---@module 'oil'
    ---@type oil.SetupOpts

    -- Plugins that Oil depends on.
    -- These will be loaded before Oil is loaded.
    dependencies = {
      -- mini.icons provides file type icons in the Oil buffer.
      -- opts = {} triggers lazy.nvim to call setup() with empty config.
      { "echasnovski/mini.icons", opts = {} },
    },

    -- Define the keymap that triggers loading this plugin.
    -- Oil is "lazy loaded" - it doesn't load until you press this key.
    -- This improves startup time since the plugin isn't loaded unnecessarily.
    keys = {
      -- Opens Oil in a floating window (not a split)
      -- <cmd> is more efficient than : for keymaps (no mode switching)
      { "<leader>-", "<cmd>Oil --float<CR>", desc = "Open Oil" },
    },

    -- Configuration function runs after the plugin loads.
    -- This is where we customize Oil's behavior.
    config = function()
      require("oil").setup({
        -- Configure which columns to display in the file listing.
        -- Each column shows different file metadata.
        columns = {
          "icon",        -- File type icon (from mini.icons)
          "permissions", -- Unix permissions (rwxr-xr-x)
          "size",        -- File size in human-readable format
          "mtime",       -- Last modification time
        },

        -- Control which files are shown in the listing
        view_options = {
          show_hidden = true, -- Show dotfiles (hidden files like .gitignore)
        },

        -- Custom keymaps within the Oil buffer.
        -- These only work when you're inside the Oil file explorer.
        keymaps = {
          -- Allow pressing 'q' to close Oil (matches our special buffer pattern)
          ["q"] = "actions.close",
        },

        -- Configure the floating window appearance.
        -- Float windows appear on top of your current content.
        float = {
          max_width = 0.8,      -- 80% of screen width
          max_height = 0.8,     -- 80% of screen height
          border = "rounded",   -- Rounded corners on the window border
          padding = 2,          -- Space between border and content
        },

        -- When you delete files in Oil, send them to trash instead of
        -- permanently deleting them. This provides a safety net for
        -- accidental deletions.
        -- Note: Requires 'trash' CLI tool to be installed.
        delete_to_trash = true,
      })
    end,
  },
}
