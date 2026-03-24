-- =============================================================================
-- FILE: lua/config/plugins/mini/trailspace.lua
-- Highlight and delete trailing whitespace
--
-- DOCUMENTATION:
--  > https://github.com/echasnovski/mini.nvim/blob/main/readmes/mini-trailspace.md
--
-- =============================================================================

return {
  "echasnovski/mini.nvim",
  config = function()
    require("mini.trailspace").setup()

    vim.api.nvim_create_autocmd("BufWritePre", {
      desc = "Trim trailing whitespace on save",
      group = vim.api.nvim_create_augroup("MiniTrailspaceTrim", { clear = true }),
      callback = function()
        require("mini.trailspace").trim()
        require("mini.trailspace").trim_last_lines()
      end,
    })
  end,
}
