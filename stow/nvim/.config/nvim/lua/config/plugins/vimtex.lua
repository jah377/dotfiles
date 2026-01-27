-- [[ Vimtex.nvim: Nvim file explorer ]]
-- See: https://github.com/lervag/vimtex

return {
  "lervag/vimtex",
  -- No need as ftplugins only loaded once file type is opened
  lazy = false,
  init = function()
    -- Cannot install `zathura` via brew. `Preview` doesn't support `SyncTex`,
    -- forwrd/inverse search between source and PDF. Use `skim` instead.
    vim.g.vimtex_view_method = "skim" -- default: zathura

    -- `brew install --cask mactex` to intsall `latexmk`
    vim.g.vimtext_compiler_method = "latexmk"
  end,
}
