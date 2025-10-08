-- ================================================================================================
-- TITLE : LSP Diagnostics
--
-- ABOUT : Configure diagnostics
--
-- FILES :
--   > plugins/lsp/               : Contains server-specific setting files
--   > ../helpers/on_attach.lua   : Configure buffer-local setup
--   > ../helpers/diagnostics.lua : Configure LSP diagnostics
--
-- ================================================================================================

local M = {}

-- Configure LSP diagnostics
-- See :help vim.diagnostic.Opts

M.setup = function()
  vim.diagnostic.config({

    -- Use underline for diagnostics
    underline = { severity = vim.diagnostic.severity.ERROR },

    -- Display diagnostics at point using virtual lines
    -- https://gpanders.com/blog/whats-new-in-neovim-0-11/#virtual-lines
    virtual_lines = { current_line = true },

    -- Indicate severity by `nerd font` symbols
    severity_sort = true,
    signs = {
      text = {
        [vim.diagnostic.severity.ERROR] = "󰅚 ",
        [vim.diagnostic.severity.WARN] = "󰀪 ",
        [vim.diagnostic.severity.INFO] = "󰋽 ",
        [vim.diagnostic.severity.HINT] = "󰌶 ",
      },
    },
  })
end

return M
