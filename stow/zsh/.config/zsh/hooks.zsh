# [[ Auto-activate Python virtual environment ]]
# Modified from https://www.youtube.com/watch?v=3fVAtaGhUyU&t=301s

chpwd () {
  # Searches current and parent directories for .venv/bin/activate
  local dir="$PWD"
  local venv_path=""

  while [[ "$dir" != "/" ]]; do
    if [[ -f "$dir/.venv/bin/activate" ]]; then
      venv_path="$dir/.venv"
      break
    fi
    dir="$(dirname "$dir")"
  done

  # Activate venv if found and different from current one
  # If no venv found, deactivate current venv
  if [[ -n "$venv_path" && "$VIRTUAL_ENV" != "$venv_path" ]]; then
    if [[ -n "$VIRTUAL_ENV" ]]; then
      deactivate
    fi
    source "$venv_path/bin/activate"
  elif [[ -z "$venv_path" && -n "$VIRTUAL_ENV" ]]; then
    deactivate
  fi
}
