# conf.d/50-workflow.zsh – terminal workflow: tmux autostart, sesh, fzf pickers

# ── fzf pickers ───────────────────────────────────────────────────────────────

# ripgrep → fzf → nvim  (fuzzy search file contents)
function rgfzf() {
  local query="${*:-}"
  rg --color=always --line-number --no-heading "$query" \
    | fzf --ansi \
          --delimiter=':' \
          --preview 'bat --style=numbers --color=always --highlight-line={2} {1}' \
          --preview-window 'right:60%:wrap' \
          --prompt="  rg › " \
    | awk -F: '{print $1 " +" $2}' \
    | xargs -r nvim
}

# fd → fzf → nvim  (fuzzy open file)
function fopen() {
  local file
  file=$(fd --hidden --exclude .git \
    | fzf --prompt="  open › " \
          --preview 'bat --style=numbers --color=always {}' \
          --preview-window='right:60%:wrap')
  [[ -n "$file" ]] && nvim "$file"
}

# cd → fzf  (fuzzy directory jump)
function fcd() {
  local dir
  dir=$(fd --type d --hidden --exclude .git \
    | fzf --prompt="  cd › " \
          --preview 'eza --tree --level=1 --icons {}')
  [[ -n "$dir" ]] && cd "$dir"
}

# ── error handler ─────────────────────────────────────────────────────────────
command_not_found_handler() {
  printf "\033[0;31mzsh:\033[0m command not found: %s\n" "$1" >&2
  return 127
}
