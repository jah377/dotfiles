-- =============================================================================
-- FILE: lua/config/plugins/line.lua
-- Minimal statusline plugin
--
-- DOCUMENTATION:
--  > https://github.com/sadiksaifi/line.nvim
--
-- =============================================================================

return {
  "sadiksaifi/line.nvim",
  opts = {
    theme = "default",

    root_markers = {
      ".git",
      ".vscode",
      ".editorconfig",
      "package.json",
      "deno.json",
      "pyproject.toml",
      "Cargo.toml",
      "go.mod",
      "composer.json",
      "Gemfile",
    },

    components = {
      mode = true, -- Show current mode
      file_path = true, -- Show file path
      lsp = true, -- Show LSP status
      diagnostics = true, -- Show diagnostics
      git = true, -- Show git branch
      extension = true, -- Show file extension badge
    },

    icons = {
      error = "󰅚", -- Error diagnostic icon
      warn = "󰋽", -- Warning diagnostic icon
      git = " ", -- Git branch icon
    },
  },
}
