#!/usr/bin/env bash
# ~/.config/tmux/scripts/status-session.sh
# Prints only the current tmux session name.
#
# Keep this deliberately boring: the window list already shows window context,
# and adding session counts here reads like a second session switcher.

session=$(tmux display-message -p '#S' 2>/dev/null)

printf "%s" "$session"
