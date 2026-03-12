-- =============================================================================
-- FILE: lua/config/plugins/99.lua
--
-- PURPOSE:
--   Configures 99.nvim, an AI-assisted coding plugin by ThePrimeagen. It
--   allows you to send code selections to an AI provider (Claude Code) and
--   stream responses back inline in your editor.
--
-- HOW IT WORKS:
--   1. Select code in visual mode
--   2. Press <leader>9v to send selection to AI
--   3. A prompt buffer opens where you can add instructions
--   4. AI response streams back into your code
--
-- FEATURES:
--   - Integration with Claude Code AI
--   - Custom rules and context via SKILL.md files
--   - File completion (@file) in prompts
--   - Rule completion (#rule) in prompts
--   - Auto-discovery of AGENT.md files for context
--
-- KEYMAPS:
--   <leader>9v : Send visual selection to AI
--   <leader>9s : Stop all AI requests
--   <leader>9m : Select AI model
--   <leader>9p : Select AI provider
--
-- DOCUMENTATION:
--   > GitHub : https://github.com/ThePrimeagen/99/
--
-- =============================================================================

return {
  -- Plugin identifier from GitHub
  "ThePrimeagen/99",

  config = function()
    -- Load the 99 module
    local _99 = require("99")

    -- Get the current working directory name for the log file
    local cwd = vim.uv.cwd()                 -- Current directory path
    local basename = vim.fs.basename(cwd)    -- Just the directory name

    -- Shorthand for keymap API
    local kbd = vim.keymap

    -- Initialize 99.nvim
    _99.setup({
      -- Use Claude Code as the AI provider.
      -- This uses the Claude Code CLI rather than direct API calls.
      provider = _99.Providers.ClaudeCodeProvider,

      -- Default model to use for AI requests.
      -- claude-haiku-4-5 is fast and cost-effective for coding tasks.
      model = "claude-haiku-4-5",

      -- Configure debug logging.
      -- Logs help diagnose issues with AI requests.
      logger = {
        level = _99.DEBUG,                              -- Log level (DEBUG is verbose)
        path = "/tmp/" .. basename .. ".99.debug",      -- Log file location
        print_on_error = true,                          -- Print errors to Neovim messages
      },

      -- Configure completion sources for the prompt buffer.
      -- When writing prompts, you can complete #rules and @files.
      completion = {
        -- Custom rules directories containing SKILL.md files.
        -- Rules provide context and instructions to the AI.
        -- Format: /path/to/dir/<skill_name>/SKILL.md
        custom_rules = {
          "~/dotfiles/.cursor/skills/",  -- Personal skill definitions
        },

        -- @file completion configuration.
        -- Allows referencing project files in AI prompts.
        files = {
          -- enabled = true,
          -- max_file_size = 102400,     -- Skip files larger than 100KB
          -- max_files = 5000,           -- Maximum files to index
          -- exclude = { ".env", "node_modules", ".git", ... },
        },

        -- Integration with nvim-cmp for completions
        source = "cmp",
      },

      -- Auto-discovery of context files.
      -- 99.nvim looks for these files in parent directories and
      -- automatically includes them as context for AI requests.
      -- Example: If editing /foo/bar/baz.lua, it looks for:
      --   /foo/bar/AGENT.md
      --   /foo/AGENT.md
      md_files = {
        "AGENT.md",  -- Project-level AI instructions
      },
    })

    -- Keymap: Send visual selection to AI for processing
    kbd.set("v", "<leader>9v", function()
      _99.visual()
    end, { desc = "Send [V]isual selection to 99" })

    -- Keymap: Stop all running AI requests
    -- Useful if an AI response is taking too long or going wrong
    kbd.set("v", "<leader>9s", function()
      _99.stop_all_requests()
    end, { desc = "[S]top all 99 requests" })

    -- Keymap: Open Telescope picker to select AI model
    kbd.set("n", "<leader>9m", function()
      require("99.extensions.telescope").select_model()
    end, { desc = "Select [M]odel" })

    -- Keymap: Open Telescope picker to select AI provider
    kbd.set("n", "<leader>9p", function()
      require("99.extensions.telescope").select_provider()
    end, { desc = "Select [P]rovider" })
  end,
}
