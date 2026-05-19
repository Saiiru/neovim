#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
repo_root="$(cd "$script_dir/.." && pwd)"
backup_root="$HOME/.dotfiles.backup/$(date +"%Y%m%d_%H-%M-%S")"
bin_source_root="$repo_root/.local/bin"
bin_target_root="$HOME/.local/bin"
share_source_root="$repo_root/.local/share"
share_target_root="$HOME/.local/share"
config_target_root="${XDG_CONFIG_HOME:-$HOME/.config}"
home_source_root="$repo_root/home"

mkdir -p "$backup_root" "$bin_target_root" "$share_target_root"

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

link_config_file() {
  local target_name="$1"
  local source="$2"
  local target="$config_target_root/$target_name"

  [[ -e "$source" || -L "$source" ]] || return 0
  printf '%s==>%s %s\n' "$c_blue" "$c_reset" "Linking $target_name"
  backup_target "$target" ".config/$target_name"
  ln -sfn "$source" "$target"
}

prune_broken_legacy_link() {
  local target="$1"

  if [[ -L "$target" && ! -e "$target" ]]; then
    printf '%s==>%s %s\n' "$c_yellow" "$c_reset" "Removing broken legacy link $target"
    rm -f "$target"
  fi
}

# Optional direct file links in ~/.config (kept for tools expecting flat paths).
link_config_file "starship.toml" "$repo_root/config/starship/starship.toml"
link_config_file "mimeapps.list" "$repo_root/config/xdg/mimeapps.list"

if [[ -d "$bin_source_root" ]]; then
  while IFS= read -r -d '' source_path; do
    relative="${source_path#"$bin_source_root"/}"
    target_path="$bin_target_root/$relative"

    mkdir -p "$(dirname "$target_path")"
    backup_target "$target_path" ".local/bin/$relative"
    ln -sfn "$source_path" "$target_path"
  done < <(find "$bin_source_root" -type f -print0)
fi

if [[ -d "$share_source_root" ]]; then
  while IFS= read -r -d '' source_path; do
    relative="${source_path#"$share_source_root"/}"
    target_path="$share_target_root/$relative"

    mkdir -p "$(dirname "$target_path")"
    backup_target "$target_path" ".local/share/$relative"
    ln -sfn "$source_path" "$target_path"
  done < <(find "$share_source_root" -type f -print0)
fi

# Optional home mirroring: anything under repo/home is linked to $HOME.
# Example:
#   repo/home/.zshenv -> ~/.zshenv
if [[ -d "$home_source_root" ]]; then
  while IFS= read -r -d '' source_path; do
    relative="${source_path#"$home_source_root"/}"
    target_path="$HOME/$relative"
    mkdir -p "$(dirname "$target_path")"
    backup_target "$target_path" "$relative"
    ln -sfn "$source_path" "$target_path"
  done < <(find "$home_source_root" -mindepth 1 -type f -print0)
fi

printf '%s==>%s %s\n' "$c_green" "$c_reset" "Files and executables linked"
