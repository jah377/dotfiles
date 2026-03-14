-- =============================================================================
-- FILE: lua/config/plugins/lsp/goto-preview.lua
-- Display LSP navigatino results in floating window
--
-- DOCUMENTATION:
--   > GitHub : https://github.com/rmagatti/goto-preview
--   > Keybindings defined in lsp/keymaps.lua
--
-- =============================================================================

return {
  -- Plugin identifier from GitHub
  "rmagatti/goto-preview",

  -- Logging library required by goto-preview
  dependencies = { "rmagatti/logger.nvim" },

  -- Load when an LSP server attaches (preview only works with LSP)
  event = "LspAttach",

  -- Configuration options (passed to setup())
  opts = {
    -- Size of the preview floating window
    width = 120, -- Width in columns
    height = 15, -- Height in lines

    -- Configure how references are displayed.
    -- Using Telescope provides a nice searchable list of all references.
    references = {
      provider = "telescope",
    },

    -- Hook that runs after a preview window opens.
    -- We use this to add a keymap for easily closing the preview.
    post_open_hook = function(buf, _)
      -- Add <Esc> keymap to close all preview windows.
      -- This is buffer-local, so it only works in preview windows.
      vim.keymap.set("n", "<Esc>", function()
        -- close_all_win() closes all goto-preview floating windows
        require("goto-preview").close_all_win()
      end, { buffer = buf, desc = "Close Preview" })

      -- Add <C-w>L keymap to break floating window into a right split.
      -- Saves cursor position, closes float, opens buffer in vsplit.
      vim.keymap.set("n", "<C-w>L", function()
        local cursor = vim.api.nvim_win_get_cursor(0)
        require("goto-preview").close_all_win()
        vim.cmd("vsplit")
        vim.api.nvim_set_current_buf(buf)
        vim.api.nvim_win_set_cursor(0, cursor)
      end, { buffer = buf, desc = "Break preview into right split" })
    end,
  },
}
