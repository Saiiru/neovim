#!/usr/bin/env bash
set -euo pipefail

# Prepare arduino-cli for the local Neovim Arduino pipeline.
# This does not upload firmware and does not touch project files.

esp32_index_url="${ESP32_ARDUINO_INDEX_URL:-https://espressif.github.io/arduino-esp32/package_esp32_index.json}"

if [[ -t 1 && -z "${NO_COLOR:-}" ]]; then
  c_reset=$'\033[0m'
  c_blue=$'\033[1;34m'
  c_green=$'\033[1;32m'
  c_yellow=$'\033[1;33m'
  c_red=$'\033[1;31m'
else
  c_reset=''
  c_blue=''
  c_green=''
  c_yellow=''
  c_red=''
fi

say() {
  printf '%s==>%s %s\n' "$1" "$c_reset" "$2"
}

need() {
  local bin="$1"
  if ! command -v "$bin" >/dev/null 2>&1; then
    say "$c_red" "missing executable: $bin"
    return 1
  fi
}

usage() {
  cat <<'USAGE'
Setup arduino-cli for Uno + ESP32.

Usage:
  bash install/setup_arduino_cli.sh
  bash install/setup_arduino_cli.sh --avr-only
  bash install/setup_arduino_cli.sh --esp32-only

Requires:
  arduino-cli
  clangd
  arduino-language-server, installed by Mason or Go

This script installs Arduino CLI cores:
  arduino:avr
  esp32:esp32
USAGE
}

install_avr=1
install_esp32=1

while [[ $# -gt 0 ]]; do
  case "$1" in
    -h|--help)
      usage
      exit 0
      ;;
    --avr-only)
      install_avr=1
      install_esp32=0
      ;;
    --esp32-only)
      install_avr=0
      install_esp32=1
      ;;
    *)
      say "$c_red" "unknown argument: $1"
      usage
      exit 2
      ;;
  esac
  shift
done

need arduino-cli

if ! command -v clangd >/dev/null 2>&1; then
  say "$c_yellow" "clangd not found. Install clang or let Mason provide clangd."
fi

if ! command -v arduino-language-server >/dev/null 2>&1; then
  say "$c_yellow" "arduino-language-server not found in PATH. Mason can still provide it inside Neovim."
fi

say "$c_blue" "initializing arduino-cli config"
arduino-cli config init || true

if [[ "$install_esp32" == "1" ]]; then
  say "$c_blue" "adding ESP32 board manager index"
  arduino-cli config add board_manager.additional_urls "$esp32_index_url" \
    || arduino-cli config set board_manager.additional_urls "$esp32_index_url"
fi

say "$c_blue" "updating core index"
arduino-cli core update-index

if [[ "$install_avr" == "1" ]]; then
  say "$c_blue" "installing Arduino AVR core"
  arduino-cli core install arduino:avr
fi

if [[ "$install_esp32" == "1" ]]; then
  say "$c_blue" "installing ESP32 core"
  arduino-cli core install esp32:esp32
fi

say "$c_blue" "installed cores"
arduino-cli core list || true

say "$c_blue" "detected boards"
arduino-cli board list || true

say "$c_green" "arduino-cli setup finished"
