-- =============================================================================
-- FILE: lua/config/plugins/nvim-tree-sitter.lua
-- Parser installation and management (highlighting/indent are built-in 0.12+)
--
-- USEFUL COMMANDS:
--  > :checkhealth nvim-treesitter   : Verify installation and parsers
--  > :Inspect                       : Show highlight groups at cursor
--  > :TSUpdate                      : Update all parsers
--  > :TSInstall <lang>              : Install specific parser
--
-- Incremental selection: M-= (expand), BS (shrink)
-- =============================================================================

return {
  {
    "nvim-treesitter/nvim-treesitter",
    event = { "BufReadPre", "BufNewFile" },
    branch = "main",
    build = ":TSUpdate",

    config = function()
      require("nvim-treesitter").setup({
        ensure_installed = {
          "lua",
          "vim",
          "vimdoc",
          "query",
          "markdown",
          "dockerfile",
          "bash",
          "json",
          "markdown_inline",
          "python",
          "yaml",
          "toml",
          "comment",
          "regex",
        },

        -- Don't install parsers synchronously (would block startup)
        sync_install = false,

        -- Prevent unexpected downloads for file types not in list
        auto_install = false,
      })

      -- Use bash parser for zsh files
      vim.treesitter.language.register("bash", "zsh")

      -- Incremental selection keymaps (replaces removed incremental_selection module)
      vim.keymap.set("n", "<M-=>", function()
        vim.treesitter.incremental_selection.init()
      end, { desc = "Start treesitter incremental selection" })
      vim.keymap.set("x", "<M-=>", function()
        vim.treesitter.incremental_selection.node_incremental()
      end, { desc = "Expand treesitter selection" })
      vim.keymap.set("x", "<BS>", function()
        vim.treesitter.incremental_selection.node_decremental()
      end, { desc = "Shrink treesitter selection" })
    end,
  },
}
