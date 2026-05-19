#!/usr/bin/env bash
set -euo pipefail

# Arcane Niri Workstation reinstall orchestrator.
#
# Goal:
#   Use Omarchy and Garuda Dr460nized as references while keeping this repo as
#   the source of truth for packages, Niri, AMD/RADV, shells, and
#   application configs.
#
# Safety:
#   Dry-run by default. Any system-changing phase requires --apply.
#   This script never runs the upstream Omarchy curl/wget installer.

workflow_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
install_dir="$(cd "$workflow_dir/.." && pwd)"
repo_root="$(cd "$install_dir/.." && pwd)"
# shellcheck disable=SC1091
source "$install_dir/lib/hardware.sh"
cache_root="${XDG_CACHE_HOME:-$HOME/.cache}/arcane-reinstall"
reference_root="$cache_root/references"
report_root="$cache_root/reports"
backup_root="$cache_root/backups"
package_list_root="$install_dir/packages"

omarchy_repo="${OMARCHY_REPO:-https://github.com/basecamp/omarchy.git}"
dr460nized_settings_repo="${DR460NIZED_SETTINGS_REPO:-https://gitlab.com/garuda-linux/themes-and-settings/settings/garuda-dr460nized.git}"
garuda_iso_profiles_repo="${GARUDA_ISO_PROFILES_REPO:-https://gitlab.com/garuda-linux/tools/iso-profiles.git}"
jakoolit_arch_hyprland_repo="${JAKOOLIT_ARCH_HYPRLAND_REPO:-https://github.com/JaKooLit/Arch-Hyprland.git}"

apply=0
fetch_references=0
audit_references=0
install_packages=0
install_fonts=0
link_configs=0
link_files=0
configure_mise=0
enable_services=0
sync_apps=0
audit_local=0
write_report=0
make_backup=0
rollback_plan=0
print_credits=0
list_groups=0
hardware_report=0
install_driver_group=""
install_groups=()
service_groups=()

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

usage() {
  cat <<'USAGE'
Arcane Niri Workstation reinstall orchestrator

Default:
  Dry-run plan. Nothing is installed, linked, cloned, enabled, or synced.

Read-only/reference modes:
  --fetch-references      Clone/update upstream reference repos into ~/.cache/arcane-reinstall/references.
  --audit-references      Produce file/package reports from fetched references.
  --audit-upstream        Alias for --audit-references.
  --audit-local           Audit local package lists for duplicates and group inventory.
  --hardware-report       Print and write GPU/driver recommendation report.
  --references            Same as --fetch-references --audit-references.
  --report                Write install, service, package, and license boundary reports.
  --credits               Print upstream credits and source boundary.
  --list-groups           Print package groups and service groups.

System-changing phases:
  --apply                 Required before any local install/link/service/sync action.
  --install-packages      Run install/package_install.sh.
  --install-group NAME    Install a specific audited package group.
  --install-driver-group NAME|auto
                          Install an explicit or auto-detected GPU package group.
  --install-fonts         Run install/install_custom_fonts.sh.
  --link-configs          Run install/symlink_configs.sh.
  --link-files            Run install/symlink_files.sh.
  --configure-mise        Run install/configure_mise.sh.
  --enable-services       Run install/enable_services.sh.
  --enable-service-group NAME
                          Enable a specific service group.
  --backup                Snapshot selected live config paths before applying.
  --rollback-plan         Print and write manual rollback notes for backups/symlinks/services.
  --sync-apps             Sync Neovim Lazy plugins and Tmux TPM plugins.
  --core                  Packages, fonts, config links, file links, mise, services.
  --all                   References, audit, core, app sync. Requires --apply for system phases.

Examples:
  bash install/install.sh arcane-niri
  bash install/install.sh arcane-niri --references
  bash install/install.sh arcane-niri --list-groups
  bash install/install.sh arcane-niri --audit-local --report
  bash install/install.sh arcane-niri --hardware-report
  bash install/install.sh arcane-niri --apply --install-driver-group auto
  bash install/install.sh arcane-niri --apply --install-group workstation-qol
  bash install/install.sh arcane-niri --apply --enable-service-group bluetooth
  bash install/install.sh arcane-niri --apply --core
  bash install/install.sh arcane-niri --apply --install-packages --link-configs --link-files

Policy:
  This script does not run: curl -fsSL https://omarchy.org/install | bash
  Upstream projects are references; this repo remains the source of truth.
USAGE
}

