#!/usr/bin/env bash
set -euo pipefail

script_path="$(readlink -f "${BASH_SOURCE[0]}")"

list_entries() {
  tmux list-sessions -F '#S' \
    | grep -v '^_popup_' \
    | while read -r session; do
        printf '%s\tSESSION\t▼ %s\n' "$session" "$session"
        tmux list-windows -t "$session" -F '#S\tWINDOW\t  ⦿ #I #W'
      done
}

kill_session() {
  local session="$1"
  [[ -n "$session" ]] || exit 0

  if [[ "$(tmux display-message -p '#S' 2>/dev/null || true)" == "$session" ]]; then
    tmux switch-client -l >/dev/null 2>&1 || true
  fi

  tmux kill-session -t "$session"
}

case "${1:-}" in
  --list)
    list_entries
    exit 0
    ;;
  --kill)
    kill_session "${2:-}"
    exit 0
    ;;
esac

selection="$(
  "$script_path" --list \
    | fzf \
        --reverse \
        --delimiter=$'\t' \
        --with-nth=3 \
        --header='enter switch | alt-x kill session | ctrl-r refresh' \
        --bind "alt-x:execute-silent($script_path --kill {1})+reload($script_path --list)" \
        --bind "ctrl-r:reload($script_path --list)"
)"

[[ -n "${selection:-}" ]] || exit 0
tmux switch-client -t "${selection%%$'\t'*}"
