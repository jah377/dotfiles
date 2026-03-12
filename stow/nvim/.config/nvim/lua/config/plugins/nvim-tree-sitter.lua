-- =============================================================================
-- FILE: lua/config/plugins/nvim-tree-sitter.lua
-- Syntax highlighting and code parsing. Commands: :TSUpdate, :TSInstall <lang>
-- Incremental selection: M-= (expand), BS (shrink)
-- =============================================================================

return {
  {
    "nvim-treesitter/nvim-treesitter",
    event = { "BufReadPre", "BufNewFile" },
    build = ":TSUpdate",

    config = function()
      ---@diagnostic disable-next-line: missing-fields
      require("nvim-treesitter.configs").setup({
        ensure_installed = {
          "lua", "vim", "vimdoc", "query", "markdown", "dockerfile",
          "bash", "json", "markdown_inline", "python", "yaml", "toml",
          "comment", "regex",
        },
        sync_install = false,
        auto_install = false,
        ignore_install = {},
        indent = { enable = true },

        highlight = {
          enable = true,
          additional_vim_regex_highlighting = false,
          -- Disable for large files (>100KB)
          disable = function(lang, buf)
            local max_filesize = 100 * 1024
            local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
            if ok and stats and stats.size > max_filesize then return true end
          end,
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
