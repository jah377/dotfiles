-- WezTerm terminal emulator configuration
-- See: https://wezfurlong.org/wezterm/config/lua/config/index.html

local wezterm = require("wezterm")
local config = wezterm.config_builder()

-- wezterm ls-fonts --list-system | grep "JetBrains"
config.font = wezterm.font("JetBrains Mono", { weight = "Regular" })
config.font_size = 14

config.default_cursor_style = "SteadyBlock"
config.color_scheme = "Catppuccin Mocha"
config.automatically_reload_config = true
config.enable_tab_bar = false        -- use 'tmux' instead of tabs
config.window_close_confirmation = "NeverPrompt"
config.window_decorations = "RESIZE" -- disable title bar

config.window_padding = {
  left = 10,
  right = 10,
  top = 0,
  bottom = 0,
}

-- Must set to 'false' otherwise cannot use 'fzf' ALT keybindings
config.send_composed_key_when_left_alt_is_pressed = false
config.send_composed_key_when_right_alt_is_pressed = false -- default: true

config.keys = {
  {
    -- Disable 'C-=' as kbd used for smart selection in treesitter.lua
    key = "=",
    mods = "CTRL",
    action = wezterm.action.DisableDefaultAssignment,
  },
}

-- URLs in Markdown files are not handled properly by default
-- See: https://github.com/wezterm/wezterm/issues/3803
-- Workaround from: https://akos.ma/blog/adopting-wezterm/
config.hyperlink_rules = {

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
  -- Note: [^(] excludes line-start URLs to prevent double-matching with above rules
  {
    regex = "[^(]\\b(\\w+://\\S+[)/a-zA-Z0-9-]+)",
    format = "$1",
    highlight = 1,
  },
}

return config
