#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
repo_root="$(cd "$script_dir/.." && pwd)"
mise_config="$repo_root/config/mise/config.toml"
global_mise_dir="${XDG_CONFIG_HOME:-$HOME/.config}/mise"
global_mise_config="$global_mise_dir/config.toml"

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

if ! command -v mise >/dev/null 2>&1; then
  printf '%s==>%s %s\n' "$c_yellow" "$c_reset" "mise not installed, skipping mise setup"
  exit 0
fi

if [[ ! -f "$mise_config" ]]; then
  printf '%s==>%s %s\n' "$c_yellow" "$c_reset" "mise config not found, skipping trust step"
  exit 0
fi

mkdir -p "$global_mise_dir"

if [[ ! -e "$global_mise_config" && ! -L "$global_mise_config" ]]; then
  printf '%s==>%s %s\n' "$c_blue" "$c_reset" "Linking mise config"
  ln -s "$mise_config" "$global_mise_config"
elif [[ "$(readlink -f "$global_mise_config" 2>/dev/null || true)" == "$mise_config" ]]; then
  printf '%s==>%s %s\n' "$c_green" "$c_reset" "mise config connected"
else
  printf '%s==>%s %s\n' "$c_yellow" "$c_reset" "Existing mise config kept: $global_mise_config"
fi

printf '%s==>%s %s\n' "$c_blue" "$c_reset" "Trusting mise config"
mise trust -y "$mise_config" >/dev/null
printf '%s==>%s %s\n' "$c_green" "$c_reset" "mise config trusted"

printf '%s==>%s %s\n' "$c_blue" "$c_reset" "Installing tools from mise config"
if ! mise install -y; then
  printf '%s==>%s %s\n' "$c_yellow" "$c_reset" "mise install failed. Run: MISE_VERBOSE=1 mise install"
  exit 1
fi

printf '%s==>%s %s\n' "$c_blue" "$c_reset" "Refreshing mise shims"
mise reshim >/dev/null || true

printf '%s==>%s %s\n' "$c_green" "$c_reset" "mise tools installed"
