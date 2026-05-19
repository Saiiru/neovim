#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
repo_root="$(cd "$script_dir/.." && pwd)"
target_root="${XDG_CONFIG_HOME:-$HOME/.config}"
backup_root="$HOME/.config.backup/$(date +"%Y%m%d_%H-%M-%S")"

if [[ -t 1 && -z "${NO_COLOR:-}" ]]; then
  c_reset=$'\033[0m'
  c_blue=$'\033[1;34m'
  c_green=$'\033[1;32m'
else
  c_reset=''
  c_blue=''
  c_green=''
fi

case "$(uname -s)" in
Linux) platform="linux" ;;
Darwin) platform="macos" ;;
*) platform="" ;;
esac

mkdir -p "$target_root" "$backup_root"

backup_target() {
  local target="$1"
  local relative="$2"

  if [[ -L "$target" ]]; then
    local current
    current="$(readlink -f "$target" 2>/dev/null || true)"
    if [[ "$current" == "$repo_root"* ]]; then
      rm -f "$target"
      return 0
    fi
    mkdir -p "$(dirname "$backup_root/$relative")"
    mv "$target" "$backup_root/$relative"
    return 0
  fi

  if [[ -e "$target" ]]; then
    mkdir -p "$(dirname "$backup_root/$relative")"
    mv "$target" "$backup_root/$relative"
  fi
}

link_config_entries() {
  local source_root="$1"
  local type="$2"
  [[ -d "$source_root" ]] || return 0

  printf '%s==>%s Processing %s configurations\n' "$c_blue" "$c_reset" "$type"

  shopt -s dotglob nullglob
  for source_path in "$source_root"/* "$source_root"/.*; do
    [[ -e "$source_path" || -L "$source_path" ]] || continue

    local name target_path
    name="$(basename "$source_path")"
    target_path="$target_root/$name"

    # Skip meta entries.
    if [[ "$name" == "." || "$name" == ".." || "$name" == ".git" ]]; then
      continue
    fi

    # Never manage reserved app dirs from config roots.
    if [[ "$name" == "Code - Insiders" ]]; then
      continue
    fi

    printf '   %s linking %s/%s\n' "$c_green" "$type" "$name"
    backup_target "$target_path" "$name"
    ln -sfn "$source_path" "$target_path"
  done
  shopt -u dotglob nullglob
}

link_config_entries "$repo_root/config" "active"

printf '%s==>%s %s\n' "$c_green" "$c_reset" "Config directories linked"
