#!/usr/bin/env bash
# ~/.config/tmux/scripts/status-pane-path.sh
# Prints a shortened pane path for the pane-border-format.
# Shows: repo/rel or ~/parent/dir, abbreviating ancestors.

path="${1:-$PWD}"

shorten() {
  local IFS='/' out="" parts last_i i=0 part
  read -ra parts <<< "$1"
  last_i=$(( ${#parts[@]} - 1 ))
  for part in "${parts[@]}"; do
    [[ -z "$part" ]] && (( i++ )) && continue
    if (( i < last_i - 1 )); then
      out+="${part:0:1}/"
    else
      out+="$part"
      (( i < last_i )) && out+="/"
    fi
    (( i++ ))
  done
  printf "%s" "$out"
}

home="${HOME}"
path="${path/#$home/\~}"

if git_root=$(git -C "$1" rev-parse --show-toplevel 2>/dev/null); then
  repo=$(basename "$git_root")
  rel="${1#$git_root}"
  rel="${rel#/}"
  if [[ -n "$rel" ]]; then
    printf " %s/%s" "$repo" "$(shorten "$rel")"
  else
    printf " %s" "$repo"
  fi
else
  printf " %s" "$path"
fi
