#!/usr/bin/env bash
# Common Operational Library (KORA-03)
# Shared functions for scripts in bin/

# ── Colors & UI ──────────────────────────────────────────────────────────────
export CLR_RESET='\033[0m'
export CLR_RED='\033[0;31m'
export CLR_GREEN='\033[0;32m'
export CLR_YELLOW='\033[0;33m'
export CLR_BLUE='\033[0;34m'
export CLR_PURPLE='\033[0;35m'
export CLR_CYAN='\033[0;36m'

arcane_log() {
    local level="$1"
    local msg="$2"
    case "$level" in
        "info")  echo -e "${CLR_BLUE}[INFO]${CLR_RESET} $msg" ;;
        "success") echo -e "${CLR_GREEN}[OK]${CLR_RESET} $msg" ;;
        "warn")  echo -e "${CLR_YELLOW}[WARN]${CLR_RESET} $msg" ;;
        "error") echo -e "${CLR_RED}[ERR]${CLR_RESET} $msg" >&2 ;;
    esac
}

arcane_notify() {
    local title="$1"
    local msg="$2"
    local urgency="${3:-normal}"
    if command -v notify-send >/dev/null; then
        notify-send -u "$urgency" -a "ArcaneOS" "$title" "$msg"
    else
        arcane_log "info" "Notification: $title - $msg"
    fi
}

# ── Environment & Checks ─────────────────────────────────────────────────────
check_dep() {
    if ! command -v "$1" >/dev/null 2>&1; then
        arcane_log "error" "Missing dependency: $1"
        return 1
    fi
}

is_wayland() {
    [[ "$XDG_SESSION_TYPE" == "wayland" ]]
}

is_niri() {
    [[ -n "${NIRI_SOCKET:-}" ]]
}

# ── Niri Helpers ─────────────────────────────────────────────────────────────
niri_msg() {
    if ! is_niri; then
        arcane_log "error" "Niri socket not found."
        return 1
    fi
    niri msg "$@"
}

niri_get_focused_window() {
    niri_msg --json windows | jq -r '.[] | select(.is_focused == true)'
}
