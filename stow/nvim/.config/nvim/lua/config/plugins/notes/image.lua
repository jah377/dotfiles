-- =============================================================================
-- FILE: lua/config/plugins/notes/image.lua
--
-- PURPOSE:
--   Kitty Graphics Protocol image rendering for Markdown/Quarto notes and for
--   Molten plots. molten-nvim is ft=quarto and lists image.nvim as a
--   dependency, so this spec is not force-loaded at startup.
--
-- NOTES:
--   - WezTerm + tmux: TERM must be xterm-kitty (tmux default-terminal), Kitty
--     terminfo installed (scripts/wezterm.sh), allow-passthrough on
--   - Needs ImageMagick CLI (`brew install imagemagick`) for magick_cli
--   - Vault-root assets/ resolution: config.plugins.custom.img_clip_helpers
--   - Run :ImageReport to verify image setup
--
-- KEYMAPS (markdown / quarto):
--   <leader>it  : Toggle cursor-only vs all-in-view image preview
--
-- DOCUMENTATION:
--   > image.nvim   : https://github.com/3rd/image.nvim
--
-- =============================================================================

local img_clip_helpers = require "config.plugins.custom.img_clip_helpers"

return {
  "3rd/image.nvim",

  -- build=false skips luarocks/magick rock; magick_cli uses system ImageMagick.
  build = false,

  ft = { "quarto", "markdown" },

  opts = {
    backend = "kitty",
    max_height_window_percentage = 50,
    max_width_window_percentage = 50,
    window_overlap_clear_enabled = true, -- to prevent image + telescope/oil overlap
    tmux_show_only_in_active_window = true,

    integrations = {
      markdown = {
        enabled = true,
        filetypes = { "markdown", "quarto" },
        resolve_image_path = img_clip_helpers.resolve_image_path,
        -- Want to see image while taking notes
        floating_windows = false, -- show in document
        only_render_image_at_cursor = false, -- always display image
        clear_in_insert_mode = false, -- always display image
      },
      -- Disable unused document integrations so toggle re-setup stays cheap
      neorg = { enabled = false },
      typst = { enabled = false },
      asciidoc = { enabled = false },
      html = { enabled = false },
      css = { enabled = false },
      org = { enabled = false },
      syslang = { enabled = false },
    },
  },

  config = function(_, opts)
    require("image").setup(opts)

    -- Re-setup required: integration options are copied into an internal ctx.
    local function refresh_images()
      local image = require "image"
      image.clear()
      image.setup(opts)
    end

    local function toggle_cursor_only()
      local md = opts.integrations.markdown
      md.only_render_image_at_cursor = not md.only_render_image_at_cursor
      refresh_images()
      vim.notify(md.only_render_image_at_cursor and "Images: cursor only" or "Images: all in view", vim.log.levels.INFO)
    end

    require("config.plugins.custom.lazy_ft").on_filetypes(
      "image-toggle-keymap",
      { "markdown", "quarto" },
      function(bufnr)
        vim.keymap.set("n", "<leader>it", toggle_cursor_only, {
          buffer = bufnr,
          desc = "[I]mage preview [T]oggle",
        })
      end
    )

    -- Clear images when pane loses focus; re-render when it regains focus. Prevents stale image overlays from
    -- persisting across tmux pane/window switches.
    local image_focus_group = vim.api.nvim_create_augroup("image-focus", { clear = true })

    vim.api.nvim_create_autocmd("FocusLost", {
      group = image_focus_group,
      callback = function()
        require("image").clear()
      end,
    })

    vim.api.nvim_create_autocmd("FocusGained", {
      group = image_focus_group,
      callback = function()
        local ft = vim.bo.filetype
        if ft == "markdown" or ft == "quarto" then refresh_images() end
      end,
    })
  end,
}
