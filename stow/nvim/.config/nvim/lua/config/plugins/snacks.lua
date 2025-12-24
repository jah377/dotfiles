-- [[ Snacks.nvim: Collection of 20+ small QoL (Quality of Life) plugins ]]
-- Not all QoL plugins are used
-- See: https://github.com/folke/snacks.nvim

return {
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = {
      -- Disable heavy features (LSP, treesitter, etc.) for large files
      bigfile = {
        enabled = true,
        notify = true,
        size = 1.5 * 1024 * 1024, -- 1.5MB threshold
      },

      -- Quickly render file on `nvim <file>`
      quickfile = { enabled = true },

      -- Pretty status-column (gutter)
      statuscolumn = {
        enabled = true,
        opts = { statuscolumn = {} }
      },

      -- [[ Features provided elsewhere ]]
      dim = { enabled = false },       -- dimmed in 'theme.lua'
      explorer = { enabled = false },  -- using 'oil.nvim'
      gh = { enabled = false },        -- view in browser
      git = { enabled = false },       -- use 'lazygit'
      gitbrowse = { enabled = false }, -- view in browser
      image = { enabled = false },     -- using 'image.nvim'
      indent = { enabled = false },    -- using 'mini.indent'
      picker = { enabled = false },    -- using 'telescope.nvim'
      lazygit = { enabled = false },   -- use in 'tmux'

      -- [[ Not interested ]]
      animate = { enabled = false },   -- efficient animation library
      bufdelete = { enabled = false }, -- keep layout after deletion
      dashboard = { enabled = false }, -- dashboard on startup
      input = { enabled = false },     -- fancy user input UI
      keymap = { enabled = false },    -- better `vim.keymap.set`
      layout = { enabled = false },    -- windows layouts
      notifier = { enabled = false },  -- also disabled in 'theme.lua'
      notify = { enabled = false },    -- utility functions
      profiler = { enabled = false },  -- lua profiler
      rename = { enabled = false },    -- LSP-integrated file renaming
      scope = { enabled = false },     -- scope-based jumping
      scratch = { enabled = false },   -- persistent scratch buffers
      scroll = { enabled = false },    -- smooth scrolling still janky
      terminal = { enabled = false },  -- floating terminal
      toggle = { enabled = false },    -- toggle keymap integration
      util = { enabled = false },      -- utils?
      win = { enabled = false },       -- floating docs
      words = { enabled = false },     -- navigate between LSP references
      zen = { enabled = false },       -- distraction-free coding
    },
  },
}
