-- =============================================================================
-- FILE: lua/config/plugins/nvim-cmp.lua
--
-- PURPOSE:
--   Configures nvim-cmp, the primary autocompletion plugin for Neovim. It
--   provides intelligent code completion by aggregating suggestions from
--   multiple sources: LSP, snippets, buffer words, file paths, and AI.
--
-- WHAT IS AUTOCOMPLETION?
--   As you type, nvim-cmp shows a popup menu with suggestions for what you
--   might want to type next. Sources include:
--   - LSP: Function names, variables, methods from language servers
--   - Snippets: Code templates you can expand and fill in
--   - Buffer: Words from the current file
--   - Path: File system paths
--   - Codeium: AI-powered suggestions
--
-- KEYMAPS (while completion menu is visible):
--   Ctrl-a   : Manually trigger completion
--   Ctrl-e   : Close completion menu
--   Enter    : Confirm selection (insert the completion)
--   Ctrl-j   : Move to next item
--   Ctrl-k   : Move to previous item
--   Ctrl-n   : Scroll docs down
--   Ctrl-p   : Scroll docs up
--   Tab      : Expand snippet or jump to next snippet placeholder
--   Shift-Tab: Jump to previous snippet placeholder
--
-- DOCUMENTATION:
--   > nvim-cmp           : https://github.com/hrsh7th/nvim-cmp
--   > lspkind (icons)    : https://github.com/onsails/lspkind.nvim
--   > LuaSnip            : https://github.com/L3MON4D3/LuaSnip
--   > friendly-snippets  : https://github.com/rafamadriz/friendly-snippets
--
-- =============================================================================

return {
  -- Plugin identifier from GitHub
  "hrsh7th/nvim-cmp",

  -- Dependencies that provide completion sources and functionality
  dependencies = {
    -- VS Code-like icons in the completion menu (function, variable, etc.)
    "onsails/lspkind.nvim",

    -- Enables LuaSnip as a completion source
    "saadparwaiz1/cmp_luasnip",

    -- Snippet engine - expands code templates with placeholders
    "L3MON4D3/LuaSnip",

    -- Large collection of pre-made snippets for many languages
    "rafamadriz/friendly-snippets",

    -- Completion source for words from current buffer
    "hrsh7th/cmp-buffer",

    -- Completion source for filesystem paths
    "hrsh7th/cmp-path",

    -- Completion source for function signatures while typing
    "hrsh7th/cmp-nvim-lsp-signature-help",
  },

  config = function()
    -- Load required modules
    local lspkind = require("lspkind")  -- Icons for completion items
    local cmp = require("cmp")          -- Main completion plugin
    local luasnip = require("luasnip")  -- Snippet engine

    -- Load snippets from friendly-snippets (VS Code-style snippets)
    -- lazy_load() defers loading until snippets are actually needed
    require("luasnip.loaders.from_vscode").lazy_load()

    -- Configure nvim-cmp
    cmp.setup({
      -- Performance tuning
      performance = {
        -- Maximum number of items to show in the completion menu
        -- Too many items can be overwhelming; 15 is a good balance
        max_view_entries = 15,
      },

      -- Define keymaps for interacting with the completion menu
      mapping = cmp.mapping.preset.insert({
        -- Manually trigger completion (useful when it doesn't auto-appear)
        ["<C-a>"] = cmp.mapping.complete(),

        -- Close the completion menu without selecting anything
        ["<C-e>"] = cmp.mapping.abort(),

        -- Confirm the selected completion (insert it into the buffer)
        -- select = false means don't auto-select first item on Enter
        ["<CR>"] = cmp.mapping.confirm({ select = false }),

        -- Navigate completion menu (up/down)
        ["<C-k>"] = cmp.mapping.select_prev_item(),  -- Previous item
        ["<C-j>"] = cmp.mapping.select_next_item(),  -- Next item

        -- Scroll documentation window (shown for some completions)
        ["<C-n>"] = cmp.mapping.scroll_docs(4),   -- Scroll down
        ["<C-p>"] = cmp.mapping.scroll_docs(-4),  -- Scroll up

        -- Tab: Expand snippet or jump to next placeholder
        -- If cursor is in a snippet, Tab moves to the next field
        -- Otherwise, Tab performs its normal function
        ["<Tab>"] = cmp.mapping(function(fallback)
          if luasnip.expand_or_locally_jumpable() then
            luasnip.expand_or_jump()
          else
            fallback()  -- Use default Tab behavior
          end
        end, { "i", "s" }),  -- Works in insert and select modes

        -- Shift-Tab: Jump to previous snippet placeholder
        ["<S-Tab>"] = cmp.mapping(function(fallback)
          if luasnip.jumpable(-1) then
            luasnip.jump(-1)
          else
            fallback()  -- Use default Shift-Tab behavior
          end
        end, { "i", "s" }),
      }),

      -- Configure snippet expansion
      snippet = {
        expand = function(args)
          -- Use LuaSnip to expand snippets
          luasnip.lsp_expand(args.body)
        end,
      },

      -- Define completion sources and their priority (first = highest priority)
      sources = {
        { name = "codeium" },               -- AI-powered suggestions
        { name = "luasnip" },               -- Snippets
        { name = "nvim_lsp" },              -- LSP completions
        { name = "buffer" },                -- Words from current buffer
        { name = "path" },                  -- File paths
        { name = "nvim_lsp_signature_help" }, -- Function signatures
      },

      -- Configure how completion items are displayed
      formatting = {
        format = lspkind.cmp_format({
          -- Show both icon and text (e.g., " Function")
          mode = "symbol_text",

          -- Custom icons for each completion source
          -- These appear next to the completion item
          menu = {
            codeium = "",  -- AI robot icon
            luasnip = "",  -- Snippet icon
            buffer = "",   -- File icon
            path = "",     -- Folder icon
            nvim_lsp = "🅻", -- LSP badge
          },
        }),
      },
    })
  end,
}
