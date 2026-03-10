-- ================================================================================================
-- TITLE : LSP Keymaps
--
-- ABOUT : Keybindings applied when LSP attaches to a buffer
--
-- DEFAULTS :
--   > K      : Display hover information about symbol at point
--   > gra    : Select code action, if available
--   > CTRL-S : Display signature help [insert mode]
--   > CTRL-] : Jump to definition at point
--   > CTRL-O : Return to point
--
-- ================================================================================================

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("UserLspConfig", {}),
  callback = function(event)
    local nmap = function(keys, func, desc)
      if desc then
        desc = "LSP: " .. desc
      end

      vim.keymap.set("n", keys, func, {
        buffer = event.buf,
        desc = desc,
        silent = true,
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
    end, "Toggle Diagnostics")
  end,
})
