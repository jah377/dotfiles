-- [[ Vimtex.nvim: Nvim file explorer ]]
-- See: https://github.com/lervag/vimtex

return {
  "lervag/vimtex",
  -- No need as ftplugins only loaded once file type is opened
  lazy = false,
  init = function()
    vim.g.vimtex_view_method = "skim" -- zathura
    vim.g.vimtext_compiler_method = "latexmk" -- default
  end,
}
