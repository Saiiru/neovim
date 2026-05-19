#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")" && pwd)"
source "$SCRIPT_DIR/tmux-common.sh"

sesh_cmd() {
  sesh -C "$repo_root/config/sesh/sesh.toml" "$@"
}

open_fzf_picker() {
  command -v sesh >/dev/null 2>&1 || {
    notify_missing "sesh" "tmux session actions"
    exit 1
  }
  command -v fzf-tmux >/dev/null 2>&1 || {
    notify_missing "fzf-tmux" "tmux session actions"
    exit 1
  }

  local selection
  selection="$(
    sesh_cmd list -t -c -d -i | fzf-tmux -p 80%,70% \
      --no-sort --ansi --border-label=' sesh ' --prompt='󰭟  ' \
      --header='  ^a all  ^t tmux  ^g configs  ^x zoxide  ^f find  ^d kill' \
      --bind 'tab:down,btab:up' \
      --bind "ctrl-a:change-prompt(󰭟  )+reload(sesh -C \"$repo_root/config/sesh/sesh.toml\" list -d -i)" \
      --bind "ctrl-t:change-prompt(  )+reload(sesh -C \"$repo_root/config/sesh/sesh.toml\" list -t -d -i)" \
      --bind "ctrl-g:change-prompt(  )+reload(sesh -C \"$repo_root/config/sesh/sesh.toml\" list -c -d -i)" \
      --bind "ctrl-x:change-prompt(  )+reload(sesh -C \"$repo_root/config/sesh/sesh.toml\" list -z -i)" \
      --bind "ctrl-f:change-prompt(󰱼  )+reload(fd -H -d 3 -t d -E .git -E node_modules -E .Trash . \"$HOME\")" \
      --bind "ctrl-d:execute-silent(tmux kill-session -t {2..} >/dev/null 2>&1)+change-prompt(󰭟  )+reload(sesh -C \"$repo_root/config/sesh/sesh.toml\" list -d -i)" \
      --preview-window 'right:55%' \
      --preview 'sesh -C \"$repo_root/config/sesh/sesh.toml\" preview {}' \
  )"

  [[ -z "${selection:-}" ]] && exit 0
  sesh_cmd connect "$selection"
}

open_picker() {
  open_fzf_picker
}

case "${1:-picker}" in
  picker|--inline)
    if [[ "${1:-picker}" == "--inline" ]]; then
      open_picker
    fi
    exec "$SCRIPT_DIR/tmux-popup-actions.sh" sesh-picker
    ;;
  last)
    if [[ -n "${TMUX:-}" ]]; then
      exec sesh last
    fi
    open_kitty_tool "Sesh Last" "sesh last" "float_tmux_tool"
    ;;
  root)
    if [[ -n "${TMUX:-}" ]]; then
      exec sesh root
    fi
    open_kitty_tool "Session Root" "printf \"%s\n\" \"\$(sesh root 2>/dev/null || pwd)\"; printf \"\nPress enter to close...\"; read" "float_tmux_tool"
    ;;
  *)
    printf 'usage: %s [picker|last|root|--inline]\n' "$0" >&2
    exit 1
    ;;
esac
