-- ================================================================================================
-- TITLE : LSP On-Attach
--
-- ABOUT : Configure settings and keybindings on-attach
--
-- FILES :
--   > plugins/lsp/               : Contains server-specific setting files
--   > ../helpers/on_attach.lua   : Configure buffer-local setup
--   > ../helpers/diagnostics.lua : Configure LSP diagnostics
--
-- ================================================================================================

local M = {}

M.on_attach = function(client, bufnr)
  local keymap = vim.keymap.set
  local opts = {
    noremap = true, -- prevent non-recursive mapping
    silent = true, -- don't print the cmd to the cli
    buffer = bufnr, -- restrict kmap to the local buffer number
  }

  -- Native nvim keymaps
  keymap("n", "<leader>ld", "<cmd>lua vim.lsp.buf.definition()<CR>", opts) -- goto definition
  keymap("n", "<leader>lD", "<cmd>vsplit | lua vim.lsp.buf.definition()<CR>", opts) -- goto definition in split
  keymap("n", "<leader>lc", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts) -- Code actions
  keymap("n", "<leader>lr", "<cmd>lua vim.lsp.buf.rename()<CR>", opts) -- Rename symbol
  keymap("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts) -- hover documentation

  -- Telescope nvim keymaps
  local builtin = require("telescope.builtin")
  keymap("n", "<leader>ltr", builtin.lsp_references, { desc = "[T]elescope [R]eferences" })
  keymap("n", "<leader>lti", builtin.lsp_incoming_calls, { desc = "[T]elescope [I]ncoming calls" })
  keymap("n", "<leader>lto", builtin.lsp_outgoing_calls, { desc = "[T]elescope [O]utgoing calls" })
  keymap("n", "<leader>ltd", builtin.lsp_definitions, { desc = "[T]elescope [D]efinitions" })
  keymap("n", "<leader>ltt", builtin.lsp_type_definitions, { desc = "[T]elescope [T]ype definitions" })
  keymap("n", "<leader>ltm", builtin.lsp_implementation, { desc = "[T]elescope i[M]plementation" })
  keymap("n", "<leader>ltS", builtin.lsp_document_symbols, { desc = "[T]elescope document [S]ymbols" })
  keymap("n", "<leader>ltW", builtin.lsp_workspace_symbols, { desc = "[T]elescope [W]orkspace symbols" })
  keymap(
    "n",
    "<leader>ltD",
    builtin.lsp_dynamic_workspace_symbols,
    { desc = "[T]elescope [D]ynamic workspace symbols" }
  )

  -- Order Imports (if supported by the client LSP)
  if client:supports_method("textDocument/codeAction", bufnr) then
    keymap("n", "<leader>lo", function()
      vim.lsp.buf.code_action({
        context = {
          only = { "source.organizeImports" },
          diagnostics = {},
        },
        apply = true,
        bufnr = bufnr,
      })
      -- Format after changing import order
      vim.defer_fn(function()
        vim.lsp.buf.format({ bufnr = bufnr })
      end, 50) -- Slight delay to allow for the import order to go first
    end, opts)
  end

  -- Enable completion (if supported by the client LSP)
  if client:supports_method("textDocument/completion") then
    vim.lsp.completion.enable(true, client.id, bufnr, { autotrigger = false })
  end
end

return M
