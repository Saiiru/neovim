#!/usr/bin/env bash
set -euo pipefail

dir_of_this_script="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
mode="${1:-default}"

case "$mode" in
  -h|--help|help)
    cat <<'USAGE'
Dotfiles installer

Usage:
  bash install/install.sh
  bash install/install.sh default
  bash install/install.sh arcane-niri [options...]

Modes:
  default       Legacy direct installer: packages, fonts, symlinks, mise, services, app sync.
  arcane-niri   Auditable Arcane Niri Workstation orchestrator. Dry-run by default.

Examples:
  bash install/install.sh arcane-niri --list-groups
  bash install/install.sh arcane-niri --audit-local --rollback-plan
  bash install/install.sh arcane-niri --apply --install-group workstation-qol
USAGE
    exit 0
    ;;
  arcane-niri|workstation)
    shift
    exec bash "$dir_of_this_script/profiles/arcane_niri_workstation.sh" "$@"
    ;;
  default)
    [[ $# -gt 0 ]] && shift
    ;;
  -*)
    exec bash "$dir_of_this_script/profiles/arcane_niri_workstation.sh" "$@"
    ;;
esac

if [[ -t 1 && -z "${NO_COLOR:-}" ]]; then
  c_reset=$'\033[0m'
  c_magenta=$'\033[1;35m'
  c_blue=$'\033[1;34m'
  c_green=$'\033[1;32m'
  c_yellow=$'\033[1;33m'
else
  c_reset=''
  c_magenta=''
  c_blue=''
  c_green=''
  c_yellow=''
fi

banner() {
  printf '\n%s%s%s\n' "$c_magenta" "== dotfiles install ==" "$c_reset"
}

step() {
  printf '%s-->%s %s\n' "$c_blue" "$c_reset" "$1"
}

run_script_if_exists() {
  local script="$1"
  local script_path="$dir_of_this_script/$script"

  if [[ -f "$script_path" ]]; then
    step "$script"
    bash "$script_path"
  else
    printf '%s-->%s skipped %s\n' "$c_yellow" "$c_reset" "$script"
  fi
}

banner
run_script_if_exists "package_install.sh"
run_script_if_exists "install_custom_fonts.sh"
run_script_if_exists "symlink_configs.sh"
run_script_if_exists "symlink_files.sh"
run_script_if_exists "configure_mise.sh"

if [[ "$(uname -s)" == "Linux" ]]; then
  run_script_if_exists "enable_services.sh"
fi

# ── Post-install Sync ─────────────────────────────────────────────────────────

if command -v nvim &>/dev/null; then
  step "Syncing Neovim plugins (Lazy)..."
  nvim --headless "+Lazy! sync" +qa
fi

if [[ -f "$HOME/.tmux/plugins/tpm/tpm" ]]; then
  step "Installing Tmux plugins (TPM)..."
  # This runs TPM's install script non-interactively
  ~/.tmux/plugins/tpm/bin/install_plugins >/dev/null 2>&1 || true
fi

printf '\n%s-->%s %s\n' "$c_green" "$c_reset" "install flow finished"
