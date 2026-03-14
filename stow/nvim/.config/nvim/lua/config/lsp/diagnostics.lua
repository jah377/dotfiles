-- =============================================================================
-- FILE: lua/config/lsp/diagnostics.lua
-- Configures LSP diagnostic display (errors, warnings in sign column/virtual
-- text).
--
-- DOCUMENTATION:
--  > :help vim.diagnostic : Neovim diagnostic system
--  > :help vim.diagnostic.Opts : Configuration options
-- =============================================================================

-- Create `vim.notify` wrapper to suppress encoding warning from multi-client
-- race conditions. This is a recurring issue with Python caused by using both
-- `pyright` and `ruff` language servers. Warning is harmless but annoying.
local original_notify = vim.notify
vim.notify = function(msg, ...)
  if msg:match("position_encoding param is required in vim.lsp.util.make_position_params") then
    return
  end
  return original_notify(msg, ...)
end

-- Force UTF-16 encoding on all LSP clients for consistency
-- Again, this is an issue with python (pyright + ruff)
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("UserLspEncoding", {}),
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client then
      client.offset_encoding = "utf-16"
    end
  end,
})

-- Configure how LSP warning severity is visualized in gutter
local severity = vim.diagnostic.severity

vim.diagnostic.config({
  severity_sort = true,
  underline = { severity = severity.ERROR }, -- Only underline errors
  virtual_lines = { current_line = true }, -- Show diagnostic on cursor line (0.11+)
  -- Sign column icons (Nerd Font required - see globals.lua have_nerd_font)
  signs = {
    text = {
      [severity.ERROR] = "󰅚 ",
      [severity.WARN] = "󰀪 ",
      [severity.INFO] = "󰋽 ",
      [severity.HINT] = "󰌶 ",
    },
  },
})
