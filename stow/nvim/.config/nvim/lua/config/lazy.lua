-- =============================================================================
-- FILE: lua/config/lazy.lua
-- Bootstraps lazy.nvim plugin manager. Specs live in lua/config/plugins/;
-- nested dirs (notebook/, notes/, lsp/) are named imports. custom/ is
-- require-only and must not be imported.
--
-- Commands:
--  > :Lazy (UI), S=sync, U=update, X=clean
-- Documentation:
--  > lazy.nvim Github : https://github.com/folke/lazy.nvim
-- =============================================================================

-- Bootstrap: auto-install lazy.nvim if missing
local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system { "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath }
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
vim.opt.rtp:prepend(lazypath)

require("lazy").setup {
  spec = {
    { import = "config.plugins" }, -- lua/config/plugins/*.lua (not nested dirs)
    { import = "config.plugins.notebook" }, -- molten + quarto/otter
    { import = "config.plugins.notes" }, -- image, img-clip, obsidian, render-markdown
    { import = "config.plugins.lsp" }, -- lua/config/plugins/lsp/*.lua
  },
  checker = { enabled = true }, -- Check for plugin updates
  change_detection = { enabled = true, notify = false },
}
