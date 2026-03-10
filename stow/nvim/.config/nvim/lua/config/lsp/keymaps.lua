-- ================================================================================================
-- TITLE : LSP Keymaps
--
-- ABOUT : Keybindings applied when LSP attaches to a buffer
--
-- DEFAULTS (Neovim 0.10+):
--   > K       : Display hover information about symbol at point
--   > CTRL-S  : Display signature help [insert mode]
--   > CTRL-]  : Jump to definition at point (tag-style)
--   > CTRL-O  : Return to previous position
--
-- ================================================================================================

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("UserLspConfig", {}),
  callback = function(event)
    local function map(mode, keys, func, desc)
      vim.keymap.set(mode, keys, func, {
        buffer = event.buf,
        desc = "LSP: " .. desc,
        silent = true,
      })
    end

    -- Diagnostic navigation (standard vim pattern)
    map("n", "[d", function()
      vim.diagnostic.jump({ count = -1 })
    end, "Previous Diagnostic")
    map("n", "]d", function()
      vim.diagnostic.jump({ count = 1 })
    end, "Next Diagnostic")

    -- Navigation (jump to location, CTRL-O to return)
    map("n", "<leader>ld", vim.lsp.buf.definition, "Definition")
    map("n", "<leader>lD", vim.lsp.buf.declaration, "Declaration")
    map("n", "<leader>lr", "<cmd>Telescope lsp_references<CR>", "References")
    map("n", "<leader>li", "<cmd>Telescope lsp_implementations<CR>", "Implementations")
    map("n", "<leader>lt", "<cmd>Telescope lsp_type_definitions<CR>", "Type Definition")

    -- Preview (view in floating window)
    local gp = require("goto-preview")
    map("n", "<leader>ld", gp.goto_preview_definition, "Preview Definition")
    map("n", "<leader>lD", gp.goto_preview_declaration, "Preview Declaration")
    map("n", "<leader>lR", gp.goto_preview_references, "Preview References")
    map("n", "<leader>lI", gp.goto_preview_implementation, "Preview Implementation")
    map("n", "<leader>lT", gp.goto_preview_type_definition, "Preview Type Definition")

    -- Symbols
    map("n", "<leader>ls", function()
      require("telescope.builtin").lsp_document_symbols({
        sorting_strategy = "ascending",
        sorter = require("telescope.sorters").get_substr_matcher(),
      })
    end, "Document Symbols")
    map("n", "<leader>lS", "<cmd>Telescope lsp_workspace_symbols<CR>", "Workspace Symbols")

    -- Actions
    map("n", "<leader>la", vim.lsp.buf.code_action, "Code Action")
    map("n", "<leader>ln", vim.lsp.buf.rename, "Rename")
    map("v", "<leader>lf", vim.lsp.buf.format, "Format Range")

    -- Diagnostics
    map("n", "<leader>lq", vim.diagnostic.setqflist, "Quickfix List")

    -- Info (K=hover info; CTRL-S=signature help [insert mode])
    map("n", "<leader>lk", vim.lsp.buf.signature_help, "Signature Help")

    -- Call hierarchy
    map("n", "<leader>lc", vim.lsp.buf.incoming_calls, "Incoming Calls")
    map("n", "<leader>lC", vim.lsp.buf.outgoing_calls, "Outgoing Calls")

    -- Meta
    map("n", "<leader>lx", "<cmd>LspRestart<CR>", "Restart")
    map("n", "<leader>lT", function()
      vim.diagnostic.enable(not vim.diagnostic.is_enabled())
    end, "Toggle Diagnostics")
  end,
})
