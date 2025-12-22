# Introduction

See the following resources used to learn and configure `tmux`:

- [Github Wiki](https://github.com/tmux/tmux/wiki/Getting-Started)

# Basic Concepts

- Window :: A single terminal screen
  - By default, named by index (can rename)
- Pane :: An un-named split region inside a window
- Session :: collection of windows and panes
  - Typically you would organize into per-project "workspace"
  - Example, `nvim` in one pane and a `python` REPL in the other
- Server :: background `tmux` process that manages all sessions
  - Closing terminal will end sessions and processes
  - "Detaching" session will keep processes running; can "attach" later

# Terminal Commands

**Creating a new session:**

- `tmux new` :: Create new session, named by index (`[0]`, `[1]`,...)
- `tmux new -d` :: Create new, _detached_ session
  - By default, new sessions are "attached"
  - Must avoid creating nested "attached" sessions
  - Add `-d` to create "detached" session
- `tmux new -s <name>`:: Create new, named session

**Listing or Killing Session:**

- `tmux kill-session` :: Kill current session
  - `-a` :: Kill all sessions but current
- `tmux ls` :: List all sessions

# Keybindings

**Note:** See `tmux.conf` and `remappings.conf` for custom keybindings

- `C-Space` :: leader button (custom; default is `C-b`)

Windows:

- `<leader> c` :: Create new window
- `<leader> n` :: Go to next window
- `<leader> p` :: Go to previous window
- `<leader> w` :: Choose window from list
- `<leader> &` :: Kill current window
- `<leader> ,` :: Rename window

Panes:

- `<leader> %` :: Create pane
- `<leader> E` :: Spread panes out evenly
- `<leader> x` :: Kill current pane
- `<leader> arrows` :: Select pane above/below/left/right
- `<leader> M-arrows` :: Resize pane above/below/left/right by 5

Sessions:

- `<leader> $` :: Rename current session
- `<leader> s` :: Select session from list

Interactive Commands:

- `:kill-servers` :: Kill all servers
- `:neww -n <name>` :: Create new window and make current
  - `-d` :: To create named window in background

# Configuring

To install `tpm` (tmux plugin manager):

```bash
git clone https://github.com/tmux-plugins/tpm ~/.config/tmux/plugins/tpm
```

To install `catppuccin` theme:

```bash
mkdir -p ~/.config/tmux/plugins/catppuccin/tmux
git clone -b v2.1.3 https://github.com/catppuccin/tmux.git ~/.config/tmux/plugins/catppuccin/tmux
```


To install plugins (including catppuccin theme):

1. Start tmux: `tmux`
2. Press `<leader> I` (that's `C-Space` then `Shift+i`) to install all plugins
3. TPM will automatically install all plugins listed in `tmux.conf`
