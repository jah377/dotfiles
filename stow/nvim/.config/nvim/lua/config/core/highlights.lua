-- ============================================================================
-- FILE: lua/config/core/highlights.lua
-- Custom highlight groups, defined in one place.
--
-- WHY A COLORSCHEME AUTOCMD:
--   `:colorscheme` clears every highlight group before the new scheme loads,
--   so a group defined once at startup disappears the first time the theme
--   changes (eg. `:set background=light` reloads catppuccin). Defining the
--   groups in a ColorScheme autocmd, plus once immediately, keeps them alive.
--   Previously each group was set once from a different file and silently
--   lost on the first theme change.
--
-- CONSUMERS:
--   Folded                    : options.lua folding setup
--   OverLength                : autocmds.lua textwidth highlight
--   MiniHipatternsAssumptions : plugins/mini.lua hipatterns keyword
-- ============================================================================

local function apply_custom_highlights()
    -- Folded sections render like surrounding text (fold chrome is removed in
    -- options.lua via fillchars/foldtext).
    vim.api.nvim_set_hl(0, "Folded", { link = "Normal" })

    -- -- Theme-independent red so the overlength marker looks identical in the
    -- -- light and dark flavours.
    -- vim.api.nvim_set_hl(0, "OverLength", { fg = "#ff5555" })

    -- Follows the MiniHipatterns* naming so the keyword reads like the
    -- built-in FIXME/HACK/TODO/NOTE groups.
    vim.api.nvim_set_hl(0, "MiniHipatternsAssumptions", { fg = "#ffffff", bg = "#9d7cd8", bold = true })
end

apply_custom_highlights()

vim.api.nvim_create_autocmd("ColorScheme", {
    desc = "Re-apply custom highlight groups after a colorscheme loads",
    group = vim.api.nvim_create_augroup("CustomHighlightsGroup", { clear = true }),
    callback = apply_custom_highlights,
})
