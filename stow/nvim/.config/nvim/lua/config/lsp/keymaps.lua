-- =============================================================================
-- FILE: lua/config/lsp/keymaps.lua
-- LSP keymaps, created per buffer when a language server attaches.
-- Built-in (Neovim 0.10+): K=hover, C-S=signature, C-]=definition, C-O=back
-- =============================================================================

vim.api.nvim_create_autocmd("LspAttach", {
    desc = "Buffer-local LSP keymaps",
    group = vim.api.nvim_create_augroup("UserLspConfig", {}),
    callback = function(event)
        -- Plugins are required inside the callback so they load lazily and
        -- only once an LSP buffer exists. goto-preview itself loads on
        -- LspAttach (plugins/goto-preview.lua); lazy.nvim registered that
        -- handler during startup, before this file ran, so it has executed by
        -- now.
        local goto_preview = require("goto-preview")
        local builtin = require("telescope.builtin")
        local sorters = require("telescope.sorters")

        --- Buffer-local keymap with an "LSP: " description prefix.
        --- @param mode string|string[]
        --- @param keys string
        --- @param rhs string|function
        --- @param desc string
        local function map(mode, keys, rhs, desc) vim.keymap.set(mode, keys, rhs, { buffer = event.buf, desc = "LSP: " .. desc, silent = true }) end

        map("n", "<leader>lx", "<cmd>LspRestart<CR>", "Restart")

        -- Previews open in a floating window (goto-preview):
        --  > definition      : where the symbol was created
        --  > declaration     : same as definition outside C/C++
        --  > references      : Telescope list of usages
        --  > implementation  : where an abstract class is implemented
        --  > type definition : where the type/class/interface is defined
        map("n", "<leader>ld", goto_preview.goto_preview_definition, "Preview Definition")
        map("n", "<leader>lD", goto_preview.goto_preview_declaration, "Preview Declaration")
        map("n", "<leader>lr", goto_preview.goto_preview_references, "Preview References")
        map("n", "<leader>li", goto_preview.goto_preview_implementation, "Preview Implementation")
        map("n", "<leader>lt", goto_preview.goto_preview_type_definition, "Preview Type Definition")

        -- Symbol pickers
        map("n", "<leader>lsw", builtin.lsp_workspace_symbols, "Workspace Symbols")
        map("n", "<leader>lss", function()
            -- Document order rather than fuzzy score, so the list reads like an outline
            builtin.lsp_document_symbols({ sorting_strategy = "ascending", sorter = sorters.get_substr_matcher() })
        end, "Document Symbols")
        map("n", "<leader>lsc", function() builtin.lsp_document_symbols({ symbols = { "Class" } }) end, "Document Classes")
        map("n", "<leader>lsf", function() builtin.lsp_document_symbols({ symbols = { "Function", "Method" } }) end, "Document Functions")

        map("n", "<leader>la", vim.lsp.buf.code_action, "Code Action")
        map("n", "<leader>ln", vim.lsp.buf.rename, "Rename")

        -- Range formatting goes through conform.nvim (plugins/conform.lua), the
        -- same path as format-on-save, so both apply identical formatters.
        -- conform.format() uses the visual selection as the range when called
        -- from visual mode. lsp_format = "fallback" mirrors default_format_opts.
        map("x", "<leader>lf", function() require("conform").format({ async = true, lsp_format = "fallback" }) end, "Format Range")

        -- Diagnostics (quickfix navigation keymaps live in core/keymaps.lua)
        map("n", "<leader>lq", vim.diagnostic.setqflist, "Quickfix List")
        map("n", "<leader>lT", function() vim.diagnostic.enable(not vim.diagnostic.is_enabled()) end, "Toggle Diagnostics")
        map("n", "[d", function() vim.diagnostic.jump({ count = -1 }) end, "Previous Diagnostic")
        map("n", "]d", function() vim.diagnostic.jump({ count = 1 }) end, "Next Diagnostic")

        -- `K` shows hover; `CTRL-S` shows signature help in insert mode
        map("n", "<leader>lk", vim.lsp.buf.signature_help, "Signature Help")
        map("n", "<leader>lc", vim.lsp.buf.incoming_calls, "Incoming Calls")
        map("n", "<leader>lC", vim.lsp.buf.outgoing_calls, "Outgoing Calls")
    end,
})
