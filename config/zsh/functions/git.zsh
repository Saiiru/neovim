# functions/git.zsh – git workflow helpers

# Switch branch with fzf
gbfzf() {
  local branch
  branch=$(git branch -a --color=always \
    | grep -v HEAD \
    | fzf --ansi --prompt="  branch › " \
          --preview 'git log --oneline --color=always {1}' \
          --preview-window='right:50%:wrap' \
    | sed 's|remotes/[^/]*/||;s/^[[:space:]]*//')
  [[ -n "$branch" ]] && git switch "$branch"
}

# Interactive rebase last N commits
grbn() {
  local n="${1:-5}"
  git rebase -i "HEAD~${n}"
}

# Show a pretty git log with file stat
gshow() {
  git log --oneline --decorate --color | \
    fzf --ansi --no-sort --prompt="  commit › " \
        --preview 'git show --stat --color {1}' \
        --preview-window='right:60%:wrap' \
    | awk '{print $1}' \
    | xargs -r git show --stat --color
}

# Delete merged branches (safe)
gbclean() {
  git branch --merged main 2>/dev/null \
    | grep -v '^\*\|main\|master\|develop' \
    | xargs -r git branch -d
  printf "  merged branches cleaned\n"
}

# Create and push new branch
gnew() {
  local name="${1:-}"
  [[ -z "$name" ]] && { printf "usage: gnew <branch-name>\n" >&2; return 1; }
  git switch -c "$name" && git push -u origin "$name"
}

# Undo last commit (keep changes staged)
gundo() { git reset --soft HEAD~1 }

# Quick commit everything with message
gall() {
  local msg="${*:-wip}"
  git add -A && git commit -m "$msg"
}
