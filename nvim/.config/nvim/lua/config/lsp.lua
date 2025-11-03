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
local keymap = vim.keymap

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("UserLspConfig", {}),
  callback = function(event)
    -- ========================================
    -- Keymaps
    -- ========================================

    local buf = vim.lsp.buf
    local opts = { buffer = event.buf, silent = true }

    opts.desc = "Restart LSP"
    keymap.set("n", "<leader>lx", ":LspRestart<CR>", opts)

    opts.desc = "Rename symbol"
    keymap.set("n", "<leader>ln", buf.rename, opts)

    opts.desc = "List code actions"
    keymap.set("n", "<leader>la", vim.lsp.buf.code_action, opts)

    opts.desc = "List diagnostics for file"
    keymap.set("n", "<leader>lD", "<cmd>Telescope diagnostics bufnr=0<CR>", opts)

    opts.desc = "List references"
    keymap.set("n", "<leader>lr", "<cmd>Telescope lsp_references<CR>", opts)

    opts.desc = "List definitions"
    keymap.set("n", "<leader>ld", "<cmd>Telescope lsp_definitions<CR>", opts)

    opts.desc = "List implementations"
    keymap.set("n", "<leader>li", "<cmd>Telescope lsp_implementations<CR>", opts)

    opts.desc = "List document symbols"
    keymap.set("n", "<leader>ld", "<cmd>Telescope lsp_document_symbols<CR>", opts)

    opts.desc = "List workspace symbols"
    keymap.set("n", "<leader>ls", "<cmd>Telescope lsp_workspace_symbols<CR>", opts)

    -- Type definitions

    opts.desc = "List all type definitions"
    keymap.set("n", "<leader>ltd", "<cmd>Telescope lsp_type_definitions<CR>", opts)

    opts.desc = "List document functions"
    keymap.set("n", "<leader>ltf", "<cmd>Telescope lsp_document_symbols symbols=function<CR>", opts)

    opts.desc = "List document variables"
    keymap.set("n", "<leader>ltv", "<cmd>Telescope lsp_document_symbols symbols=variable<CR>", opts)

    opts.desc = "List document classes"
    keymap.set("n", "<leader>ltc", "<cmd>Telescope lsp_document_symbols symbols=class<CR>", opts)

    -- Detach LSP clients in current buffer
    opts.desc = "Deactivate LSP in buffer"
    keymap.set("n", "<leader>lX", function()
      local bufnr = vim.api.nvim_get_current_buf()
      local active_clients = vim.lsp.get_clients({ bufnr = bufnr })
      for _, client in ipairs(active_clients) do
        vim.lsp.buf_detach_client(bufnr, client.id)
      end
    end, opts)
  end,
})