parse_args() {
  while [[ $# -gt 0 ]]; do
    case "$1" in
      -h|--help)
        usage
        exit 0
        ;;
      --apply)
        apply=1
        ;;
      --fetch-references)
        fetch_references=1
        ;;
      --audit-references)
        audit_references=1
        ;;
      --audit-upstream)
        audit_references=1
        ;;
      --audit-local)
        audit_local=1
        ;;
      --hardware-report)
        hardware_report=1
        ;;
      --references)
        fetch_references=1
        audit_references=1
        ;;
      --report)
        write_report=1
        ;;
      --credits)
        print_credits=1
        ;;
      --list-groups)
        list_groups=1
        ;;
      --install-group)
        if [[ -z "${2:-}" ]]; then
          say "$c_red" "--install-group requires a name"
          exit 2
        fi
        install_groups+=("$2")
        shift
        ;;
      --install-driver-group)
        if [[ -z "${2:-}" ]]; then
          say "$c_red" "--install-driver-group requires a name or auto"
          exit 2
        fi
        install_driver_group="$2"
        shift
        ;;
      --install-packages)
        install_packages=1
        ;;
      --install-fonts)
        install_fonts=1
        ;;
      --link-configs)
        link_configs=1
        ;;
      --link-files)
        link_files=1
        ;;
      --configure-mise)
        configure_mise=1
        ;;
      --enable-services)
        enable_services=1
        ;;
      --enable-service-group)
        if [[ -z "${2:-}" ]]; then
          say "$c_red" "--enable-service-group requires a name"
          exit 2
        fi
        service_groups+=("$2")
        shift
        ;;
      --backup)
        make_backup=1
        ;;
      --rollback-plan)
        rollback_plan=1
        ;;
      --sync-apps)
        sync_apps=1
        ;;
      --core)
        install_packages=1
        install_fonts=1
        link_configs=1
        link_files=1
        configure_mise=1
        enable_services=1
        ;;
      --all)
        fetch_references=1
        audit_references=1
        audit_local=1
        write_report=1
        install_packages=1
        install_fonts=1
        link_configs=1
        link_files=1
        configure_mise=1
        enable_services=1
        sync_apps=1
        ;;
      *)
        say "$c_red" "unknown argument: $1"
        usage
        exit 2
        ;;
    esac
    shift
  done
}

print_plan() {
  cat <<PLAN
Arcane Niri Workstation Reinstall Plan

Repo:
  $repo_root

Reference cache:
  $reference_root

Reports:
  $report_root

References:
  Omarchy:             $omarchy_repo
  Garuda Dr460nized:   $dr460nized_settings_repo
  Garuda ISO profiles: $garuda_iso_profiles_repo
  JaKooLit Arch-Hyprland: $jakoolit_arch_hyprland_repo

Modes:
  apply:              $apply
  fetch_references:   $fetch_references
  audit_references:   $audit_references
  install_packages:   $install_packages
  install_fonts:      $install_fonts
  link_configs:       $link_configs
  link_files:         $link_files
  configure_mise:     $configure_mise
  enable_services:    $enable_services
  sync_apps:          $sync_apps
  audit_local:        $audit_local
  hardware_report:    $hardware_report
  write_report:       $write_report
  backup:             $make_backup
  rollback_plan:      $rollback_plan
  credits:            $print_credits
  install_groups:     ${install_groups[*]:-none}
  driver_group:       ${install_driver_group:-none}
  service_groups:     ${service_groups[*]:-none}

Safety:
  Upstream Omarchy installer is never executed.
  System-changing phases require --apply.
PLAN
}

