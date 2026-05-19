#!/usr/bin/env bash
set -euo pipefail

source_fonts_dir="${DOTFILES_FONT_DIR:-$HOME/.local/share/dotfiles/fonts}"
user_fonts_dir="$HOME/.local/share/fonts/dotfiles"

if [[ -t 1 && -z "${NO_COLOR:-}" ]]; then
  c_reset=$'\033[0m'
  c_blue=$'\033[1;34m'
  c_green=$'\033[1;32m'
  c_yellow=$'\033[1;33m'
else
  c_reset=''
  c_blue=''
  c_green=''
  c_yellow=''
fi

say() {
  printf '%s==>%s %s\n' "$1" "$c_reset" "$2"
}

if [[ ! -d "$source_fonts_dir" ]]; then
  say "$c_yellow" "No local dotfiles font directory; skipping custom fonts"
  exit 0
fi

say "$c_blue" "Installing curated local fonts from $source_fonts_dir"
mkdir -p "$user_fonts_dir"

find "$source_fonts_dir" -type f \
  \( -iname "*.ttf" -o -iname "*.otf" \) \
  ! -name "._*" \
  -print0 \
  | while IFS= read -r -d '' font_file; do
      rel_path="${font_file#"$source_fonts_dir"/}"
      dest_path="$user_fonts_dir/$rel_path"
      mkdir -p "$(dirname "$dest_path")"
      cp -f "$font_file" "$dest_path"
    done

fc-cache -f "$user_fonts_dir" >/dev/null 2>&1 || fc-cache -f >/dev/null 2>&1
say "$c_green" "Custom fonts installed"
