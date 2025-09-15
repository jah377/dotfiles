-- `:Inspect` to view applied highlights of object at point
-- `:InspectTree` to view tree of object at point

return {
  {
    "nvim-treesitter/nvim-treesitter",
    event = { "BufReadPre", "BufNewFile" },
    build = ":TSUpdate",
    config = function()
      ---@diagnostic disable-next-line: missing-fields
      require("nvim-treesitter.configs").setup({
        ensure_installed = {
          "lua",
          "vim",
          "vimdoc",
          "query",
          "markdown",
          "markdown_inline",
          "python",
        },

        -- Install `ensure_installed` parsers synchronously
        sync_install = false, -- install asynch

        -- Automatically install missing parsers when entering buffer
        auto_install = false, -- only install parsers in `ensure_installed`

        -- List of parsers to ignore installing
        ignore_install = {},

        indent = { enable = true },
        highlight = {
          enable = true,

          -- If true, may duplicate highlights
          additional_vim_regex_highlighting = false,

          -- Disable slow highlighting for larger files
          disable = function(lang, buf)
            local max_filesize = 100 * 1024 -- 100 KB
            local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
            if ok and stats and stats.size > max_filesize then
              return true
            end
          end,
        },
        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = "<C-=>",
            node_incremental = "<C-=>",
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