package_group_file() {
  case "$1" in
    common) printf '%s\n' "$package_list_root/common.txt" ;;
    dev) printf '%s\n' "$package_list_root/dev.txt" ;;
    gui) printf '%s\n' "$package_list_root/gui.txt" ;;
    wayland) printf '%s\n' "$package_list_root/wayland.txt" ;;
    amd) printf '%s\n' "$package_list_root/amd.txt" ;;
    gpu-amd) printf '%s\n' "$package_list_root/gpu-amd.txt" ;;
    gpu-intel) printf '%s\n' "$package_list_root/gpu-intel.txt" ;;
    gpu-nvidia-proprietary) printf '%s\n' "$package_list_root/gpu-nvidia-proprietary.txt" ;;
    gpu-nvidia-nouveau) printf '%s\n' "$package_list_root/gpu-nvidia-nouveau.txt" ;;
    gpu-hybrid) printf '%s\n' "$package_list_root/gpu-hybrid.txt" ;;
    gpu-generic) printf '%s\n' "$package_list_root/wayland.txt" ;;
    aur) printf '%s\n' "$package_list_root/aur.txt" ;;
    flatpak) printf '%s\n' "$package_list_root/flatpak.txt" ;;
    omarchy-compatible) printf '%s\n' "$package_list_root/omarchy-compatible.txt" ;;
    omarchy-optional) printf '%s\n' "$package_list_root/omarchy-optional.txt" ;;
    omarchy-reject) printf '%s\n' "$package_list_root/omarchy-reject.txt" ;;
    dr460nized-compatible) printf '%s\n' "$package_list_root/dr460nized-compatible.txt" ;;
    dr460nized-optional) printf '%s\n' "$package_list_root/dr460nized-optional.txt" ;;
    dr460nized-reject) printf '%s\n' "$package_list_root/dr460nized-reject.txt" ;;
    amd-gaming-optional) printf '%s\n' "$package_list_root/amd-gaming-optional.txt" ;;
    workstation-qol|workstation-quality-of-life) printf '%s\n' "$package_list_root/workstation-quality-of-life.txt" ;;
    jakoolit-compatible) printf '%s\n' "$package_list_root/jakoolit-compatible.txt" ;;
    jakoolit-optional) printf '%s\n' "$package_list_root/jakoolit-optional.txt" ;;
    jakoolit-reject) printf '%s\n' "$package_list_root/jakoolit-reject.txt" ;;
    *) return 1 ;;
  esac
}

list_available_groups() {
  cat <<'GROUPS'
Package groups:
  common
  dev
  gui
  wayland
  amd
  gpu-amd
  gpu-intel
  gpu-nvidia-proprietary
  gpu-nvidia-nouveau
  gpu-hybrid
  aur
  flatpak
  workstation-qol
  omarchy-compatible
  omarchy-optional
  omarchy-reject       (audit only, do not install)
  dr460nized-compatible
  dr460nized-optional
  dr460nized-reject    (audit only, do not install)
  amd-gaming-optional
  jakoolit-compatible
  jakoolit-optional
  jakoolit-reject     (audit only, do not install)

Service groups:
  desktop-core
  audio
  network
  bluetooth
  power
  printing
  docker
  firewall-firewalld
  firewall-ufw
  locate

Policy:
  Hyprland/KDE groups are reference-only and not install targets.
  Use --hardware-report before --install-driver-group auto on new machines.
  Firewalld and UFW are separate groups. Pick one.
  Docker, printing, Avahi/mDNS, firewall, and gaming layers are explicit opt-in.
GROUPS
}

read_package_file() {
  local file="$1"
  [[ -f "$file" ]] || return 0

  sed 's/[[:space:]]*#.*$//; /^[[:space:]]*$/d' "$file"
}

