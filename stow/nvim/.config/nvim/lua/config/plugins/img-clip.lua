-- =============================================================================
-- FILE: lua/config/plugins/img-clip.lua
--
-- PURPOSE:
--   Paste screenshots, clipboard images, or image URLs into zettelkasten notes.
--   Files land in $ZK_DIR/assets/; notes get vault-root Markdown links.
--
-- DEPENDENCIES (macOS):
--   brew install pngpaste      -- clipboard image paste
--   brew install imagemagick   -- image.nvim preview (scale/crop)
--   bash ~/dotfiles/scripts/wezterm.sh  -- Kitty terminfo for tmux+WezTerm
--
-- WORKFLOW:
--   1. Screenshot to clipboard (Cmd+Ctrl+Shift+4) or copy image / image URL
--   2. In a .md / .qmd note: <leader>ip
--   3. Enter a name (e.g. "Auth Diagram") → assets/YYYYMMDD-auth_diagram.png
--   4. Inserts: ![](assets/YYYYMMDD-auth_diagram.png)
--
-- DOCUMENTATION:
--   > GitHub : https://github.com/HakonHarnes/img-clip.nvim
--
-- =============================================================================

local img_clip_helpers = require "config.plugins.custom.img_clip_helpers"

local ASSETS_DIRNAME = img_clip_helpers.ASSETS_DIRNAME

local function paste_vault_image()
  local basename = img_clip_helpers.prompt_asset_basename()
  if not basename then return end

  require("img-clip").paste_image { file_name = basename }
end

-- Markdown/quarto filetype defaults disable download_images and enable
-- url_encode_path; override both for vault-root asset links.
local markdown_ft = {
  download_images = true,
  url_encode_path = false,
  template = "![](" .. ASSETS_DIRNAME .. "/$FILE_NAME)",
  insert_mode_after_paste = false,
  use_cursor_in_template = false,
}

return {
  "HakonHarnes/img-clip.nvim",
  ft = { "markdown", "quarto" },
  opts = {
    default = {
      dir_path = function()
        return img_clip_helpers.assets_dir() or ASSETS_DIRNAME
      end,
      prompt_for_file_name = false,
    },
    filetypes = {
      markdown = markdown_ft,
      quarto = markdown_ft,
    },
  },
  keys = {
    {
      "<leader>ip",
      paste_vault_image,
      mode = { "n", "v" },
      desc = "[I]mage [P]aste",
      ft = { "markdown", "quarto" },
    },
  },
}
