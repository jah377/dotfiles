-- =============================================================================
-- FILE: lua/config/lsp/keymaps.lua
-- LSP keymaps, active only when a language server attaches to buffer.
-- Built-in (Neovim 0.10+): K=hover, C-S=signature, C-]=definition, C-O=back
-- =============================================================================

-- Must create autocmd that runs when any LSP server attaches to buffer
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("UserLspConfig", {}),

  -- Callback function adds "LSP:" prefix to all keymaps defined below
  callback = function(event)
    local function map(mode, keys, func, desc)
      vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc, silent = true })
    end
    -- Restart LSP attached to current buffer
    map("n", "<leader>lx", "<cmd>LspRestart<CR>", "Restart")

    -- Use `goto-preview` plugin to show relevant information
    --  > definition : where variable was created
    --  > declaration : unless in C/C++, same as definition
    --  > references : Telescope-backend to see where used
    --  > implementation : where abstract classes defined
    --  > type-definition : where type/class/interface defined
    local gp = require("goto-preview")
    map("n", "<leader>ld", gp.goto_preview_definition, "Preview Definition")
    map("n", "<leader>lD", gp.goto_preview_declaration, "Preview Declaration")
    map("n", "<leader>lr", gp.goto_preview_references, "Preview References")
    map("n", "<leader>li", gp.goto_preview_implementation, "Preview Implementation")
    map("n", "<leader>lt", gp.goto_preview_type_definition, "Preview Type Definition")

    -- List all symbols used in current file, in order of appearance
    map("n", "<leader>ls", function()
      require("telescope.builtin").lsp_document_symbols({
        sorting_strategy = "ascending",
        sorter = require("telescope.sorters").get_substr_matcher(),
      })
    end, "Document Symbols")

    -- List all symbols across entire workspace or project (ie. other files)
    map("n", "<leader>lS", require("telescope.builtin").lsp_workspace_symbols, "Workspace Symbols")

    -- Show list of available automated fixes/refactoring provided by LSP
    map("n", "<leader>la", vim.lsp.buf.code_action, "Code Action")

    -- Rename symbol under cursor throughout entire project
    map("n", "<leader>ln", vim.lsp.buf.rename, "Rename")

    -- Format visually selected range of code
    -- Plugin `conform.nvim` used to format files
    map("v", "<leader>lf", vim.lsp.buf.format, "Format Range")

    -- View all diagnostics in current buffer as quickfix list
    -- Navigation keybindings defined in `core.keymaps`
    map("n", "<leader>lq", vim.diagnostic.setqflist, "Quickfix List")

    -- Quickly toggle diagnostics off in visually annoying
    map("n", "<leader>lT", function()
      vim.diagnostic.enable(not vim.diagnostic.is_enabled())
    end, "Toggle Diagnostics")

    -- Quickly navigate between diagnostic messages
    map("n", "[d", function()
      vim.diagnostic.jump({ count = -1 })
    end, "Previous Diagnostic")

    map("n", "]d", function()
      vim.diagnostic.jump({ count = 1 })
    end, "Next Diagnostic")

    -- Show function signature help (parameter names and types)
    -- Note: `K` for hover info; `CTRL-S` for signature help in insert-mode
    map("n", "<leader>lk", vim.lsp.buf.signature_help, "Signature Help")

    -- Show functions that call the function under cursor
    map("n", "<leader>lc", vim.lsp.buf.incoming_calls, "Incoming Calls")

    -- Show functions that the function under cursor uses
    map("n", "<leader>lC", vim.lsp.buf.outgoing_calls, "Outgoing Calls")
  end,
})
