-- =============================================================================
-- FILE: lua/config/plugins/nvim-tree-sitter.lua
-- Advanced syntax highlighting, code nvigation, and text objects
--
-- USEFUL COMMANDS:
--  > :checkhealth nim-treesitter   : Verify installation and parsers
--  > :Inspect                     : Show highligth groups at cursor
--  > :TSUPdate                     : Update all parsers
--  > :TSInstall <lang>             : Install specific parser
--
-- Incremental selection: M-= (expand), BS (shrink)
-- =============================================================================

return {
  {
    "nvim-treesitter/nvim-treesitter",
    event = { "BufReadPre", "BufNewFile" },
    build = ":TSUpdate",

    config = function()
      -- Suppress diagnostic warning about missing fields. Known issue.
      ---@diagnostic disable-next-line: missing-fields
      require("nvim-treesitter.configs").setup({
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

        ignore_install = {},

        -- Treesitter-based indention more accurate than default regex-based
        indent = { enable = true },

        highlight = {
          enable = true,

          -- Disable to prevent conflicting/conflicting highlights
          additional_vim_regex_highlighting = false,
        },

        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = "<M-=>",
            node_incremental = "<M-=>",
            scope_incremental = false,
            node_decremental = "<BS>",
          },
        },
      })

      -- Use bash parser for zsh files
      vim.treesitter.language.register("bash", "zsh")
    end,
  },
}
