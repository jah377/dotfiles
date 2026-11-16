-- =============================================================================
-- FILE: lua/config/lib/paths.lua
-- MODULE: require("config.lib.paths")
--
-- Discover repository paths at runtime without hardcoding or environment
-- variables.
--
-- PROBLEM:
--   Neovim config may need the absolute path to the dotfiles repository root.
--   Hardcoding breaks portability—the repo could be cloned to ~/dotfiles,
--   ~/.dotfiles, ~/projects/dotfiles, etc.
--
-- SOLUTION:
--   ~/.config/nvim is a GNU Stow symlink into the repository. Resolve the
--   symlink to its real path, then walk up to find .git. The repo root is
--   recoverable without any external state.
-- =============================================================================

local paths = {}

--- Root of the git repository that contains this Neovim config.
--- Falls back to the config directory when the symlink or .git is missing
--- (eg. the config was copied rather than stowed).
--- @return string
function paths.dotfiles_root()
    local config_dir = vim.fn.stdpath("config")
    local real_config_dir = vim.uv.fs_realpath(config_dir) or config_dir
    return vim.fs.root(real_config_dir, ".git") or real_config_dir
end

return paths
