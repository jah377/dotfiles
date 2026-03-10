-- ================================================================================================
-- TITLE : LSP Diagnostics
--
-- ABOUT : Configure diagnostic display and signs
--
-- LINKS :
--   > :help vim.diagnostic.Opts
--   > https://gpanders.com/blog/whats-new-in-neovim-0-11/#virtual-lines
--
-- ================================================================================================

-- Suppress offset encoding warning (race condition during multi-client attach)
-- Both clients end up with utf-16, but warning fires during brief mismatch
local original_notify = vim.notify
vim.notify = function(msg, ...)
  if msg:match("position_encoding param is required in vim.lsp.util.make_position_params") then
    return
  end
  return original_notify(msg, ...)
end

-- Force consistent offset encoding at attach time (catches misbehaving servers)
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client then
      client.offset_encoding = "utf-16"
    end
  end,
})

-- Configure LSP diagnostics
local severity = vim.diagnostic.severity

vim.diagnostic.config({
  severity_sort = true,

  -- Use underline for diagnostics
  underline = { severity = severity.ERROR },

  -- Display diagnostics at point using virtual lines
  virtual_lines = { current_line = true },

  -- Indicate severity by nerd font symbols
  signs = {
    text = {
      [severity.ERROR] = "󰅚 ",
      [severity.WARN] = "󰀪 ",
      [severity.INFO] = "󰋽 ",
      [severity.HINT] = "󰌶 ",
    },
  },
})
