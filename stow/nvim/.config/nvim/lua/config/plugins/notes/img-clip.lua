-- =============================================================================
-- FILE: lua/config/plugins/notes/img-clip.lua
--
-- PURPOSE:
--   Paste screenshots, clipboard images, or image URLs into markdown/quarto
--   notes. Files land in `<git-root>/assets/`; notes get paths relative to the
--   note file.
--
-- DEPENDENCIES (macOS):
--   brew install pngpaste      -- clipboard image paste
--   brew install imagemagick   -- image.nvim preview (scale/crop)
--   bash ~/dotfiles/scripts/wezterm.sh  -- Kitty terminfo for tmux+WezTerm
--
-- WORKFLOW:
--   1. Screenshot to clipboard (Cmd+Ctrl+Shift+4) or copy image / image URL
--   2. In a saved .md / .qmd note under a git repo: <leader>ip
--   3. Enter a name (e.g. "Auth Diagram") → file at
--      `<git-root>/assets/YYYYMMDD-auth_diagram.png`
--   4. Inserts a note-relative link; depth depends on the note path (e.g. from
--      `notes/foo.md` → `![](../assets/YYYYMMDD-auth_diagram.png)`)
--
-- DOCUMENTATION:
--   > GitHub : https://github.com/HakonHarnes/img-clip.nvim
--
-- =============================================================================

local img_clip_helpers = require "config.plugins.custom.img_clip_helpers"

local function paste_image()
  local basename = img_clip_helpers.prompt_asset_basename()
  if not basename then return end

  -- Capture note dir before paste so the template stays tied to this buffer
  -- even if focus changes during download/copy.
  img_clip_helpers._paste_note_dir = vim.fn.expand "%:p:h"
  local ok, err = pcall(function()
    require("img-clip").paste_image { file_name = basename }
  end)
  img_clip_helpers._paste_note_dir = nil
  if not ok then vim.notify(tostring(err), vim.log.levels.ERROR) end
end

-- Markdown/quarto filetype defaults disable download_images and enable
-- url_encode_path; override both. Template emits a path relative to the note.
local markdown_ft = {
  download_images = true,
  url_encode_path = false,
  template = img_clip_helpers.markdown_image_template,
  insert_mode_after_paste = false,
  use_cursor_in_template = false,
  relative_template_path = true,
  use_absolute_path = false,
}

return {
  "HakonHarnes/img-clip.nvim",
  ft = { "markdown", "quarto" },
  opts = {
    default = {
      dir_path = function()
        -- No notify here: <leader>ip already notified via prompt_asset_basename.
        -- Direct ImgClipPaste gets a single clear error from the err tag.
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
