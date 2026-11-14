-- ============================================================================
-- FILE: lua/config/lazy.lua
-- Bootstraps lazy.nvim. Plugin specs live in lua/config/plugins/; lazy.nvim
-- does not recurse, so each nested spec directory is a named import below.
-- Shared helper modules live in lua/config/lib/, outside the spec tree, so
-- nothing there can be mistaken for a plugin spec.
--
-- Commands:
--  > :Lazy (UI), S=sync, U=update, X=clean, P=profile startup time
-- Documentation:
--  > lazy.nvim Github : https://github.com/folke/lazy.nvim
-- ============================================================================

-- Bootstrap: clone lazy.nvim on first start. This config targets Neovim 0.12,
-- where vim.uv is always present, so the historic `vim.uv or vim.loop` guard
-- is not needed.
local lazypath = vim.fs.joinpath(vim.fn.stdpath("data"), "lazy", "lazy.nvim")
if not vim.uv.fs_stat(lazypath) then
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
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    spec = {
        { import = "config.plugins" }, -- lua/config/plugins/*.lua (top level only)
        { import = "config.plugins.notebook" }, -- molten + quarto/otter
        { import = "config.plugins.notes" }, -- image, img-clip, obsidian, render-markdown, bullets
    },
    checker = { enabled = true }, -- Notify about plugin updates; never apply them automatically
    change_detection = { enabled = true, notify = false },
})
