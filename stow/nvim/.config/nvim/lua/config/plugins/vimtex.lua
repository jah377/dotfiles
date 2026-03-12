-- =============================================================================
-- FILE: lua/config/plugins/vimtex.lua
--
-- PURPOSE:
--   Configures VimTeX, the most comprehensive LaTeX plugin for Vim/Neovim.
--   It provides compilation, PDF viewing, syntax highlighting, and text
--   objects for editing LaTeX documents.
--
-- WHAT IS LATEX?
--   LaTeX is a document preparation system used for creating professional
--   documents, academic papers, books, and presentations. It uses markup
--   commands (like \section{}, \begin{equation}) instead of WYSIWYG editing.
--
-- FEATURES:
--   - Compile LaTeX to PDF with :VimtexCompile
--   - View PDF with synchronized scrolling (SyncTeX)
--   - LaTeX-specific text objects (e.g., "ie" for inner environment)
--   - Syntax highlighting and concealment
--   - Table of contents navigation
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
  -- Plugin identifier from GitHub
  "lervag/vimtex",

  -- Don't lazy load this plugin.
  -- VimTeX is implemented as a filetype plugin (ftplugin), which means it
  -- automatically loads only when you open a .tex file. Adding lazy loading
  -- on top of that would be redundant and could cause issues.
  lazy = false,

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
