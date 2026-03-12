-- =============================================================================
-- FILE: lua/config/plugins/nvim-tree-sitter.lua
--
-- PURPOSE:
--   Configures nvim-treesitter, which provides advanced syntax highlighting,
--   code navigation, and text objects based on actual code structure rather
--   than just regular expressions.
--
-- WHAT IS TREESITTER?
--   Treesitter is a parsing library that builds a concrete syntax tree (CST)
--   of your code. Unlike regex-based highlighting, Treesitter understands
--   the actual structure of your code:
--   - It knows a word is a function name vs a variable vs a keyword
--   - It can identify code blocks, parameters, and scopes
--   - It works consistently across different file positions
--
-- WHY USE TREESITTER?
--   - Better syntax highlighting (more accurate colors for different elements)
--   - Incremental selection (expand selection to larger code structures)
--   - Smart indentation (knows code structure, not just previous line)
--   - Foundation for other plugins (textobjects, refactoring, etc.)
--
-- USEFUL COMMANDS:
--   :checkhealth nvim-treesitter  - Verify installation and parsers
--   :Inspect                       - Show highlight groups at cursor
--   :InspectTree                   - Show syntax tree at cursor
--   :TSUpdate                      - Update all parsers
--   :TSInstall <lang>              - Install a specific parser
--
-- DOCUMENTATION:
--   > GitHub : https://github.com/nvim-treesitter/nvim-treesitter
--
-- TUTORIALS:
--   > TJ DeVries   : https://youtu.be/MpnjYb-t12A?si=IF_lYH1fR62-bnwd
--   > Rad Lectures : https://www.youtube.com/watch?v=cdAMq2KcF4w&t=3324s
--
-- =============================================================================

return {
  {
    -- Plugin identifier from GitHub
    "nvim-treesitter/nvim-treesitter",

    -- Load when opening any file (BufReadPre = existing file, BufNewFile = new file)
    event = { "BufReadPre", "BufNewFile" },

    -- After installing or updating, run :TSUpdate to compile parsers.
    -- Parsers are compiled C code that must match your Neovim version.
    build = ":TSUpdate",

    config = function()
      -- Suppress a diagnostic warning about missing fields.
      -- This is a known issue with the type definitions.
      ---@diagnostic disable-next-line: missing-fields
      require("nvim-treesitter.configs").setup({

        -- List of parsers to install automatically.
        -- These cover the most common file types you'll encounter.
        -- Add more as needed (run :TSInstall <language> to add interactively).
        ensure_installed = {
          "lua",             -- Neovim config files
          "vim",             -- Vim script (legacy configs)
          "vimdoc",          -- Vim help files
          "query",           -- Treesitter query files
          "markdown",        -- Markdown documents
          "dockerfile",      -- Docker configuration
          "bash",            -- Shell scripts
          "json",            -- JSON data files
          "markdown_inline", -- Inline markdown (code blocks, etc.)
          "python",          -- Python code
          "yaml",            -- YAML config files
          "toml",            -- TOML config files (pyproject.toml, etc.)
          "comment",         -- Comment highlighting (TODO, FIXME, etc.)
          "regex",           -- Regular expressions
        },

        -- Don't install parsers synchronously (would block startup).
        -- Parsers install in the background.
        sync_install = false,

        -- Don't automatically install parsers for file types not in the list.
        -- This prevents unexpected downloads and ensures consistency.
        auto_install = false,

        -- No parsers to explicitly ignore (empty list).
        ignore_install = {},

        -- Enable Treesitter-based indentation.
        -- More accurate than Vim's default regex-based indentation.
        indent = { enable = true },

        -- Configure syntax highlighting
        highlight = {
          -- Enable Treesitter highlighting
          enable = true,

          -- Don't use Vim's regex highlighting alongside Treesitter.
          -- Having both can cause duplicate or conflicting highlights.
          additional_vim_regex_highlighting = false,

          -- Disable highlighting for files larger than 100KB.
          -- Treesitter can be slow on very large files; this prevents lag.
          disable = function(lang, buf)
            local max_filesize = 100 * 1024 -- 100 KB
            -- Get file stats to check size
            local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
            if ok and stats and stats.size > max_filesize then
              return true  -- Disable highlighting for this buffer
            end
          end,
        },

        -- Configure incremental selection (expand/shrink selection by syntax)
        incremental_selection = {
          enable = true,
          keymaps = {
            -- Start selection and expand to larger node (Alt+=)
            -- Press repeatedly to select larger and larger code structures:
            -- variable -> expression -> statement -> block -> function
            init_selection = "<M-=>",
            node_incremental = "<M-=>",

            -- Don't use scope-based expansion (would skip structure levels)
            scope_incremental = false,

            -- Shrink selection to smaller node (Backspace)
            node_decremental = "<BS>",
          },
        },
      })

      -- Register the bash parser for zsh files.
      -- Zsh syntax is close enough to bash that the bash parser works well.
      -- Without this, .zsh files would have no Treesitter highlighting.
      vim.treesitter.language.register("bash", "zsh")
    end,
  },
}
