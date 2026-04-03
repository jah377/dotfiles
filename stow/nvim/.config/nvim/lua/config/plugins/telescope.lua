-- =============================================================================
-- FILE: lua/config/plugins/telescope.lua
-- Fuzzy finder.
--
-- DOCUMENTATION:
--  > Github : https://github.com/nvim-telescope/telescope.nvim
--  > :help telescope
--  > :help telescope.builtin
-- =============================================================================

return {
  "nvim-telescope/telescope.nvim",
  event = "VimEnter", -- load after starting
  -- tag = "0.2.*", -- for stability
  dependencies = {
    -- Lua utility functions (frequently used by plugins)
    "nvim-lua/plenary.nvim",

    -- Native FZF sorter for faster fuzzy matching (must compile during install)
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },

    -- Replace ugly default for vim.ui.select()
    { "nvim-telescope/telescope-ui-select.nvim" },

    -- Include file-icons in Telescope if Nerd Font used (see globals.lua)
    { "nvim-tree/nvim-web-devicons", enabled = vim.g.have_nerd_font },

    -- Jump to markdown headings via Telescope picker
    -- https://github.com/crispgm/telescope-heading.nvim
    { "crispgm/telescope-heading.nvim" },
  },

  config = function()
    -- Display ui-select as a dropdown menu theme
    require("telescope").setup({
      extensions = { ["ui-select"] = { require("telescope.themes").get_dropdown() } },
    })

    -- Load extensions (without error) if installed
    pcall(require("telescope").load_extension, "fzf")
    pcall(require("telescope").load_extension, "ui-select")
    pcall(require("telescope").load_extension, "heading")

    local builtin = require("telescope.builtin")
    local keymap = vim.keymap

    -- Helper function creates picker to open file to right
    local function open_vertical(picker_fn)
      return function()
        local actions = require("telescope.actions")
        picker_fn({
          attach_mappings = function(_, map)
            map("i", "<CR>", actions.select_vertical)
            map("n", "<CR>", actions.select_vertical)
            return true
          end,
        })
      end
    end

    keymap.set("n", "<leader>fh", open_vertical(builtin.help_tags), { desc = "Find Help" })
    keymap.set("n", "<leader>fm", open_vertical(builtin.man_pages), { desc = "Find Man-Pages" })
    keymap.set("n", "<leader>fk", builtin.keymaps, { desc = "Find Keymaps" })
    keymap.set("n", "<leader>fd", builtin.diagnostics, { desc = "Find Diagnostics" })
    keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Find Buffers" })
    keymap.set("n", "<leader>fp", builtin.git_files, { desc = "Find Git Files" })
    keymap.set("n", "<leader>ft", builtin.treesitter, { desc = "Find Treesitter Objects" })
    keymap.set("n", "<leader>fr", builtin.resume, { desc = "Resume Search" })
    keymap.set("n", "<leader>fz", builtin.current_buffer_fuzzy_find, { desc = "Fuzzy Find in Buffer" })
    keymap.set("n", "<leader>ff", function()
      builtin.find_files({ hidden = true })
    end, { desc = "Find All Files" })
    keymap.set("n", "<leader>fc", function()
      builtin.find_files({ cwd = "~/dotfiles/", hidden = true })
    end, { desc = "Find Config Files" })
    keymap.set("n", "<space>fL", function()
      builtin.find_files({ cwd = vim.fs.joinpath(vim.fn.stdpath("data"), "lazy") })
    end, { desc = "Find Lazy Plugin Files" })

    -- Markdown navigation (telescope-heading)
    keymap.set("n", "<leader>mh", "<cmd>Telescope heading<CR>", { desc = "[M]arkdown [H]eadings" })

    -- NOTE: Grep-related functions requires `ripgrep` (see brew.sh)
    keymap.set("n", "<leader>fgs", builtin.grep_string, { desc = "Grep: Strings" })
    keymap.set("n", "<leader>fgd", function()
      builtin.live_grep({ grep_open_files = false, prompt_title = "Live Grep in Directory" })
    end, { desc = "Grep: Directory Files" })
    keymap.set("n", "<leader>fgo", function()
      builtin.live_grep({ grep_open_files = true, prompt_title = "Live Grep in Open Files" })
    end, { desc = "Grep: Open Files" })
  end,
}
