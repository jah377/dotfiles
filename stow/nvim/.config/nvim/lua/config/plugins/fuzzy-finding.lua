-- =============================================================================
-- FILE: lua/config/plugins/fuzzy_finding.lua
-- Fuzzy finder and file search.
--
-- fff.nvim is the entry point; telescope.nvim is declared as a dependency so
-- both plugins load together and share a single config function.
--
-- DOCUMENTATION:
--  > Github : https://github.com/nvim-telescope/telescope.nvim
--  > Github : https://github.com/dmtrKovalenko/fff.nvim
--  > :help telescope
--  > :help telescope.builtin
-- =============================================================================

return {
  "dmtrKovalenko/fff.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim", -- required by telescope
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" }, -- faster fuzzy sorting via native FZF
    { "nvim-telescope/telescope-ui-select.nvim" }, -- replaces vim.ui.select() with telescope dropdown
    { "nvim-tree/nvim-web-devicons", enabled = vim.g.have_nerd_font }, -- file icons (requires Nerd Font)
    { "crispgm/telescope-heading.nvim" }, -- jump to markdown headings
    "nvim-telescope/telescope.nvim", -- listed last so its deps resolve first
  },
  build = function()
    -- downloads a prebuilt binary or falls back to cargo build
    require("fff.download").download_or_build_binary()
  end,
  -- for nixos:
  -- build = "nix run .#release",
  event = "VimEnter",
  lazy = false, -- fff self-manages its lazy initialisation internally
  opts = {
    debug = { enabled = true, show_scores = true },
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

    local telescope = require("telescope.builtin")
    local fff = require("fff")
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

    -- Telescope keymaps
    keymap.set("n", "<leader>fh", open_vertical(telescope.help_tags), { desc = "Find Help" })
    keymap.set("n", "<leader>fm", open_vertical(telescope.man_pages), { desc = "Find Man-Pages" })
    keymap.set("n", "<leader>fk", telescope.keymaps, { desc = "Find Keymaps" })
    keymap.set("n", "<leader>fd", telescope.diagnostics, { desc = "Find Diagnostics" })
    keymap.set("n", "<leader>fb", telescope.buffers, { desc = "Find Buffers" })
    keymap.set("n", "<leader>ft", telescope.treesitter, { desc = "Find Treesitter Objects" })
    keymap.set("n", "<leader>fr", telescope.resume, { desc = "Resume Search" })
    keymap.set("n", "<leader>fz", telescope.current_buffer_fuzzy_find, { desc = "Fuzzy Find in Buffer" })
    keymap.set("n", "<space>fL", function()
      telescope.find_files({ cwd = vim.fs.joinpath(vim.fn.stdpath("data"), "lazy") })
    end, { desc = "Find Lazy Plugin Files" })
    keymap.set("n", "<leader>mh", "<cmd>Telescope heading<CR>", { desc = "[M]arkdown [H]eadings" })

    -- fff keymaps
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
