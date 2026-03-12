-- =============================================================================
-- FILE: lua/config/plugins/nvim-cmp.lua
-- Autocompletion. Keys (in menu): C-a=trigger, C-e=close, CR=confirm,
-- C-j/k=nav, C-n/p=scroll docs, Tab/S-Tab=snippet jump
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
        ["<C-a>"] = cmp.mapping.complete(),
        ["<C-e>"] = cmp.mapping.abort(),
        ["<CR>"] = cmp.mapping.confirm({ select = false }),
        ["<C-k>"] = cmp.mapping.select_prev_item(),
        ["<C-j>"] = cmp.mapping.select_next_item(),
        ["<C-n>"] = cmp.mapping.scroll_docs(4),
        ["<C-p>"] = cmp.mapping.scroll_docs(-4),
        ["<Tab>"] = cmp.mapping(function(fallback)
          if luasnip.expand_or_locally_jumpable() then luasnip.expand_or_jump()
          else fallback() end
        end, { "i", "s" }),
        ["<S-Tab>"] = cmp.mapping(function(fallback)
          if luasnip.jumpable(-1) then luasnip.jump(-1)
          else fallback() end
        end, { "i", "s" }),
      }),

      snippet = { expand = function(args) luasnip.lsp_expand(args.body) end },

      sources = {
        { name = "codeium" },
        { name = "luasnip" },
        { name = "nvim_lsp" },
        { name = "buffer" },
        { name = "path" },
        { name = "nvim_lsp_signature_help" },
      },

      formatting = {
        format = lspkind.cmp_format({
          mode = "symbol_text",
          menu = { codeium = "", luasnip = "", buffer = "", path = "", nvim_lsp = "🅻" },
        }),
      },
    })
  end,
}
