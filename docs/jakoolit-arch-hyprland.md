---
type: reference
status: active
source: https://github.com/JaKooLit/Arch-Hyprland
tags:
  - references
  - niri
  - hyprland
  - installer
---

# JaKooLit Arch-Hyprland Reference Audit

JaKooLit Arch-Hyprland is useful as an installer-pattern reference, not as a config source for this repo.

## Adopt

- Phase separation: base packages, audio, Bluetooth, display manager, shell, final checks.
- Final package verification after install.
- Installation logs and visible success/failure reporting.
- Small utility monitors for disk usage and temperature.
- Explicit optional handling for SDDM, shell setup, and desktop extras.

## Adapt

- Disk and temperature monitor concepts become `bin/health/monitor`.
- Hardware checks feed the Arcane Niri driver-group flow, not JaKooLit NVIDIA scripts.
- Package ideas are classified into `jakoolit-compatible`, `jakoolit-optional`, and `jakoolit-reject`.
- Final checks should validate the Arcane Niri stack: Niri, local menus, portals, PipeWire, WirePlumber, Kitty, Firefox Wayland, AMD/RADV.

## Reject

- `auto-install.sh` and any curl-pipe or unattended upstream bootstrap.
- `dotfiles-main.sh`, because it downloads and applies external Hyprland-Dots.
- Hyprland as the primary compositor.
- `xdg-desktop-portal-hyprland` as a default portal.
- NVIDIA install scripts on this AMD machine.
- Hyprland-specific screenshot, lock, idle, logout, and wallpaper tools as defaults.
- Automatic `sudo sensors-detect --auto`; sensor detection should be a deliberate manual step.

## Boundary

No JaKooLit files are vendored here. Scripts and package lists in this repo are original adaptations or package audits. If a future change copies upstream code, add the exact source path and license note before committing.
