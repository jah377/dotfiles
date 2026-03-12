-- =============================================================================
-- FILE: lua/config/lsp/diagnostics.lua
--
-- PURPOSE:
--   This file configures how LSP diagnostics (errors, warnings, hints) are
--   displayed in Neovim. Diagnostics are messages from language servers that
--   indicate problems with your code.
--
--   Configuration includes:
--   - How diagnostic messages appear (underlines, virtual text, signs)
--   - Which severity levels to show
--   - Icons/symbols used in the sign column
--   - Workarounds for LSP edge cases
--
-- WHAT ARE LSP DIAGNOSTICS?
--   When you open a code file, Neovim connects to a "language server" (like
--   pyright for Python or lua_ls for Lua). The server analyzes your code and
--   sends back diagnostic messages about:
--   - Errors (code won't run)
--   - Warnings (code might have issues)
--   - Hints (suggestions for improvement)
--   - Info (additional information)
--
-- DOCUMENTATION:
--   > :help vim.diagnostic     : Neovim diagnostic system
--   > :help vim.diagnostic.Opts: Configuration options
--   > Virtual lines feature    : https://gpanders.com/blog/whats-new-in-neovim-0-11/#virtual-lines
--
-- =============================================================================

-- =============================================================================
-- SUPPRESS ENCODING WARNING
-- =============================================================================

-- Work around a race condition that causes spurious warnings about position
-- encoding mismatch when multiple LSP clients attach to the same buffer.
--
-- This happens because different LSP servers might briefly report different
-- encodings during startup. The warning is harmless but annoying, so we
-- suppress it.

-- Save a reference to the original vim.notify function
local original_notify = vim.notify

-- Replace vim.notify with a wrapper that filters out the specific warning
vim.notify = function(msg, ...)
  -- Check if this is the encoding warning we want to suppress
  if msg:match("position_encoding param is required in vim.lsp.util.make_position_params") then
    return  -- Silently ignore this message
  end
  -- For all other messages, call the original notify function
  return original_notify(msg, ...)
end

-- =============================================================================
-- FORCE CONSISTENT ENCODING
-- =============================================================================

-- Force all LSP servers to use UTF-16 encoding for position calculations.
--
-- Different LSP servers might use different character encodings (UTF-8, UTF-16,
-- UTF-32) for calculating cursor positions. This can cause issues when multiple
-- servers are attached to the same buffer. By forcing UTF-16 (the most common),
-- we ensure consistency.

-- Create an autocommand that runs when any LSP server attaches to a buffer
vim.api.nvim_create_autocmd("LspAttach", {
  -- Create a group so we can manage this autocommand
  group = vim.api.nvim_create_augroup("UserLspEncoding", {}),
  callback = function(args)
    -- Get the LSP client that just attached
    -- args.data.client_id is provided by the LspAttach event
    local client = vim.lsp.get_client_by_id(args.data.client_id)

    -- If the client exists, set its encoding to UTF-16
    if client then
      client.offset_encoding = "utf-16"
    end
  end,
})

-- =============================================================================
-- DIAGNOSTIC DISPLAY CONFIGURATION
-- =============================================================================

-- Create a local reference to the severity enum for cleaner code
-- Instead of writing vim.diagnostic.severity.ERROR everywhere, we can write
-- severity.ERROR
local severity = vim.diagnostic.severity

-- Configure how diagnostics are displayed throughout Neovim
vim.diagnostic.config({

  -- Sort diagnostics by severity (errors first, then warnings, etc.)
  -- This ensures the most important issues are shown first when there
  -- are multiple diagnostics on the same line.
  severity_sort = true,

  -- Show underlines only for errors.
  -- Underlines draw a colored line under the problematic code.
  -- We limit this to errors to avoid visual clutter from less severe issues.
  underline = { severity = severity.ERROR },

  -- Use "virtual lines" to display the diagnostic message.
  --
  -- Virtual lines show the diagnostic text on a new line below the error,
  -- but only for the line where your cursor is currently positioned
  -- (current_line = true). This avoids cluttering the entire file with
  -- diagnostic messages.
  --
  -- This is a Neovim 0.11+ feature that provides clearer diagnostic display
  -- than the traditional "virtual text" that appears at the end of lines.
  virtual_lines = { current_line = true },

  -- Configure the icons shown in the sign column (gutter) for each severity.
  --
  -- The sign column is the narrow column to the left of line numbers where
  -- symbols appear to indicate diagnostics. These Nerd Font icons provide
  -- visual indicators at a glance:
  --   󰅚  : Error (X in a circle)
  --   󰀪  : Warning (exclamation in a circle)
  --   󰋽  : Info (i in a circle)
  --   󰌶  : Hint (lightbulb)
  signs = {
    text = {
      [severity.ERROR] = "󰅚 ",  -- Displayed for errors
      [severity.WARN] = "󰀪 ",   -- Displayed for warnings
      [severity.INFO] = "󰋽 ",   -- Displayed for informational messages
      [severity.HINT] = "󰌶 ",   -- Displayed for hints/suggestions
    },
  },
})
