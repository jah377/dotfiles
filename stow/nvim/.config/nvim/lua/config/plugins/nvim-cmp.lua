-- =============================================================================
-- FILE: lua/config/plugins/nvim-cmp.lua
--
-- Primary autocompletion plugin for Neovim. Aggregates suggestions from
-- multiple sources: LSP, snippets, buffer words, file paths, and AI.
--
-- DOCUMENTATION:
--   > nvim-cmp (core):        https://github.com/hrsh7th/nvim-cmp
--   > lspkind (icons):        https://github.com/onsails/lspkind.nvim
--   > LuaSnip (snippets):     https://github.com/L3MON4D3/LuaSnip
--   > friendly-snippets:      https://github.com/rafamadriz/friendly-snippets
--   > cmp_luasnip (source):   https://github.com/saadparwaiz1/cmp_luasnip
--   > cmp-buffer (source):    https://github.com/hrsh7th/cmp-buffer
--   > cmp-path (source):      https://github.com/hrsh7th/cmp-path
--   > cmp-nvim-lsp-signature: https://github.com/hrsh7th/cmp-nvim-lsp-signature-help
--
-- =============================================================================

return {
  "hrsh7th/nvim-cmp",
  dependencies = {
    "onsails/lspkind.nvim",
    "saadparwaiz1/cmp_luasnip",
    "L3MON4D3/LuaSnip",
    "rafamadriz/friendly-snippets",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-path",
    "hrsh7th/cmp-nvim-lsp-signature-help",
  },

  config = function()
    local lspkind = require("lspkind")
    local cmp = require("cmp")
    local luasnip = require("luasnip")

    require("luasnip.loaders.from_vscode").lazy_load()

    cmp.setup({
      performance = { max_view_entries = 15 },

      mapping = cmp.mapping.preset.insert({
        ["<C-y>"] = cmp.mapping.complete(),
        ["<esc>"] = cmp.mapping.abort(),

        -- Don't autoselect first time on Enter
        ["<CR>"] = cmp.mapping.confirm({ select = false }),
        ["<C-k>"] = cmp.mapping.select_prev_item(),
        ["<C-j>"] = cmp.mapping.select_next_item(),
        ["<C-n>"] = cmp.mapping.scroll_docs(4),
        ["<C-p>"] = cmp.mapping.scroll_docs(-4),

        -- If snippet, expand snippet or jump to next placeholder
        ["<Tab>"] = cmp.mapping(function(fallback)
          if luasnip.expand_or_locally_jumpable() then
            luasnip.expand_or_jump()
          else
            fallback()
          end
        end, { "i", "s" }),

        -- If snippet, jump to previous snippet placeholder
        ["<S-Tab>"] = cmp.mapping(function(fallback)
          if luasnip.jumpable(-1) then
            luasnip.jump(-1)
          else
            fallback() -- use default shift-tab behavior
          end
        end, { "i", "s" }),
      }),

      -- Use LuaSnip to expand snippets
      snippet = {
        expand = function(args)
          luasnip.lsp_expand(args.body)
        end,
      },

      sources = {
        { name = "codeium" }, -- AI powered
        { name = "luasnip" }, -- Snippets
        { name = "nvim_lsp" }, -- LSP completion
        { name = "buffer" }, -- Words from current buffer
        { name = "path" }, -- File paths
        { name = "nvim_lsp_signature_help" }, -- Fuction signatures
      },

      formatting = {
        format = lspkind.cmp_format({
          mode = "symbol_text", -- SHow bot hicon and text
          menu = {
            codeium = "", -- AI robot icon
            luasnip = "", -- Snippet icon
            buffer = "", -- File icon
            path = "", -- Folder icon
            nvim_lsp = "🅻", -- LSP badge
          },
        }),
      },
    })
  end,
}
