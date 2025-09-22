local wezterm = require("wezterm")

config = wezterm.config_builder()

config = {
  automatically_reload_config = true,
  enable_tab_bar = false,
  window_close_confirmation = "NeverPrompt",
  window_decorations = "RESIZE", -- disable title bar; able to resize window
  window_padding = {
    left = 5,
    right = 5,
    top = 5,
    bottom = 0,
  },
  default_cursor_style = "SteadyBlock",
  color_scheme = "Catppuccin Mocha",

  -- wezterm ls-fonts --list-system | grep "JetBrains"
  font = wezterm.font("JetBrains Mono", { weight = "Regular" }),
  font_size = 14,

  -- from: https://akos.ma/blog/adopting-wezterm/
  hyperlink_rules = {
    -- Matches: a URL in parens: (URL)
    {
      regex = "\\((\\w+://\\S+)\\)",
      format = "$1",
      highlight = 1,
    },
    -- Matches: a URL in brackets: [URL]
    {
      regex = "\\[(\\w+://\\S+)\\]",
      format = "$1",
      highlight = 1,
    },
    -- Matches: a URL in curly braces: {URL}
    {
      regex = "\\{(\\w+://\\S+)\\}",
      format = "$1",
      highlight = 1,
    },
    -- Matches: a URL in angle brackets: <URL>
    {
      regex = "<(\\w+://\\S+)>",
      format = "$1",
      highlight = 1,
    },
    -- Then handle URLs not wrapped in brackets
    {
      regex = "[^(]\\b(\\w+://\\S+[)/a-zA-Z0-9-]+)",
      format = "$1",
      highlight = 1,
    },
  },
  keys = {
    {
      -- Disable; instead used for smart selection in treesitter.lua
      key = "=",
      mods = "CTRL",
      action = wezterm.action.DisableDefaultAssignment,
    },
  },
}

return config
