-- =============================================================================
-- FILE: lua/config/lsp/keymaps.lua
-- LSP keymaps, active only when a language server attaches to buffer.
-- Built-in (Neovim 0.10+): K=hover, C-S=signature, C-]=definition, C-O=back
-- =============================================================================

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("UserLspConfig", {}),
  callback = function(event)
    local function map(mode, keys, func, desc)
      vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc, silent = true })
    end

    -- DIAGNOSTIC NAVIGATION --
    map("n", "[d", function() vim.diagnostic.jump({ count = -1 }) end, "Previous Diagnostic")
    map("n", "]d", function() vim.diagnostic.jump({ count = 1 }) end, "Next Diagnostic")

    -- PREVIEW NAVIGATION (goto-preview plugin) --
    local gp = require("goto-preview")
    map("n", "<leader>lpd", gp.goto_preview_definition, "Preview Definition")
    map("n", "<leader>lpD", gp.goto_preview_declaration, "Preview Declaration")
    map("n", "<leader>lr", gp.goto_preview_references, "Preview References")
    map("n", "<leader>lpi", gp.goto_preview_implementation, "Preview Implementation")
    map("n", "<leader>lpt", gp.goto_preview_type_definition, "Preview Type Definition")

    -- SYMBOLS (Telescope) --
    map("n", "<leader>ls", function()
      require("telescope.builtin").lsp_document_symbols({
        sorting_strategy = "ascending",
        sorter = require("telescope.sorters").get_substr_matcher(),
      })
    end, "Document Symbols")
    map("n", "<leader>lS", require("telescope.builtin").lsp_workspace_symbols, "Workspace Symbols")

    -- ACTIONS --
    map("n", "<leader>la", vim.lsp.buf.code_action, "Code Action")
    map("n", "<leader>ln", vim.lsp.buf.rename, "Rename")
    map("v", "<leader>lf", vim.lsp.buf.format, "Format Range")  -- Full-file: conform.nvim

    -- DIAGNOSTICS --
    map("n", "<leader>lq", vim.diagnostic.setqflist, "Quickfix List")  -- Navigate: core/keymaps.lua

    -- INFO --
    map("n", "<leader>lk", vim.lsp.buf.signature_help, "Signature Help")

    -- CALL HIERARCHY --
    map("n", "<leader>lc", vim.lsp.buf.incoming_calls, "Incoming Calls")
    map("n", "<leader>lC", vim.lsp.buf.outgoing_calls, "Outgoing Calls")

    -- META --
    map("n", "<leader>lx", "<cmd>LspRestart<CR>", "Restart")
    map("n", "<leader>lT", function()
      vim.diagnostic.enable(not vim.diagnostic.is_enabled())
    end, "Toggle Diagnostics")
  end,
})
