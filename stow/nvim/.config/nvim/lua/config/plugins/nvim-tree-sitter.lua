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
-- Incremental node selection (built-in, visual mode):
--   an  : Select parent (outer) node — expand selection
--   in  : Select child (inner) node — shrink selection
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

      -- Enable treesitter highlighting for all buffers with an installed parser.
      -- Neovim 0.12 only auto-enables this for bundled languages (lua, markdown,
      -- help, query). For other languages (python, bash, yaml, etc.) we need to
      -- call vim.treesitter.start() ourselves.
      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("treesitter-start", { clear = true }),
        callback = function(ev)
          pcall(vim.treesitter.start, ev.buf)
        end,
      })
    end,
  },
}
