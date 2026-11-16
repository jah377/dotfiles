-- =============================================================================
-- FILE: lua/config/plugins/notes/img-clip.lua
--
-- PURPOSE:
--   Paste screenshots, clipboard images, or image URLs into markdown/quarto
--   notes. Files land in `<git-root>/assets/`; notes get paths relative to the
--   note file. Path logic lives in config.lib.img_clip_helpers.
--
-- DEPENDENCIES (macOS):
--   brew install pngpaste      -- clipboard image paste
--   brew install imagemagick   -- image.nvim preview (scale/crop)
--   bash ~/dotfiles/scripts/wezterm.sh  -- Kitty terminfo for tmux+WezTerm
--
-- WORKFLOW:
--   1. Screenshot to clipboard (Cmd+Ctrl+Shift+4) or copy image / image URL
--   2. In a saved .md / .qmd note under a git repo: <leader>ip
--   3. Enter a name (e.g. "Auth Diagram") -> file at
--      `<git-root>/assets/YYYYMMDD-auth_diagram.png`
--   4. Inserts a note-relative link; depth depends on the note path (e.g. from
--      `notes/foo.md` -> `![](../assets/YYYYMMDD-auth_diagram.png)`)
--
-- DOCUMENTATION:
--   > GitHub : https://github.com/HakonHarnes/img-clip.nvim
-- =============================================================================

local img_clip_helpers = require("config.lib.img_clip_helpers")

--- <leader>ip: prompt for a name, then paste with a template bound to this
--- note's directory. The directory is captured here and handed to the
--- template through a closure (img-clip applies per-call opts over its
--- config), so the template never reads shared state that another paste or
--- a focus change could alter. The earlier revision passed it through a
--- module field set before the call and cleared after.
local function paste_image()
    local basename = img_clip_helpers.prompt_asset_basename()
    if not basename then return end

    local note_dir = vim.fn.expand("%:p:h")
    local ok, err = pcall(require("img-clip").paste_image, {
        file_name = basename,
        template = function(context) return img_clip_helpers.markdown_image_template(context, note_dir) end,
    })
    if not ok then vim.notify(tostring(err), vim.log.levels.ERROR) end
end

-- img-clip deep-merges these over its own markdown/quarto defaults, which
-- disable download_images, enable url_encode_path and set a string template.
-- The fallback template therefore has to live here, at filetype scope: a
-- filetype value outranks `default`, so a function placed under `default`
-- would lose to the built-in markdown string for a direct :ImgClipPaste.
-- Path options are inherited from `default` below and not repeated here.
local markdown_ft = {
    download_images = true,
    url_encode_path = false,
    insert_mode_after_paste = false,
    use_cursor_in_template = false,
    -- Fallback for :ImgClipPaste used without <leader>ip: relative to the
    -- current buffer at template time. <leader>ip overrides this per call.
    template = function(context) return img_clip_helpers.markdown_image_template(context, vim.fn.expand("%:p:h")) end,
}

return {
    "HakonHarnes/img-clip.nvim",
    ft = { "markdown", "quarto" },
    opts = {
        default = {
            dir_path = function()
                -- No notify here: <leader>ip already reported via prompt_asset_basename.
                -- A direct :ImgClipPaste surfaces this message once.
                local assets, err = img_clip_helpers.assets_dir()
                if not assets then error(img_clip_helpers.destination_error_message(err), 0) end
                return assets
            end,
            prompt_for_file_name = false,
            relative_template_path = true,
            use_absolute_path = false,
        },
        filetypes = {
            markdown = markdown_ft,
            quarto = markdown_ft,
        },
    },
    keys = {
        {
            "<leader>ip",
            paste_image,
            mode = { "n", "v" },
            desc = "[I]mage [P]aste",
            ft = { "markdown", "quarto" },
        },
    },
}
