-- =============================================================================
-- TITLE : lazy.nvim
--
-- ABOUT :
--   Bootstraps the 'lazy.nvim' plugin manager by cloning it if not present,
--   preprends it to the runtime path, and initializes 'lazy.nvim' with
--   plugins. Initialized in 'init.lua'.
--
-- DOCS :
--   > lazy.nvim github  : https://github.com/folke/lazy.nvim
--   > lazy.nvim website : https://lazy.folke.io/installation
--
-- TUTORIALS :
--   > Tj Devries :  https://youtu.be/_kPg0VBRxJc?si=M-jDh69L7sXH0Ggh
--
-- =============================================================================

-- Look for lazy.nvim in data path, otherwise clone repo
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end

-- Hey! Put lazy into the runtimepath for neovim!
vim.opt.rtp:prepend(lazypath)

-- Setup lazy.nvim
require("lazy").setup({
  spec = {
    -- import your plugins
    { import = "config.plugins" },
  },
  -- Automatically check for plugin updates
  checker = { enabled = true },
  -- Check for changes to config files
  change_detection = {
    enabled = true, -- check and reload ui
    notify = false, -- disable notifications
  },
})
