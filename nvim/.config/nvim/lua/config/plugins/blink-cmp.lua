return {
  "saghen/blink.cmp",
  -- Snippets in ~/.local/share/nvim/lazy/friendly-snippets/snippets
  dependencies = { "rafamadriz/friendly-snippets" },
  version = "1.*", -- use stable release
  event = { "LspAttach" },

  ---@module 'blink.cmp'
  ---@type blink.cmp.Config
  opts = {
    appearance = { nerd_font_variant = "mono" },
    fuzzy = { implementation = "prefer_rust_with_warning" },
    completion = { documentation = { auto_show = false } },

    -- From https://github.com/folke/lazydev.nvim
    sources = {
      default = { "lazydev", "lsp", "path", "snippets", "buffer" },
      providers = {
        lazydev = {
          name = "LazyDev",
          module = "lazydev.integrations.blink",
          score_offest = 100, -- lazydev completion top priority
        },
      },
    },

    -- See :h blink-cmp-config-keymap for defining your own keymap
    keymap = {
      preset = "none",

      ["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
      ["<C-e>"] = { "hide", "fallback" },
      ["<C-y>"] = { "select_and_accept", "fallback" },
      ["<Up>"] = { "select_prev", "fallback" },
      ["<Down>"] = { "select_next", "fallback" },
      ["<C-p>"] = { "select_prev", "fallback_to_mappings" },
      ["<C-n>"] = { "select_next", "fallback_to_mappings" },
      ["<C-b>"] = { "scroll_documentation_up", "fallback" },
      ["<C-f>"] = { "scroll_documentation_down", "fallback" },
      ["<Tab>"] = { "snippet_forward", "fallback" },
      ["<S-Tab>"] = { "snippet_backward", "fallback" },
      ["<C-k>"] = { "show_signature", "hide_signature", "fallback" },
    },
  },
  -- From https://cmp.saghen.dev/installation.html#lazy-nvim
  opts_extend = { "sources.default" },
}
