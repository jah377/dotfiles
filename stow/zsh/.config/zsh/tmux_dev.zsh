# Tmux development environment setup
# Preset and interactive session creation with dev windows. Session creation works
# from inside or outside tmux; when already attached, the current client switches
# to the new session (same net effect as attach from a non-tmux shell).

# Window name to command mappings
# Windows without commands start with empty shell
typeset -A _TMUX_DEV_WINDOW_CMDS=(
    [nvim]="nvim"
    [git]="lazygit"
    [claude]="agent --mode ask"
    [cursor]="agent --mode ask"
    [tests]=""
    [dagster]=""
)

# Internal helper: creates tmux session with specified windows
# Usage: _tmux_dev_create_session <directory> <session_name> <window1> [window2...]
_tmux_dev_create_session() {
    local dir="$1"
    local session_name="$2"
    shift 2
    local windows=("$@")

    if ! command -v tmux &>/dev/null; then
        echo "Required command not found: tmux"
        return 1
    fi

    if [[ ! -d "$dir" ]]; then
        echo "Directory does not exist: $dir"
        return 1
    fi

    if [[ ${#windows[@]} -eq 0 ]]; then
        echo "At least one window name required"
        return 1
    fi

    if tmux has-session -t "$session_name" 2>/dev/null; then
        echo "Session '$session_name' already exists"
        return 1
    fi

    # Create session with first window
    local first_window="${windows[1]}"
    local first_cmd="${_TMUX_DEV_WINDOW_CMDS[$first_window]}"
    tmux new-session -d -s "$session_name" -n "$first_window" -c "$dir"
    [[ -n "$first_cmd" ]] && tmux send-keys -t "${session_name}:${first_window}" "$first_cmd" Enter

    # Create remaining windows
    local window cmd
    for window in "${windows[@]:1}"; do
        cmd="${_TMUX_DEV_WINDOW_CMDS[$window]}"
        tmux new-window -t "$session_name" -n "$window" -c "$dir"
        [[ -n "$cmd" ]] && tmux send-keys -t "${session_name}:${window}" "$cmd" Enter
    done

    # Select first window, then attach (outside tmux) or switch current client (inside)
    tmux select-window -t "${session_name}:${first_window}"
    if [[ -n "$TMUX" ]]; then
        tmux switch-client -t "$session_name"
    else
        tmux attach-session -t "$session_name"
    fi
}

# Preset: dotfiles development session
# Creates session with nvim, git, claude windows in ~/dotfiles
dev-dots() {
    _tmux_dev_create_session ~/dotfiles dotfiles nvim git claude
}

# Preset: work project session
# Prompts for directory selection from ~/code, creates full dev environment
dev-work() {
    for cmd in tmux fd fzf; do
        if ! command -v "$cmd" &>/dev/null; then
            echo "Required command not found: $cmd"
            return 1
        fi
    done

    if [[ ! -d ~/code ]]; then
        echo "Directory does not exist: ~/code"
        return 1
    fi

    local selected_dir
    selected_dir=$(fd --type d --max-depth 1 . ~/code | fzf --prompt="Select project: ")
    [[ -z "$selected_dir" ]] && { echo "No directory selected"; return 1; }

    local session_name
    session_name=$(basename "$selected_dir" | tr '.' '_')

    _tmux_dev_create_session "$selected_dir" "$session_name" nvim git cursor tests dagster
}

# Interactive: fully customizable session
# Prompts for directory and window selection
tmux_dev() {
    for cmd in tmux fd fzf; do
        if ! command -v "$cmd" &>/dev/null; then
            echo "Required command not found: $cmd"
            return 1
        fi
    done

    local selected_dir
    selected_dir=$(fd --type d --hidden --exclude .git . ~ | fzf --prompt="Select directory: ")
    [[ -z "$selected_dir" ]] && { echo "No directory selected"; return 1; }

    local extra_windows
    extra_windows=$(printf "claude\ncursor\ntests\ndagster" | fzf --multi --prompt="Extra windows (Tab to select): ")

    local session_name
    session_name=$(basename "$selected_dir" | tr '.' '_')

    # Build window list: nvim and git are always included
    local windows=(nvim git)
    [[ "$extra_windows" == *claude* ]] && windows+=(claude)
    [[ "$extra_windows" == *cursor* ]] && windows+=(cursor)
    [[ "$extra_windows" == *tests* ]] && windows+=(tests)
    [[ "$extra_windows" == *dagster* ]] && windows+=(dagster)

    _tmux_dev_create_session "$selected_dir" "$session_name" "${windows[@]}"
}
