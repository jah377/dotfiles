-- [[ 99.nvim: AI-assisted coding plugin ]]

-- 99 is an AI-assisted coding plugin for Neovim. It provides tools to send
-- visual selections to an AI provider (e.g. ClaudeCode) and stream
-- responses back inline. This config sets up the provider, debug logging,
-- and keymaps for interacting with the plugin. See
-- https://github.com/ThePrimeagen/99/

return {
  "ThePrimeagen/99",
  config = function()
    local _99 = require("99")
    local cwd = vim.uv.cwd()
    local basename = vim.fs.basename(cwd)
    local kbd = vim.keymap

    _99.setup({
      -- Setup claude code
      provider = _99.Providers.ClaudeCodeProvider,
      model = "claude-haiku-4-5",

      -- Setup logger
      logger = {
        level = _99.DEBUG,
        path = "/tmp/" .. basename .. ".99.debug",
        print_on_error = true,
      },

      --- Completions: #rules and @files in the prompt buffer
      completion = {
        -- I am going to disable these until i understand the
        -- problem better.  Inside of cursor rules there is also
        -- application rules, which means i need to apply these
        -- differently
        -- cursor_rules = "<custom path to cursor rules>"

        --- A list of folders where you have your own SKILL.md
        --- Expected format:
        --- /path/to/dir/<skill_name>/SKILL.md
        ---
        --- Example:
        --- Input Path:
        --- "scratch/custom_rules/"
        ---
        --- Output Rules:
        --- {path = "scratch/custom_rules/vim/SKILL.md", name = "vim"},
        --- ... the other rules in that dir ...
        ---
        custom_rules = {
          "~/dotfiles/.cursor/skills/",
        },

        --- Configure @file completion (all fields optional, sensible defaults)
        files = {
          -- enabled = true,
          -- max_file_size = 102400,     -- bytes, skip files larger than this
          -- max_files = 5000,            -- cap on total discovered files
          -- exclude = { ".env", ".env.*", "node_modules", ".git", ... },
        },

        --- What autocomplete do you use.  We currently only
        --- support cmp right now
        source = "cmp",
      },

      --- WARNING: if you change cwd then this is likely broken
      --- ill likely fix this in a later change
      ---
      --- md_files is a list of files to look for and auto add based on the location
      --- of the originating request.  That means if you are at /foo/bar/baz.lua
      --- the system will automagically look for:
      --- /foo/bar/AGENT.md
      --- /foo/AGENT.md
      --- assuming that /foo is project root (based on cwd)
      md_files = {
        "AGENT.md",
      },
    })

    kbd.set("v", "<leader>9v", function()
      _99.visual()
    end, { desc = "Send [V]isual selection to 99" })

    kbd.set("v", "<leader>9s", function()
      _99.stop_all_requests()
    end, { desc = "[S]top all 99 requests" })

    kbd.set("n", "<leader>9m", function()
      require("99.extensions.telescope").select_model()
    end, { desc = "Select [M]odel" })

    kbd.set("n", "<leader>9p", function()
      require("99.extensions.telescope").select_provider()
    end, { desc = "Select [P]rovider" })
  end,
}
