#!/usr/bin/env bash
set -euo pipefail

if [[ -t 1 && -z "${NO_COLOR:-}" ]]; then
  c_reset=$'\033[0m'
  c_blue=$'\033[1;34m'
  c_green=$'\033[1;32m'
else
  c_reset=''
  c_blue=''
  c_green=''
fi

system_services=(
  NetworkManager
)

user_services=(
  pipewire.socket
  pipewire-pulse.socket
  wireplumber.service
)

enable_system_service() {
  for service in "$@"; do
    if systemctl is-enabled --quiet "$service" 2>/dev/null; then
      printf '%s==>%s %s\n' "$c_blue" "$c_reset" "$service already enabled"
    else
      printf '%s==>%s %s\n' "$c_blue" "$c_reset" "Enabling $service"
      sudo systemctl enable "$service" || true
    fi
  done
}

enable_user_service() {
  for service in "$@"; do
    if systemctl --user is-enabled --quiet "$service" 2>/dev/null; then
      printf '%s==>%s %s\n' "$c_blue" "$c_reset" "$service already enabled"
    else
      printf '%s==>%s %s\n' "$c_blue" "$c_reset" "Enabling $service"
      systemctl --user enable "$service" || true
    fi
  done
}

enable_system_service "${system_services[@]}"
enable_user_service "${user_services[@]}"

printf '%s==>%s %s\n' "$c_green" "$c_reset" "All services processed"
