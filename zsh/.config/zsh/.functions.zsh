# fzf_dirs_and_cd [start_dir, depth]
#
# Wrapper around `fd` and `fzf` to list directories in start_dir, excluding
# `.git`, and cd into selected directory. If `depth` is provided, limits search
# depth.
#
#
# Examples:
#   fzf_dirs_and_cd $HOME   # list all dirs in $HOME and cd
#   fzf_dirs_and_cd $HOME 1 # list top-level dirs in $HOME and cd

fzf_dirs_and_cd() {
  local start_dir=$1
  local depth=$2
  local args=()
  local d

  [[ -n "$depth" ]] && args+=(--max-depth "$depth")
  dirs=$(fd -t d -t l --exclude .git "${args[@]}" . "${start_dir:-}")
  d="$(echo ${dirs} | fzf)" && cd "${d}"
}

# # Open tmux session in directory using fzf
# fuzzy_tmux() {
#   fuzzy_find_dirs || return
#   local dir="$PWD"
#
#   read -r "session_name?Enter tmux session name: " || return
#   [[ -z "$session_name" ]] && echo "Session name required." && return
#
#   if tmux has-session -t "$session_name" 2>/dev/null; then
#     # Attach if session already exists
#     tmux attach-session -t "$session_name"
#   else
#     # Open nvim + scratch terminal if new session
#     tmux new-session -s "$session_name"
#     tmux new-window -dn scratch
#     nvim
#   fi
# }
