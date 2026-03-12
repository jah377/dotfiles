-- =============================================================================
-- FILE: lua/config/lsp/keymaps.lua
--
-- PURPOSE:
--   This file defines keyboard shortcuts that become active when an LSP
--   (Language Server Protocol) server attaches to a buffer. These keymaps
--   provide powerful code navigation, refactoring, and documentation features.
--
-- WHY CONDITIONAL KEYMAPS?
--   LSP keymaps only make sense when a language server is active. For example,
--   "go to definition" requires a server that understands your code. By using
--   the LspAttach event, we ensure these keymaps only exist in buffers where
--   they'll actually work.
--
-- BUILT-IN DEFAULTS (Neovim 0.10+):
--   These keymaps are provided by Neovim itself when LSP is attached:
--   > K        : Display hover information about symbol at cursor
--   > Ctrl-S   : Display function signature help (in insert mode)
--   > Ctrl-]   : Jump to definition (tag-style navigation)
--   > Ctrl-O   : Return to previous position after jumping
--
-- WORKFLOW EXAMPLE (Preview Definition):
--   1. <leader>lpd : Open definition preview in floating window
--   2. Read the code in the preview
--   3. <Esc>       : Close the preview window
--   -- OR --
--   3. <C-w>L     : Move preview to a full split (then <C-w>c to close)
--
-- DOCUMENTATION:
--   > :help lsp         : LSP overview
--   > :help vim.lsp.buf : LSP buffer functions
--   > :help lsp-defaults: Built-in LSP keymaps
--
-- =============================================================================