install_package_group() {
  local group="$1"
  local file

  if ! file="$(package_group_file "$group")"; then
    say "$c_red" "unknown package group: $group"
    return 1
  fi

  if [[ "$group" == *reject ]]; then
    say "$c_red" "blocked: $group is audit-only"
    return 1
  fi

  if [[ ! -f "$file" ]]; then
    say "$c_yellow" "missing package list: $file"
    return 0
  fi

  mapfile -t packages < <(read_package_file "$file")
  if [[ "${#packages[@]}" -eq 0 ]]; then
    say "$c_yellow" "empty package group: $group"
    return 0
  fi

  if [[ "$apply" != "1" ]]; then
    say "$c_yellow" "dry-run package group: $group"
    printf '  %s\n' "${packages[@]}"
    return 0
  fi

  case "$group" in
    aur)
      if ! command -v yay >/dev/null 2>&1; then
        say "$c_red" "yay is required for AUR group"
        return 1
      fi
      say "$c_blue" "installing AUR group: $group"
      yay -S --noconfirm --needed "${packages[@]}"
      ;;
    flatpak)
      if ! command -v flatpak >/dev/null 2>&1; then
        say "$c_red" "flatpak is required for flatpak group"
        return 1
      fi
      flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo || true
      say "$c_blue" "installing flatpak group: $group"
      flatpak install -y flathub "${packages[@]}"
      ;;
    *)
      say "$c_blue" "installing pacman group: $group"
      sudo pacman -S --noconfirm --needed "${packages[@]}"
      ;;
  esac
}

service_group_units() {
  case "$1" in
    desktop-core) printf '%s\n' system:sddm.service ;;
    audio) printf '%s\n' user:pipewire.socket user:pipewire-pulse.socket user:wireplumber.service ;;
    network) printf '%s\n' system:NetworkManager.service ;;
    bluetooth) printf '%s\n' system:bluetooth.service ;;
    power) printf '%s\n' system:power-profiles-daemon.service ;;
    printing) printf '%s\n' system:cups.service system:cups-browsed.service system:avahi-daemon.service ;;
    docker) printf '%s\n' system:docker.service ;;
    firewall-firewalld) printf '%s\n' system:firewalld.service ;;
    firewall-ufw) printf '%s\n' system:ufw.service ;;
    locate) printf '%s\n' system:plocate-updatedb.timer ;;
    *) return 1 ;;
  esac
}

enable_service_group() {
  local group="$1"
  local units=()

  if ! service_group_units "$group" >/dev/null; then
    say "$c_red" "unknown service group: $group"
    return 1
  fi
  mapfile -t units < <(service_group_units "$group")

  if [[ "${#units[@]}" -eq 0 ]]; then
    say "$c_yellow" "empty service group: $group"
    return 0
  fi

  if [[ "$apply" != "1" ]]; then
    say "$c_yellow" "dry-run service group: $group"
    printf '  %s\n' "${units[@]}"
    return 0
  fi

  for unit in "${units[@]}"; do
    case "$unit" in
      system:*)
        say "$c_blue" "enabling ${unit#system:}"
        sudo systemctl enable "${unit#system:}" || true
        ;;
      user:*)
        say "$c_blue" "enabling user ${unit#user:}"
        systemctl --user enable "${unit#user:}" || true
        ;;
    esac
  done
}

backup_live_configs() {
  local stamp dest
  stamp="$(date +"%Y%m%d-%H%M%S")"
  dest="$backup_root/$stamp"

  if [[ "$make_backup" != "1" ]]; then
    say "$c_yellow" "skip: backup"
    return 0
  fi

  if [[ "$apply" != "1" ]]; then
    say "$c_yellow" "dry-run backup target: $dest"
    return 0
  fi

  mkdir -p "$dest"
  local paths=(
    "$HOME/.config/niri"
    "$HOME/.config/waybar"
    "$HOME/.config/kitty"
    "$HOME/.config/tmux"
    "$HOME/.config/zsh"
    "$HOME/.zshrc"
    "$HOME/.tmux.conf"
  )

  for path in "${paths[@]}"; do
    if [[ -e "$path" || -L "$path" ]]; then
      local relative="${path#"$HOME"/}"
      say "$c_blue" "backup: $path"
      mkdir -p "$dest/$(dirname "$relative")"
      cp -a "$path" "$dest/$relative"
    fi
  done

  say "$c_green" "backup written to $dest"
}

