#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")" && pwd)"
source "$SCRIPT_DIR/tmux-common.sh"

case "${1:-}" in
  lazygit)
    tmux_popup_or_kitty "Lazygit" "lazygit"
    ;;
  yazi)
    tmux_popup_or_kitty "Yazi" "yazi"
    ;;
  btop)
    tmux_popup_or_kitty "Btop" "btop"
    ;;
  nmtui)
    tmux_popup_or_kitty "Nmtui" "nmtui" "80%" "80%"
    ;;
  sesh-picker)
    exec "$SCRIPT_DIR/tmux-session-actions.sh" --inline
    ;;
  *)
    printf 'usage: %s [lazygit|yazi|btop|nmtui|sesh-picker]\n' "$0" >&2
    exit 1
  ;;
esac
