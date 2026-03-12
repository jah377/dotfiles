-- =============================================================================
-- FILE: lua/config/plugins/telescope.lua
--
-- PURPOSE:
--   Configures Telescope, a highly extendable fuzzy finder for Neovim. It
--   provides a unified interface for searching files, buffers, help docs,
--   git history, LSP symbols, and much more.
--
-- WHAT IS A FUZZY FINDER?
--   A fuzzy finder lets you type partial/approximate matches to quickly find
--   things. Instead of remembering exact file names, you type fragments:
--   "usrmod" might match "src/models/user_model.py"
--
-- COMMONLY USED KEYMAPS:
--   <leader>ff : Find files (all files in project)
--   <leader>fp : Find git files (respects .gitignore)
--   <leader>fb : Find open buffers
--   <leader>fh : Find help tags
--   <leader>fk : Find keymaps
--   <leader>fd : Find diagnostics
--   <leader>fr : Resume last search
--   <leader>fz : Fuzzy find in current buffer
--   <leader>fc : Find config files (dotfiles)
--
-- GREP KEYMAPS:
--   <leader>fgs : Grep string under cursor
--   <leader>fgd : Live grep in directory
--   <leader>fgo : Live grep in open files
--
-- WITHIN TELESCOPE:
--   <CR>   : Open selected item
--   <C-j>  : Move to next item
--   <C-k>  : Move to previous item
--   <Esc>  : Close Telescope
--   <C-c>  : Close Telescope (from insert mode)
--
-- DOCUMENTATION:
--   > GitHub : https://github.com/nvim-telescope/telescope.nvim
--   > :help telescope
--   > :help telescope.builtin
--
-- =============================================================================

return {
  -- Plugin identifier from GitHub
  "nvim-telescope/telescope.nvim",

  -- Load when Neovim finishes starting (VimEnter event).
  -- This ensures Telescope is ready for keymaps without delaying startup.
  event = "VimEnter",

  -- Pin to a specific version tag for stability.
  -- Check GitHub for newer versions periodically.
  tag = "0.1.8",

  -- Plugins that Telescope depends on
  dependencies = {
    -- plenary.nvim provides Lua utility functions used by many plugins
    "nvim-lua/plenary.nvim",

    -- Native FZF sorter for faster fuzzy matching (compiled C code)
    -- 'build = "make"' compiles the native extension during installation
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },

    -- Use Telescope for vim.ui.select() (code actions, etc.)
    -- Replaces the default ugly menu with Telescope's nice UI
    { "nvim-telescope/telescope-ui-select.nvim" },

    -- File icons in Telescope results (requires Nerd Font)
    -- Only enabled if have_nerd_font is true (set in globals.lua)
    { "nvim-tree/nvim-web-devicons", enabled = vim.g.have_nerd_font },
  },

  config = function()
    -- Configure Telescope
    -- Run :help telescope.setup() for all options
    require("telescope").setup({
      extensions = {
        -- Configure the ui-select extension to use dropdown theme
        -- This makes vim.ui.select() (like code actions) look nice
        ["ui-select"] = {
          require("telescope.themes").get_dropdown(),
        },
      },
    })

    -- Load extensions if they're installed.
    -- pcall = "protected call" - doesn't error if extension isn't available
    pcall(require("telescope").load_extension, "fzf")      -- Fast native sorting
    pcall(require("telescope").load_extension, "ui-select") -- Replace vim.ui.select

    -- Get references to telescope modules for creating keymaps
    local builtin = require("telescope.builtin")  -- Built-in pickers
    local actions = require("telescope.actions")  -- Actions like select, close
    local keymap = vim.keymap                     -- Keymap API

    -- Helper function: create a picker that opens results in vertical split.
    -- By default, Telescope opens in current window. This wrapper makes
    -- the default action open in a vertical split instead.
    local function open_vertical(picker_fn)
      return function()
        picker_fn({
          attach_mappings = function(_, map)
            -- Override Enter in both insert and normal mode
            -- to open selection in a vertical split
            map("i", "<CR>", actions.select_vertical)
            map("n", "<CR>", actions.select_vertical)
            return true  -- Keep all other default mappings
          end,
        })
      end
    end

    -- =========================================================================
    -- FINDER KEYMAPS
    -- =========================================================================

    -- Find help tags - opens help in vertical split so you can read while coding
    keymap.set("n", "<leader>fh", open_vertical(builtin.help_tags), { desc = "Find Help" })

    -- Find man pages - Unix manual pages
    keymap.set("n", "<leader>fm", open_vertical(builtin.man_pages), { desc = "Find Man-Pages" })

    -- Find keymaps - search all defined keymaps (great for discovery)
    keymap.set("n", "<leader>fk", builtin.keymaps, { desc = "Find Keymaps" })

    -- Find diagnostics - search LSP errors/warnings across project
    keymap.set("n", "<leader>fd", builtin.diagnostics, { desc = "Find Diagnostics" })

    -- Find buffers - switch between open files
    keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Find Buffers" })

    -- Find git files - files tracked by git (respects .gitignore)
    keymap.set("n", "<leader>fp", builtin.git_files, { desc = "Find Git Files" })

    -- Find Treesitter objects - functions, classes, variables in current file
    keymap.set("n", "<leader>ft", builtin.treesitter, { desc = "Find Treesitter Objects" })

    -- Resume - reopen the last Telescope picker with same results
    keymap.set("n", "<leader>fr", builtin.resume, { desc = "Resume Search" })

    -- Fuzzy find in current buffer - search within the current file
    keymap.set("n", "<leader>fz", builtin.current_buffer_fuzzy_find, { desc = "Fuzzy Find in Buffer" })

    -- =========================================================================
    -- FILE FINDING KEYMAPS
    -- =========================================================================

    -- Find all files including hidden (dotfiles), but respecting .gitignore
    keymap.set("n", "<leader>ff", function()
      builtin.find_files({ hidden = true })
    end, { desc = "Find All Files" })

    -- Find config files - specifically in the dotfiles directory
    keymap.set("n", "<leader>fc", function()
      builtin.find_files({ cwd = "~/dotfiles/", hidden = true })
    end, { desc = "Find Config Files" })

    -- Find lazy.nvim plugin files - useful for reading plugin source code
    keymap.set("n", "<space>fL", function()
      -- stdpath("data") is ~/.local/share/nvim
      -- lazy.nvim stores plugins in ~/.local/share/nvim/lazy/
      builtin.find_files({ cwd = vim.fs.joinpath(vim.fn.stdpath("data"), "lazy") })
    end, { desc = "Find Lazyvim Files" })

    -- =========================================================================
    -- GREP KEYMAPS
    -- =========================================================================
    -- Grep searches file CONTENTS (unlike find_files which searches names)

    -- Grep string under cursor - search for the word under cursor
    keymap.set("n", "<leader>fgs", builtin.grep_string, { desc = "Grep: Strings" })

    -- Live grep in directory - interactive search across all project files
    keymap.set("n", "<leader>fgd", function()
      builtin.live_grep({ grep_open_files = false, prompt_title = "Live Grep in Directory" })
    end, { desc = "Grep: Directory Files" })

    -- Live grep in open files - search only in currently open buffers
    keymap.set("n", "<leader>fgo", function()
      builtin.live_grep({ grep_open_files = true, prompt_title = "Live Grep in Open Files" })
    end, { desc = "Grep: Open Files" })
  end,
}
