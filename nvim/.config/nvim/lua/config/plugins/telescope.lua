return {
  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.8",
    dependencies = {
      "nvim-lua/plenary.nvim",
      -- Use `fzf` for faster fuzzy finding
      -- Must include `require("telescope").load_extension("fzf")` to use
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" }
    },
    config = function()
      require("telescope").load_extension("fzf")

      -- Find help documentation
      vim.keymap.set("n", "<space>fh", require("telescope.builtin").help_tags)

      -- Find files in current directory
      vim.keymap.set("n", "<space>fd", require("telescope.builtin").find_files)

      -- Find config files
      vim.keymap.set("n", "<space>fn", function()
        require("telescope.builtin").find_files {
          cwd = vim.fn.stdpath("config")
        }
      end)

      -- Find plugin package files
      vim.keymap.set("n", "<space>fp", function()
        require("telescope.builtin").find_files {
          cwd = vim.fs.joinpath(vim.fn.stdpath("data"), "lazy")
        }
      end)

      -- Find open buffers
      vim.keymap.set("n", "<space>fb", function()
        require("telescope.builtin").buffers {
          sort_mru = true, ignore_current_buffer = true
        }
      end)
    end
  }
}
