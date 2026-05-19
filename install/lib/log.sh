#!/usr/bin/env bash
# Installer Logging Library (KORA-03)

# ── Colors ───────────────────────────────────────────────────────────────────
CLR_RESET='\033[0m'
CLR_RED='\033[0;31m'
CLR_GREEN='\033[0;32m'
CLR_YELLOW='\033[0;33m'
CLR_BLUE='\033[0;34m'
CLR_DIM='\033[0;2m'

log_info()    { echo -e "${CLR_BLUE}[INFO]${CLR_RESET} $1"; }
log_success() { echo -e "${CLR_GREEN}[PASS]${CLR_RESET} $1"; }
log_warn()    { echo -e "${CLR_YELLOW}[WARN]${CLR_RESET} $1"; }
log_error()   { echo -e "${CLR_RED}[FAIL]${CLR_RESET} $1" >&2; }
log_step()    { echo -e "\n${CLR_BLUE}──${CLR_RESET} $1 ${CLR_BLUE}$(printf '─%.0s' $(seq 1 $(( $(tput cols) - ${#1} - 5 ))))${CLR_RESET}"; }
log_dry()     { echo -e "${CLR_DIM}[DRY]${CLR_RESET} $1"; }
