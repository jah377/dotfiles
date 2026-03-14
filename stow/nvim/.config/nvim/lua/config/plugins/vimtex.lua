-- =============================================================================
-- FILE: lua/config/plugins/vimtex.lua
-- Comprehensive LaTeX plugin provides compilation, PDF viewing, highlighting
--
-- PREREQUISITES:
--   - MacTeX: brew install --cask mactex
--   - Skim PDF viewer: brew install --cask skim
--
-- DOCUMENTATION:
--   > GitHub : https://github.com/lervag/vimtex
--   > :help vimtex
--
-- =============================================================================

return {
  "lervag/vimtex",
  lazy = false, -- default: VimTeX implemented as filetype plugin

  -- 'init' runs BEFORE the plugin loads.
  -- VimTeX reads global variables (vim.g.*) during initialization, so we
  -- must set them here rather than in 'config'.
  init = function()
    -- Configure the PDF viewer for viewing compiled documents.
    --
    -- Why Skim instead of Preview or Zathura?
    -- - Preview.app: Doesn't support SyncTeX (forward/inverse search)
    -- - Zathura: Not available via Homebrew on macOS
    -- - Skim: Free, supports SyncTeX, works well on macOS
    --
    -- SyncTeX enables:
    -- - Forward search: Jump from source line to corresponding PDF position
    -- - Inverse search: Cmd-click in PDF to jump to source line
    vim.g.vimtex_view_method = "skim"

    -- Configure the LaTeX compiler.
    --
    -- latexmk is a Perl script that automates the LaTeX compilation process.
    -- It automatically runs pdflatex, bibtex, etc. the correct number of
    -- times to resolve all references and citations.
    --
    -- latexmk is included with MacTeX, so no additional installation needed
    -- once you've run: brew install --cask mactex
    vim.g.vimtext_compiler_method = "latexmk"
  end,
}
