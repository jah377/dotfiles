-- ================================================================================================
-- TITLE : LSP
--
-- ABOUT : Configure diagnostics and 'on_attach' function
--
-- LINKS :
--  > Josean Martinez : https://www.youtube.com/watch?v=oBiBEx7L000&t=965s
--
-- DEFAULTS :
--  > K      : Display hover information about symbol at point
--  > gra    : Select code action, if available
--  > CTRL-S : Display signature help [insert mode]
--
--  > CTRL-] : jump to definition at point
--  > CTRL-O : return to point
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
-- See :help vim.diagnostic.Opts for available settings

local severity = vim.diagnostic.severity

vim.diagnostic.config({
  severity_sort = true,

  -- Use underline for diagnostics
  underline = { severity = severity.ERROR },

  -- Display diagnostics at point using virtual lines
  -- https://gpanders.com/blog/whats-new-in-neovim-0-11/#virtual-lines
  virtual_lines = { current_line = true },

  -- Indicate severity by `nerd font` symbols
  signs = {
    text = {
      [severity.ERROR] = "󰅚 ",
      [severity.WARN] = "󰀪 ",
      [severity.INFO] = "󰋽 ",
      [severity.HINT] = "󰌶 ",
    },
  },
})

-- Configure keybindings
-- See `:help vim.lsp.*` for available functions

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("UserLspConfig", {}),
  callback = function(event)
    local nmap = function(keys, func, desc)
      if desc then
        desc = "LSP: " .. desc
      end

      vim.keymap.set("n", keys, func, {
        buffer = event.buf, -- only apply to current buffer
        desc = desc, -- description of kbd
        silent = true, -- don't show cmd in cmdline when mapping executed
      })
    end

    -- Default keybindings
    nmap("grn", vim.lsp.buf.rename, "Rename Variable")
    nmap("gra", vim.lsp.buf.code_action, "Code Actions")
    nmap("grr", "<cmd>Telescope lsp_references<CR>", "References")
    nmap("gri", "<cmd>Telescope lsp_implementations<CR>", "Implementations")
    nmap("grt", "<cmd>Telescope lsp_type_definitions<CR>", "Type Definitions")
    nmap("g0", function()
      require("telescope.builtin").lsp_document_symbols({
        sorting_strategy = "ascending",
        sorter = require("telescope.sorters").get_substr_matcher(),
      })
    end, "Document Symbols")
    nmap("K", vim.lsp.buf.hover, "Display Hover Info")

    -- Extras
    nmap("<C-k>", vim.lsp.buf.signature_help, "Display Signature Help")
    nmap("grx", ":LspRestart<CR>", "Restart LSP")
    nmap("gT", function()
      vim.diagnostic.enable(not vim.diagnostic.is_enabled())
    end, "Toggle Diagnostics") -- kbd overwrites "Go to next tab page"
  end,
})