audit_local_package_lists() {
  [[ "$audit_local" == "1" ]] || {
    say "$c_yellow" "skip: local package audit"
    return 0
  }

  mkdir -p "$report_root"
  local report="$report_root/local-package-audit.md"
  local all_packages="$report_root/local-packages-expanded.txt"
  local duplicates="$report_root/local-package-duplicates.txt"
  local missing_pacman="$report_root/local-package-missing-pacman.txt"

  : > "$all_packages"
  : > "$missing_pacman"
  for file in "$package_list_root"/*.txt; do
    [[ -f "$file" ]] || continue
    while IFS= read -r package; do
      printf '%s\t%s\n' "$package" "$(basename "$file")" >> "$all_packages"
    done < <(read_package_file "$file")
  done

  cut -f1 "$all_packages" | sort | uniq -d > "$duplicates"

  if command -v pacman >/dev/null 2>&1; then
    while IFS=$'\t' read -r package group_file; do
      case "$group_file" in
        aur.txt|flatpak.txt|*-reject.txt)
          continue
          ;;
      esac

      if ! pacman -Si "$package" >/dev/null 2>&1; then
        printf '%s\t%s\n' "$package" "$group_file" >> "$missing_pacman"
      fi
    done < "$all_packages"
  fi

  {
    printf '# Local Package Audit\n\n'
    printf "Package list root: \`%s\`\n\n" "$package_list_root"
    printf '## Groups\n\n'
    for file in "$package_list_root"/*.txt; do
      [[ -f "$file" ]] || continue
      printf -- "- \`%s\`: %s packages\n" "$(basename "$file")" "$(read_package_file "$file" | wc -l)"
    done
    printf '\n## Duplicate Packages Across Lists\n\n'
    if [[ -s "$duplicates" ]]; then
      sed 's/^/- `/' "$duplicates" | sed 's/$/`/'
    else
      printf 'None.\n'
    fi
    printf '\n## Missing From Pacman Sync DB\n\n'
    if ! command -v pacman >/dev/null 2>&1; then
      printf "Skipped: \`pacman\` not found.\n"
    elif [[ -s "$missing_pacman" ]]; then
      while IFS=$'\t' read -r package group_file; do
        printf -- "- \`%s\` from \`%s\`\n" "$package" "$group_file"
      done < "$missing_pacman"
    else
      printf 'None for pacman-backed groups.\n'
    fi
    printf '\n'
  } > "$report"

  say "$c_green" "local package audit written to $report"
}

write_reports_if_enabled() {
  [[ "$write_report" == "1" ]] || {
    say "$c_yellow" "skip: reports"
    return 0
  }

  mkdir -p "$report_root"

  {
    printf '# Arcane Install Plan\n\n'
    printf "Apply: \`%s\`\n\n" "$apply"
    printf '## Package Groups\n\n'
    if [[ "${#install_groups[@]}" -eq 0 ]]; then
      printf 'No explicit package groups selected.\n'
    else
      printf -- "- \`%s\`\n" "${install_groups[@]}"
    fi
    printf '\n## Driver Group\n\n'
    if [[ -n "$install_driver_group" ]]; then
      if [[ "$install_driver_group" == "auto" ]]; then
        printf '%s\n' "- requested: \`auto\`"
        printf '%s\n' "- detected: \`$(detect_gpu_driver_group)\`"
      else
        printf '%s\n' "- \`$install_driver_group\`"
      fi
    else
      printf 'No driver group selected.\n'
    fi
    printf '\n## Service Groups\n\n'
    if [[ "${#service_groups[@]}" -eq 0 ]]; then
      printf 'No explicit service groups selected.\n'
    else
      printf -- "- \`%s\`\n" "${service_groups[@]}"
    fi
  } > "$report_root/install-plan.md"

  {
    printf '# Service Plan\n\n'
    list_available_groups
  } > "$report_root/service-plan.md"

  {
    printf '# License Boundary\n\n'
    printf 'No upstream Omarchy, Garuda, or JaKooLit files are vendored by this installer.\n\n'
    printf "References are cloned only into \`%s\`.\n\n" "$reference_root"
    printf 'If code, assets, themes, wallpapers, fonts, or configs are copied later, add exact source paths and license notices.\n'
  } > "$report_root/license-boundary.md"

  say "$c_green" "reports written to $report_root"
}

write_rollback_plan_if_enabled() {
  [[ "$rollback_plan" == "1" ]] || {
    say "$c_yellow" "skip: rollback plan"
    return 0
  }

  mkdir -p "$report_root"
  local report="$report_root/rollback-plan.md"

  {
    printf '# Rollback Plan\n\n'
    printf 'This installer does not perform automatic destructive rollback.\n\n'
    printf '## Backups\n\n'
    printf "Backups created by \`--backup --apply\` live under:\n\n"
    printf "\`\`\`text\n%s\n\`\`\`\n\n" "$backup_root"
    printf "Restore by copying selected backup paths back into \`\$HOME\` after inspection.\n\n"
    printf '## Symlinks\n\n'
    printf 'Inspect live symlinks before removing anything:\n\n'
    printf '```bash\n'
    printf "find \"\$HOME/.config\" \"\$HOME/.local/bin\" -maxdepth 2 -type l -ls\n"
    printf '```\n\n'
    printf 'Remove only symlinks that point back to this repo.\n\n'
    printf '## Services\n\n'
    printf 'Disable explicitly enabled service groups with matching systemd commands, for example:\n\n'
    printf '```bash\n'
    printf 'sudo systemctl disable --now bluetooth.service\n'
    printf 'sudo systemctl disable --now firewalld.service\n'
    printf 'systemctl --user disable --now pipewire.socket pipewire-pulse.socket wireplumber.service\n'
    printf '```\n\n'
    printf '## Packages\n\n'
    printf 'Package removal is intentionally manual. Review install reports before removing packages.\n'
  } > "$report"

  say "$c_green" "rollback plan written to $report"
}

print_credits_if_enabled() {
  [[ "$print_credits" == "1" ]] || return 0

  cat <<'CREDITS'
Credits and source boundary:
  Omarchy:
    https://omarchy.org/
    https://github.com/basecamp/omarchy
    Used as reference/inspiration only.

  Garuda Dr460nized:
    https://garudalinux.org/
    https://gitlab.com/garuda-linux/themes-and-settings/settings/garuda-dr460nized
    https://gitlab.com/garuda-linux/tools/iso-profiles
    Used as reference/inspiration only.

  JaKooLit Arch-Hyprland:
    https://github.com/JaKooLit/Arch-Hyprland
    Used as reference/inspiration only.

  Local policy:
    Niri + local scripts remain canonical.
    No upstream code/assets/configs are vendored by this script.
CREDITS
}

clone_or_update() {
  local repo="$1"
  local dest="$2"

  mkdir -p "$(dirname "$dest")"

  if [[ -d "$dest/.git" ]]; then
    say "$c_blue" "updating reference: $dest"
    git -C "$dest" pull --ff-only
    return 0
  fi

  say "$c_blue" "cloning reference: $repo"
  git clone "$repo" "$dest"
}

fetch_reference_repos() {
  [[ "$fetch_references" == "1" ]] || {
    say "$c_yellow" "skip: reference fetch"
    return 0
  }

  clone_or_update "$omarchy_repo" "$reference_root/omarchy"
  clone_or_update "$dr460nized_settings_repo" "$reference_root/garuda-dr460nized-settings"
  clone_or_update "$garuda_iso_profiles_repo" "$reference_root/garuda-iso-profiles"
  clone_or_update "$jakoolit_arch_hyprland_repo" "$reference_root/jakoolit-arch-hyprland"
}

audit_references_if_enabled() {
  [[ "$audit_references" == "1" ]] || {
    say "$c_yellow" "skip: reference audit"
    return 0
  }

  mkdir -p "$report_root"

  say "$c_blue" "writing reference audit reports"
  : > "$report_root/reference-versions.txt"

  if [[ -d "$reference_root/omarchy" ]]; then
    printf 'omarchy %s\n' "$(git -C "$reference_root/omarchy" rev-parse --short HEAD)" >> "$report_root/reference-versions.txt"
    find "$reference_root/omarchy" -path '*/.git/*' -prune -o -maxdepth 3 -type f -print | sort > "$report_root/omarchy-files.txt"
    find "$reference_root/omarchy" -path '*/.git/*' -prune -o -type f -name '*.packages' -print | sort > "$report_root/omarchy-package-files.txt"
    : > "$report_root/omarchy-packages-expanded.txt"
    while IFS= read -r package_file; do
      {
        printf '# %s\n' "$package_file"
        sed '/^[[:space:]]*$/d; /^[[:space:]]*#/d' "$package_file"
        printf '\n'
      } >> "$report_root/omarchy-packages-expanded.txt"
    done < "$report_root/omarchy-package-files.txt"
  else
    printf 'Omarchy reference missing. Run with --fetch-references first.\n' > "$report_root/omarchy-files.txt"
  fi

  if [[ -d "$reference_root/garuda-dr460nized-settings" ]]; then
    printf 'garuda-dr460nized-settings %s\n' "$(git -C "$reference_root/garuda-dr460nized-settings" rev-parse --short HEAD)" >> "$report_root/reference-versions.txt"
    find "$reference_root/garuda-dr460nized-settings" -path '*/.git/*' -prune -o -maxdepth 5 -type f -print | sort > "$report_root/garuda-dr460nized-settings-files.txt"
  else
    printf 'Garuda Dr460nized settings reference missing. Run with --fetch-references first.\n' > "$report_root/garuda-dr460nized-settings-files.txt"
  fi

  if [[ -d "$reference_root/garuda-iso-profiles/garuda/dr460nized" ]]; then
    printf 'garuda-iso-profiles %s\n' "$(git -C "$reference_root/garuda-iso-profiles" rev-parse --short HEAD)" >> "$report_root/reference-versions.txt"
    find "$reference_root/garuda-iso-profiles/garuda/dr460nized" -path '*/.git/*' -prune -o -maxdepth 5 -type f -print | sort > "$report_root/garuda-dr460nized-iso-profile-files.txt"
    if [[ -f "$reference_root/garuda-iso-profiles/garuda/dr460nized/Packages-Desktop" ]]; then
      sed '/^[[:space:]]*$/d; /^[[:space:]]*#/d' \
        "$reference_root/garuda-iso-profiles/garuda/dr460nized/Packages-Desktop" \
        > "$report_root/garuda-dr460nized-packages.txt"
    fi
  else
    printf 'Garuda ISO profile reference missing. Run with --fetch-references first.\n' > "$report_root/garuda-dr460nized-iso-profile-files.txt"
  fi

  if [[ -d "$reference_root/jakoolit-arch-hyprland" ]]; then
    printf 'jakoolit-arch-hyprland %s\n' "$(git -C "$reference_root/jakoolit-arch-hyprland" rev-parse --short HEAD)" >> "$report_root/reference-versions.txt"
    find "$reference_root/jakoolit-arch-hyprland" -path '*/.git/*' -prune -o -maxdepth 4 -type f -print | sort > "$report_root/jakoolit-arch-hyprland-files.txt"
    find "$reference_root/jakoolit-arch-hyprland/install-scripts" -maxdepth 1 -type f -name '*.sh' -printf '%f\n' 2>/dev/null | sort > "$report_root/jakoolit-install-scripts.txt" || true
    {
      printf '# JaKooLit Reference Boundary\n\n'
      printf "Reference repo: \`%s\`\n\n" "$jakoolit_arch_hyprland_repo"
      printf 'Adopt as ideas: final checks, phase isolation, logs, disk monitor, temperature monitor, package classification.\n\n'
      printf 'Reject as defaults: curl/auto installers, external Hyprland-Dots application, Hyprland compositor replacement, XDPH-Hyprland, NVIDIA scripts on AMD hardware.\n'
    } > "$report_root/jakoolit-boundary.md"
  else
    printf 'JaKooLit Arch-Hyprland reference missing. Run with --fetch-references first.\n' > "$report_root/jakoolit-arch-hyprland-files.txt"
  fi

  say "$c_green" "reports written to $report_root"
}

hardware_report_if_enabled() {
  [[ "$hardware_report" == "1" ]] || {
    say "$c_yellow" "skip: hardware report"
    return 0
  }

  mkdir -p "$report_root"
  print_hardware_report | tee "$report_root/hardware-report.txt"
  say "$c_green" "hardware report written to $report_root/hardware-report.txt"
}

install_detected_driver_group_if_selected() {
  [[ -n "$install_driver_group" ]] || return 0

  local group="$install_driver_group"
  if [[ "$group" == "auto" ]]; then
    group="$(detect_gpu_driver_group)"
  fi

  say "$c_blue" "driver group selected: $group"
  install_package_group "$group"
}

require_apply() {
  local label="$1"

  if [[ "$apply" != "1" ]]; then
    say "$c_red" "blocked: $label requires --apply"
    return 1
  fi
}

run_phase() {
  local enabled="$1"
  local label="$2"
  local script="$3"

  [[ "$enabled" == "1" ]] || {
    say "$c_yellow" "skip: $label"
    return 0
  }

  require_apply "$label"

  if [[ ! -f "$install_dir/$script" ]]; then
    say "$c_yellow" "missing script: $script"
    return 0
  fi

  say "$c_blue" "$label"
  bash "$install_dir/$script"
}

sync_apps_if_enabled() {
  [[ "$sync_apps" == "1" ]] || {
    say "$c_yellow" "skip: app sync"
    return 0
  }

  require_apply "app sync"

  if command -v nvim >/dev/null 2>&1; then
    say "$c_blue" "syncing Neovim Lazy plugins"
    nvim --headless "+Lazy! sync" +qa
  else
    say "$c_yellow" "skip: nvim not installed"
  fi

  if [[ -f "$HOME/.tmux/plugins/tpm/bin/install_plugins" ]]; then
    say "$c_blue" "syncing Tmux TPM plugins"
    "$HOME/.tmux/plugins/tpm/bin/install_plugins" >/dev/null 2>&1 || true
  else
    say "$c_yellow" "skip: TPM not installed"
  fi
}

main() {
  parse_args "$@"

  say "$c_green" "Arcane Niri Workstation reinstall orchestrator"
  print_plan

  if [[ "$list_groups" == "1" ]]; then
    list_available_groups
  fi

  print_credits_if_enabled
  fetch_reference_repos
  audit_references_if_enabled
  audit_local_package_lists
  hardware_report_if_enabled
  write_reports_if_enabled
  write_rollback_plan_if_enabled
  backup_live_configs

  run_phase "$install_packages" "install package lists" "package_install.sh"
  for group in "${install_groups[@]}"; do
    install_package_group "$group"
  done
  install_detected_driver_group_if_selected

  run_phase "$install_fonts" "install custom fonts" "install_custom_fonts.sh"
  run_phase "$link_configs" "link .config entries" "symlink_configs.sh"
  run_phase "$link_files" "link .local/bin entries" "symlink_files.sh"
  run_phase "$configure_mise" "configure mise" "configure_mise.sh"

  if [[ "$(uname -s)" == "Linux" ]]; then
    run_phase "$enable_services" "enable Linux services" "enable_services.sh"
  else
    say "$c_yellow" "skip: enable services only applies to Linux"
  fi

  for group in "${service_groups[@]}"; do
    enable_service_group "$group"
  done

  sync_apps_if_enabled

  printf '\n'
  say "$c_green" "flow finished"
}

main "$@"
