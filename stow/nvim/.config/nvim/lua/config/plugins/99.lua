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
      provider = _99.Providers.ClaudeCodeProvider, -- default: OpenCodeProvider
      model = "claude-haiku-4-5",
      logger = {
        level = _99.DEBUG,
        path = "/tmp/" .. basename .. ".99.debug",
        print_on_error = true,
      },
    })

    -- Keymaps

    kbd.set("v", "<leader>9v", function()
      _99.visual()
    end, { desc = "Send visual selection to 99" })

    kbd.set("v", "<leader>9s", function()
      _99.stop_all_requests()
    end, { desc = "Stop all 99 requests" })
  end,
}
