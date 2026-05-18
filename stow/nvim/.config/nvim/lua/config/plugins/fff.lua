return {
  "dmtrKovalenko/fff.nvim",
  build = function()
    -- downloads a prebuilt binary or falls back to cargo build
    require("fff.download").download_or_build_binary()
  end,
  -- for nixos:
  -- build = "nix run .#release",
  opts = {
    debug = {
      enabled = true,
      show_scores = true,
    },
  },
  lazy = false, -- the plugin lazy-initialises itself
  config = function()
    local builtin = require("fff")
    local keymap = vim.keymap

    keymap.set("n", "<leader>ff", builtin.find_files, { desc = "FFFind files" })

    keymap.set("n", "<leader>fc", function()
      builtin.find_files_in_dir("~/dotfiles")
    end, { desc = "FFFind Config Files" })

    keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "FFFind live grep" })

    keymap.set("n", "<leader>fw", function()
      builtin.live_grep({ query = vim.fn.expand("<cword>") })
    end, { desc = "FFFind current word" })
  end,
}