-- Create an autocommand that runs when any LSP server attaches to a buffer.
-- This is the trigger that sets up all the keymaps below.
vim.api.nvim_create_autocmd("LspAttach", {
  -- Create a named group for this autocommand
  group = vim.api.nvim_create_augroup("UserLspConfig", {}),

  -- The callback function runs every time an LSP server attaches
  -- 'event' contains information about which buffer triggered this
  callback = function(event)

    -- Helper function to create buffer-local keymaps with consistent options.
    -- This reduces repetition and ensures all LSP keymaps have the same setup.
    --
    -- Parameters:
    --   mode  : Which mode(s) the keymap applies to ("n" for normal, etc.)
    --   keys  : The key sequence to trigger the action
    --   func  : The function or command to run
    --   desc  : Human-readable description (shown in which-key)
    local function map(mode, keys, func, desc)
      vim.keymap.set(mode, keys, func, {
        buffer = event.buf,       -- Only apply to the current buffer
        desc = "LSP: " .. desc,   -- Prefix all descriptions with "LSP:"
        silent = true,            -- Don't show command in command line
      })
    end

    -- =========================================================================
    -- DIAGNOSTIC NAVIGATION
    -- =========================================================================
    -- Navigate between diagnostic messages (errors, warnings, etc.)
    -- This follows the standard Vim pattern of using [ and ] for prev/next

    -- Jump to the previous diagnostic message in the buffer
    -- Useful for reviewing errors one by one
    map("n", "[d", function()
      vim.diagnostic.jump({ count = -1 })  -- -1 means go backwards
    end, "Previous Diagnostic")

    -- Jump to the next diagnostic message in the buffer
    map("n", "]d", function()
      vim.diagnostic.jump({ count = 1 })   -- 1 means go forwards
    end, "Next Diagnostic")

    -- =========================================================================
    -- NAVIGATION (using goto-preview plugin)
    -- =========================================================================
    -- These use the goto-preview plugin to show definitions, references, etc.
    -- in floating windows instead of jumping directly to the location.
    --
    -- This allows you to peek at code without leaving your current context.
    -- Standard navigation (Ctrl-] to jump, Ctrl-O to return) still works.

    -- Load the goto-preview plugin for preview functionality
    local gp = require("goto-preview")

    -- Preview the definition of the symbol under the cursor.
    -- "Definition" means where the function/variable/class was created.
    -- Example: On a function call, this shows where the function was defined.
    map("n", "<leader>lpd", gp.goto_preview_definition, "Preview Definition")

    -- Preview the declaration of the symbol under the cursor.
    -- "Declaration" vs "Definition":
    --   Declaration = where something is announced (e.g., function signature)
    --   Definition = where it's implemented (e.g., function body)
    -- In many languages these are the same; in C/C++ they can differ.
    map("n", "<leader>lpD", gp.goto_preview_declaration, "Preview Declaration")

    -- Preview all references to the symbol under the cursor.
    -- Shows everywhere this function/variable is used in the codebase.
    -- Uses Telescope for the list interface.
    map("n", "<leader>lr", gp.goto_preview_references, "Preview References")

    -- Preview implementations of the symbol under the cursor.
    -- Useful for interfaces/abstract classes - shows concrete implementations.
    map("n", "<leader>lpi", gp.goto_preview_implementation, "Preview Implementation")

    -- Preview the type definition of the symbol under the cursor.
    -- Shows where the type/class/interface was defined.
    -- Example: On a variable, shows where its type was defined.
    map("n", "<leader>lpt", gp.goto_preview_type_definition, "Preview Type Definition")

    -- =========================================================================
    -- SYMBOLS
    -- =========================================================================
    -- Symbols are named entities in your code: functions, classes, variables, etc.

    -- Show all symbols in the current file using Telescope.
    -- Great for navigating large files - type to filter, Enter to jump.
    map("n", "<leader>ls", function()
      require("telescope.builtin").lsp_document_symbols({
        sorting_strategy = "ascending",  -- A-Z ordering
        sorter = require("telescope.sorters").get_substr_matcher(),  -- Fuzzy match
      })
    end, "Document Symbols")

    -- Show all symbols across the entire workspace/project.
    -- Useful for finding functions or classes in other files.
    map("n", "<leader>lS", require("telescope.builtin").lsp_workspace_symbols, "Workspace Symbols")

    -- =========================================================================
    -- ACTIONS
    -- =========================================================================
    -- Code actions are automated fixes and refactorings offered by the LSP

    -- Show available code actions for the current cursor position.
    -- Examples: "import missing module", "convert to f-string", "extract method"
    -- A menu appears with available actions; select one to apply.
    map("n", "<leader>la", vim.lsp.buf.code_action, "Code Action")

    -- Rename the symbol under the cursor throughout the entire project.
    -- The LSP understands your code's structure, so this is smarter than
    -- find-and-replace: it only renames the actual symbol, not coincidental
    -- string matches.
    map("n", "<leader>ln", vim.lsp.buf.rename, "Rename")

    -- Format the visually selected range of code.
    -- Select code in visual mode, then use this to format just that section.
    -- (Full-file formatting is typically handled by conform.nvim on save)
    map("v", "<leader>lf", vim.lsp.buf.format, "Format Range")

    -- =========================================================================
    -- DIAGNOSTICS
    -- =========================================================================

    -- Send all diagnostics in the current buffer to the quickfix list.
    -- The quickfix list is a persistent list you can navigate with
    -- :cnext/:cprev or the keymaps defined in core/keymaps.lua.
    -- Useful for working through all errors in a file systematically.
    map("n", "<leader>lq", vim.diagnostic.setqflist, "Quickfix List")

    -- =========================================================================
    -- INFO
    -- =========================================================================
    -- Note: 'K' for hover info and Ctrl-S for signature help are built-in

    -- Show function signature help (parameter names and types).
    -- This is the same as Ctrl-S in insert mode, but for normal mode.
    map("n", "<leader>lk", vim.lsp.buf.signature_help, "Signature Help")

    -- =========================================================================
    -- CALL HIERARCHY
    -- =========================================================================
    -- Understand how functions call each other in your codebase

    -- Show functions that CALL the function under cursor ("who calls me?")
    -- Useful for understanding how a function is used.
    map("n", "<leader>lc", vim.lsp.buf.incoming_calls, "Incoming Calls")

    -- Show functions that the function under cursor CALLS ("what do I call?")
    -- Useful for understanding what a function depends on.
    map("n", "<leader>lC", vim.lsp.buf.outgoing_calls, "Outgoing Calls")

    -- =========================================================================
    -- META / TROUBLESHOOTING
    -- =========================================================================

    -- Restart the LSP server for the current buffer.
    -- Useful when the server gets into a bad state or after config changes.
    map("n", "<leader>lx", "<cmd>LspRestart<CR>", "Restart")

    -- Toggle diagnostics on/off for the entire editor.
    -- Sometimes you want to focus on writing without distraction from
    -- error messages. This lets you temporarily hide all diagnostics.
    map("n", "<leader>lT", function()
      vim.diagnostic.enable(not vim.diagnostic.is_enabled())
    end, "Toggle Diagnostics")
  end,
})
