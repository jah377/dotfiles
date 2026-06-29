-- =============================================================================
-- FILE: lua/config/plugins/fuzzy_finding.lua
-- Fuzzy finder and file search.
--
-- telescope.nvim and fff.nvim are declared as independent specs so that
-- telescope fully initialises before fff patches its picker internals.
--
-- DOCUMENTATION:
--  > Github : https://github.com/nvim-telescope/telescope.nvim
--  > Github : https://github.com/dmtrKovalenko/fff.nvim
--  > :help telescope
--  > :help telescope.builtin
-- =============================================================================

-- ---------------------------------------------------------------------------
-- Telescope
-- ---------------------------------------------------------------------------
local telescope_spec = {
  "nvim-telescope/telescope.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    { "nvim-telescope/telescope-ui-select.nvim" },
    { "nvim-tree/nvim-web-devicons", enabled = vim.g.have_nerd_font },
    { "crispgm/telescope-heading.nvim" },
  },
  event = "VimEnter",
  config = function()
    require("telescope").setup({
      extensions = { ["ui-select"] = { require("telescope.themes").get_dropdown() } },
    })

    pcall(require("telescope").load_extension, "fzf")
    pcall(require("telescope").load_extension, "ui-select")
    pcall(require("telescope").load_extension, "heading")

    local builtin = require("telescope.builtin")
    local keymap = vim.keymap

    -- Helper: wraps a picker so <CR> opens in a vertical split
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
    keymap.set("n", "<leader>ft", builtin.treesitter, { desc = "Find Treesitter Objects" })
    keymap.set("n", "<leader>fr", builtin.resume, { desc = "Resume Search" })
    keymap.set("n", "<leader>fz", builtin.current_buffer_fuzzy_find, { desc = "Fuzzy Find in Buffer" })
    keymap.set("n", "<space>fL", function()
      builtin.find_files({ cwd = vim.fs.joinpath(vim.fn.stdpath("data"), "lazy") })
    end, { desc = "Find Lazy Plugin Files" })
    keymap.set("n", "<leader>fF", function()
      builtin.find_files({ no_ignore = true, hidden = true })
    end, { desc = "Find All Files (incl. ignored)" })
    keymap.set("n", "<leader>mh", "<cmd>Telescope heading<CR>", { desc = "[M]arkdown [H]eadings" })
  end,
}

-- ---------------------------------------------------------------------------
-- fff.nvim
-- ---------------------------------------------------------------------------
local fff_spec = {
  "dmtrKovalenko/fff.nvim",
  dependencies = { "nvim-telescope/telescope.nvim" },
  build = function()
    require("fff.download").download_or_build_binary()
  end,
  lazy = false,
  opts = {
    debug = { enabled = true, show_scores = true },
  },
  config = function(_, opts)
    local fff = require("fff")
    fff.setup(opts)

    local keymap = vim.keymap
    keymap.set("n", "<leader>ff", fff.find_files, { desc = "FFFind files" })
    keymap.set("n", "<leader>fc", function()
      fff.find_files_in_dir("~/dotfiles")
    end, { desc = "FFFind Config Files" })
    keymap.set("n", "<leader>fg", fff.live_grep, { desc = "FFFind live grep" })
    keymap.set("n", "<leader>fw", function()
      fff.live_grep({ query = vim.fn.expand("<cword>") })
    end, { desc = "FFFind current word" })
  end,
}

return { telescope_spec, fff_spec }
