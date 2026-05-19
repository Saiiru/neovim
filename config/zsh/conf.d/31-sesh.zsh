if command -v sesh >/dev/null 2>&1 && command -v fzf >/dev/null 2>&1; then
  ss() {
    local session
    session="$(sesh list --icons | fzf --ansi --no-sort --prompt='session › ')" || return
    sesh connect "$session"
  }

  sst() {
    local session
    session="$(sesh list -t --icons | fzf --ansi --no-sort --prompt='tmux › ')" || return
    sesh connect "$session"
  }
fi
