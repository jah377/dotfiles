-- =============================================================================
-- FILE: lua/config/lazy.lua
--
-- PURPOSE:
--   This file bootstraps and configures lazy.nvim, the plugin manager for
--   this Neovim configuration. A plugin manager handles:
--   - Downloading plugins from GitHub
--   - Keeping plugins up to date
--   - Loading plugins on demand (lazy loading) for faster startup
--   - Managing plugin dependencies
--
--   lazy.nvim is the most popular plugin manager for modern Neovim because:
--   - It's fast and written in Lua
--   - It supports lazy loading (plugins load only when needed)
--   - It has a beautiful UI for managing plugins
--   - It handles dependencies automatically
--
-- HOW TO USE:
--   - Add plugins in lua/config/plugins/ (each file returns a plugin spec)
--   - Run :Lazy to open the plugin manager UI
--   - Press 'S' to sync (install/update all plugins)
--   - Press 'U' to update all plugins
--   - Press 'X' to remove unused plugins
--
-- DOCUMENTATION:
--   > lazy.nvim GitHub   : https://github.com/folke/lazy.nvim
--   > lazy.nvim Website  : https://lazy.folke.io/installation
--   > Plugin Spec        : https://lazy.folke.io/spec
--
-- TUTORIALS:
--   > TJ DeVries         : https://youtu.be/_kPg0VBRxJc?si=M-jDh69L7sXH0Ggh
--
-- =============================================================================

-- =============================================================================
-- BOOTSTRAP lazy.nvim
-- =============================================================================
-- This section ensures lazy.nvim is installed. On first run, it will
-- automatically download lazy.nvim from GitHub. After that, it uses the
-- cached version.

-- Build the path where lazy.nvim should be installed.
-- vim.fn.stdpath("data") returns ~/.local/share/nvim on Unix
-- So lazypath = ~/.local/share/nvim/lazy/lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

-- Check if lazy.nvim exists at the expected path.
-- vim.uv.fs_stat returns file info if the path exists, nil otherwise.
-- (vim.loop is the old name for vim.uv, kept for compatibility)
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  -- lazy.nvim is not installed, so we need to clone it from GitHub.

  -- The GitHub repository URL for lazy.nvim
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"

  -- Clone the repository using git.
  -- vim.fn.system() runs a shell command and returns its output.
  -- Arguments:
  --   git clone           : The git command to copy a repository
  --   --filter=blob:none  : Partial clone (don't download file history)
  --   --branch=stable     : Use the stable branch (not bleeding edge)
  --   lazyrepo            : The URL to clone from
  --   lazypath            : Where to clone to
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })

  -- Check if the clone failed (non-zero exit code).
  -- vim.v.shell_error contains the exit code of the last shell command.
  if vim.v.shell_error ~= 0 then
    -- Show an error message to the user with the git output.
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },  -- Red error text
      { out, "WarningMsg" },                           -- Yellow warning with git output
      { "\nPress any key to exit..." },                -- Prompt
    }, true, {})

    -- Wait for the user to press a key before exiting.
    vim.fn.getchar()

    -- Exit Neovim with error code 1 (indicates failure).
    os.exit(1)
  end
end

-- Add lazy.nvim to the beginning of Neovim's runtime path.
--
-- The runtime path (rtp) is a list of directories where Neovim looks for
-- Lua modules, plugins, and configuration files. By prepending lazy.nvim's
-- path, we make it available for require().
vim.opt.rtp:prepend(lazypath)

-- =============================================================================
-- CONFIGURE lazy.nvim
-- =============================================================================

-- Initialize lazy.nvim with our configuration.
-- require("lazy") loads the lazy.nvim module (now available because we
-- added it to rtp above).
-- .setup() configures lazy.nvim and loads all plugins.
require("lazy").setup({

  -- 'spec' defines where to find plugin specifications.
  -- Each entry is a directory containing Lua files that return plugin specs.
  spec = {
    -- Load all plugin specs from lua/config/plugins/
    -- Each .lua file in this directory should return a table (or list of
    -- tables) defining one or more plugins.
    { import = "config.plugins" },

    -- Load LSP-related plugin specs from lua/config/plugins/lsp/
    -- This keeps LSP configuration separate from other plugins.
    { import = "config.plugins.lsp" },
  },

  -- 'checker' configures automatic plugin update checking.
  -- When enabled, lazy.nvim periodically checks GitHub for newer versions
  -- of your plugins and notifies you when updates are available.
  checker = { enabled = true },

  -- 'change_detection' watches for changes to plugin configuration files.
  -- When you edit a plugin's config, lazy.nvim can automatically reload it.
  change_detection = {
    enabled = true,  -- Watch for config changes and reload
    notify = false,  -- Don't show "config changed" notifications (reduces noise)
  },
})
