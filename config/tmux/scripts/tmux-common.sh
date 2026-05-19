#!/usr/bin/env bash

set -euo pipefail

resolve_repo_root() {
  local script_path script_dir
  script_path="$(readlink -f "${BASH_SOURCE[0]}")"
  script_dir="$(cd "$(dirname "$script_path")" && pwd)"

  git -C "$script_dir" rev-parse --show-toplevel 2>/dev/null \
    || (cd "$script_dir/../.." && pwd)
}

repo_root="${DOTFILES_DIR:-$(resolve_repo_root)}"

notify_info() {
  local title="$1"
  local message="$2"

  if command -v notify-send >/dev/null 2>&1; then
    notify-send "$title" "$message"
  else
    printf '%s: %s\n' "$title" "$message" >&2
  fi
}

notify_missing() {
  local package_name="$1"
  local title="${2:-tmux actions}"

  notify_info "$title" "$package_name is not installed"
}

open_kitty_tool() {
  local title="$1"
  local command="$2"
  local class_name="${3:-float_tmux_tool}"

  if ! command -v kitty >/dev/null 2>&1; then
    notify_missing "kitty"
    exit 1
  fi

  exec kitty --class "$class_name" --title "$title" zsh -lc "$command"
}

tmux_popup_or_kitty() {
  local title="$1"
  local command="$2"
  local width="${3:-90%}"
  local height="${4:-90%}"
  local class_name="${5:-float_tmux_tool}"

  if [[ -n "${TMUX:-}" ]] && command -v tmux >/dev/null 2>&1; then
    exec tmux display-popup -E -T "$title" -w "$width" -h "$height" -d "#{pane_current_path}" "zsh -lc '$command'"
  fi

  open_kitty_tool "$title" "$command" "$class_name"
}
