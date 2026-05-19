#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
lists_root="$script_dir/package_lists"

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

read_package_file() {
  local file="$1"
  local packages=()

  [[ -f "$file" ]] || return 0

  while IFS= read -r package; do
    [[ -n "$package" ]] || continue
    [[ "$package" =~ ^[[:space:]]*# ]] && continue
    packages+=("$package")
  done < "$file"

  [[ "${#packages[@]}" -gt 0 ]] || return 0
  printf '%s\n' "${packages[@]}"
}

install_pacman_file() {
  local file="$1"
  mapfile -t packages < <(read_package_file "$file")
  [[ "${#packages[@]}" -gt 0 ]] || return 0

  say "$c_blue" "Installing pacman packages from $(basename "$file")"
  sudo pacman -S --noconfirm --needed "${packages[@]}"
  say "$c_green" "Done: $(basename "$file")"
}

install_aur_file() {
  local file="$1"
  mapfile -t packages < <(read_package_file "$file")
  [[ "${#packages[@]}" -gt 0 ]] || return 0

  if ! command -v yay >/dev/null 2>&1; then
    say "$c_yellow" "yay not installed, skipping AUR packages from $(basename "$file")"
    return 0
  fi

  say "$c_blue" "Installing AUR packages from $(basename "$file")"
  yay -S --noconfirm --needed "${packages[@]}"
  say "$c_green" "Done: $(basename "$file")"
}

install_flatpak_file() {
  local file="$1"
  mapfile -t packages < <(read_package_file "$file")
  [[ "${#packages[@]}" -gt 0 ]] || return 0

  if ! command -v flatpak >/dev/null 2>&1; then
    say "$c_yellow" "flatpak not installed, skipping flatpak packages from $(basename "$file")"
    return 0
  fi

  flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo || true
  say "$c_blue" "Installing flatpak packages from $(basename "$file")"
  flatpak install -y flathub "${packages[@]}"
  say "$c_green" "Done: $(basename "$file")"
}

case "$(uname -s)" in
  Linux)
    install_pacman_file "$lists_root/linux/common.txt"
    install_pacman_file "$lists_root/linux/dev.txt"
    install_pacman_file "$lists_root/linux/gui.txt"
    install_pacman_file "$lists_root/linux/wayland.txt"
    install_pacman_file "$lists_root/linux/amd.txt"
    install_aur_file "$lists_root/linux/aur.txt"
    install_flatpak_file "$lists_root/linux/flatpak.txt"
    ;;
  Darwin)
    if [[ -f "$lists_root/macos/brew.txt" ]]; then
      say "$c_yellow" "macOS package bootstrap is not implemented yet. Review $lists_root/macos/brew.txt."
    else
      say "$c_yellow" "No macOS package list defined."
    fi
    ;;
  *)
    say "$c_yellow" "Unsupported OS for package bootstrap: $(uname -s)"
    ;;
esac
