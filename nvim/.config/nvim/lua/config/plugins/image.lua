return {
  "3rd/image.nvim",
  -- See https://github.com/3rd/image.nvim/issues/91#issuecomment-2453430239
  build = false,
  opts = {
    processor = "magick_cli",
  },
  config = function()
    require("image").setup({
      backend = "kitty",
      processor = "magick_cli",
      integrations = {
        markdown = {
          enabled = true,
          clear_in_insert_mode = false,
          download_remote_images = true,
          only_render_image_at_cursor = false,
          only_render_image_at_cursor_mode = "popup", -- or "inline"
          -- if true, images will be rendered in floating markdown windows
          floating_windows = false,
          -- Markdown extensions like `quaro` go here
          filetypes = { "markdown", "vimwiki" },
        },
        neorg = {
          enabled = true,
          filetypes = { "norg" },
        },
        typst = {
          enabled = true,
          filetypes = { "typst" },
        },
        html = {
          enabled = false,
        },
        css = {
          enabled = false,
        },
      },
      max_width = nil,
      max_height = nil,
      max_width_window_percentage = nil,
      max_height_window_percentage = 50,
      scale_factor = 1.0,

      -- Toggles images when windows are overlapped
      window_overlap_clear_enabled = false,
      window_overlap_clear_ft_ignore = {
        "cmp_menu",
        "cmp_docs",
        "snacks_notif",
        "scrollview",
        "scrollview_sign",
      },

      -- Auto show/hide images when the editor gains/looses focus
      editor_only_render_when_focused = false,

      -- Auto show/ide images in the correct Tmux window
      -- Needs visual-activity off
      tmux_show_only_in_active_window = false,

      -- Render image files as images when opened
      hijack_file_patterns = {
        "*.png",
        "*.jpg",
        "*.jpeg",
        "*.gif",
        "*.webp",
        "*.avif",
      },
    })
  end,
}
