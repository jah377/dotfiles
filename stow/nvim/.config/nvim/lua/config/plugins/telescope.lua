return {
  "nvim-telescope/telescope.nvim",
  event = "VimEnter",
  tag = "0.1.8",
  dependencies = {
    "nvim-lua/plenary.nvim",
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    { "nvim-telescope/telescope-ui-select.nvim" },
    -- Useful for getting pretty icons, but requires a Nerd Font.
    { "nvim-tree/nvim-web-devicons", enabled = vim.g.have_nerd_font },
  },
  config = function()
    -- See `:help telescope` and `:help telescope.setup()`
    require("telescope").setup({
      extensions = {
        ["ui-select"] = {
          require("telescope.themes").get_dropdown(),
        },
      },
    })

    -- Enable Telescope extensions if they are installed
    pcall(require("telescope").load_extension, "fzf")
    pcall(require("telescope").load_extension, "ui-select")

    -- See `:help telescope.builtin`
    local builtin = require("telescope.builtin")
    local actions = require("telescope.actions")
    local keymap = vim.keymap

    -- Helper to open new buffer with vertical split
    local function open_vertical(picker_fn)
      return function()
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

    -- Search files, including hidden
    keymap.set("n", "<leader>ff", function()
      builtin.find_files({ hidden = true })
    end, { desc = "Find All Files" })

    keymap.set("n", "<leader>fc", function()
      builtin.find_files({ cwd = "~/dotfiles/", hidden = true })
    end, { desc = "Find Config Files" })

    -- Search lazy package files
    keymap.set("n", "<space>fL", function()
      builtin.find_files({ cwd = vim.fs.joinpath(vim.fn.stdpath("data"), "lazy") })
    end, { desc = "Find Lazyvim Files" })

    -- Search using grep
    keymap.set("n", "<leader>fgs", builtin.grep_string, { desc = "Grep: Strings" })
    keymap.set("n", "<leader>fgd", function()
      builtin.live_grep({ grep_open_files = false, prompt_title = "Live Grep in Directory" })
    end, { desc = "Grep: Directory Files" })
    keymap.set("n", "<leader>fgo", function()
      builtin.live_grep({ grep_open_files = true, prompt_title = "Live Grep in Open Files" })
    end, { desc = "Grep: Open Files" })
  end,
}
