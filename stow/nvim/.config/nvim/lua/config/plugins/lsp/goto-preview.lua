-- =============================================================================
-- FILE: lua/config/plugins/lsp/goto-preview.lua
--
-- PURPOSE:
--   Configures goto-preview, which displays LSP navigation results (like
--   "go to definition" or "find references") in floating preview windows
--   instead of jumping directly to the location.
--
-- WHY USE PREVIEW WINDOWS?
--   - Peek at code without losing your place
--   - Read definitions/references in context
--   - Decide whether to actually jump to the location
--   - Review multiple references without navigating away
--
-- WORKFLOW:
--   1. Place cursor on a function/variable name
--   2. Press <leader>lpd to preview its definition
--   3. Read the preview in the floating window
--   4. Press <Esc> to close, OR
--   5. Press <C-w>L to move preview to a full split
--
-- KEYMAPS (defined in lsp/keymaps.lua):
--   <leader>lpd : Preview definition
--   <leader>lpD : Preview declaration
--   <leader>lr  : Preview references (uses Telescope)
--   <leader>lpi : Preview implementation
--   <leader>lpt : Preview type definition
--
-- DOCUMENTATION:
--   > GitHub : https://github.com/rmagatti/goto-preview
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
    width = 120,   -- Width in columns
    height = 15,   -- Height in lines

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
    end,
  },
}
