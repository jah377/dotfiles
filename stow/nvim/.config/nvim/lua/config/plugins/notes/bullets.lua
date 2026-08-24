-- =============================================================================
-- FILE: lua/config/plugins/notes/bullets.lua
-- Automatic bullet/checkbox list continuation, renumbering, and indenting
--
-- DEFAULT KEYBINDINGS:
--   Insert : <cr> / <C-cr>  -- insert new bullet
--   Insert : <C-t>          -- demote bullet (indent, drop a level)
--   Insert : <C-d>          -- promote bullet (unindent, raise a level)
--   Normal : o              -- insert new bullet below
--   Normal : <leader>x      -- toggle checkbox
--   Normal : >> / <<        -- demote / promote bullet
--   Normal : gN             -- renumber list under cursor
--   Visual : > / <          -- demote / promote selection
--   Visual : gN             -- renumber selection
--
-- DOCUMENTATION:
--   > GitHub : https://github.com/bullets-vim/bullets.vim
-- =============================================================================

return {
  "bullets-vim/bullets.vim",
  ft = { "markdown", "quarto", "text", "gitcommit", "scratch" },
  init = function()
    vim.g.bullets_enabled_file_types = { "markdown", "quarto", "text", "gitcommit", "scratch" }
  end,
}
