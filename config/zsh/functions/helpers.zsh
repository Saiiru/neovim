# functions/helpers.zsh – general-purpose shell helpers

# mkdir + cd
mkcd() { mkdir -p -- "$1" && cd -- "$1" }

# Smart archive extractor
extract() {
  local f="${1:-}"
  [[ -f "$f" ]] || { printf "extract: not a file: %s\n" "$f" >&2; return 1; }
  case "$f" in
    *.tar.bz2|*.tbz2) tar xjf "$f" ;;
    *.tar.gz|*.tgz)   tar xzf "$f" ;;
    *.tar.xz|*.txz)   tar xJf "$f" ;;
    *.tar.zst)         tar --use-compress-program=unzstd -xf "$f" ;;
    *.tar)             tar xf  "$f" ;;
    *.bz2)             bunzip2 "$f" ;;
    *.gz)              gunzip  "$f" ;;
    *.zip)             unzip   "$f" ;;
    *.7z)              7z x    "$f" ;;
    *.rar)             unrar x "$f" ;;
    *) printf "extract: unsupported format: %s\n" "$f" >&2; return 1 ;;
  esac
}

# Quick HTTP server in current dir
serve() { python3 -m http.server "${1:-8080}" }

# Print 256-color palette (debugging)
colortest() {
  for i in {0..255}; do
    printf "\033[38;5;%dm %3d\033[0m" "$i" "$i"
    (( (i+1) % 16 == 0 )) && echo
  done
}

# Copy file contents to clipboard
clip() {
  local file="${1:-/dev/stdin}"
  (command -v wl-copy &>/dev/null && wl-copy \
   || command -v xclip &>/dev/null && xclip -sel clip \
   || pbcopy) < "$file" \
  && printf "  copied to clipboard\n"
}

# Show disk usage of current dir, sorted
dsize() { du -sh -- "${1:-.}"/* 2>/dev/null | sort -h }

# Find process by name
pf() { ps aux | grep -i "$1" | grep -v grep }

# Pretty-print JSON (uses bat for highlighting)
json() { python3 -m json.tool | bat --language=json --paging=never }

# Open man page in nvim
man() { nvim +Man! "$@" 2>/dev/null || command man "$@" }
