---
type: workflow
status: active
domain: installer
tags:
  - workflow
  - installer
  - niri
---

# JaKooLit Script Audit for Arcane Niri

## Best Scripts For This Setup

`02-Final-Check.sh` is the strongest idea: keep a post-install verifier, but replace Hyprland essentials with Arcane Niri essentials.

`disk-monitor.sh` is useful because `/data` is already near capacity. The adapted version must be compositor-neutral and live under `bin`.

`temp-monitor.sh` is useful for desktop health, but must not run `sudo sensors-detect --auto` automatically.

`pipewire.sh` and `bluetooth.sh` are good examples of isolated phases. In this repo, that maps to `--enable-service-group audio` and `--enable-service-group bluetooth`.

`pacman.sh`, `yay.sh`, and `paru.sh` are useful as installer UX references, but package manager policy remains centralized in `install/install.sh arcane-niri`.

## Do Not Port Directly

`auto-install.sh` bypasses review and is not acceptable for this repo.

`dotfiles-main.sh` downloads and applies external Hyprland-Dots. That violates the no-vendor/no-upstream-config rule.

`nvidia.sh` and `nvidia_nouveau.sh` are not relevant to the current AMD/RADV hardware. NVIDIA remains available only through explicit driver groups.

`hyprland.sh`, `xdph.sh`, `sddm_theme.sh`, `gtk_themes.sh`, and `zsh.sh` are too opinionated or compositor-specific to port directly.

## Arcane Replacement

Use:

```bash
bash install/install.sh arcane-niri --hardware-report
bash install/install.sh arcane-niri --audit-local
bash install/install.sh arcane-niri --install-driver-group auto
```

Use the health monitor:

```bash
bin/health/monitor once
bin/health/monitor disk
bin/health/monitor temp
```

Use the Arcane final check:

```bash
bin/health/stack-check
```

Run daemon mode manually first:

```bash
ARCANE_HEALTH_INTERVAL=300 bin/health/monitor daemon
```

Only create a user service after testing the daemon interactively.
