# Arcane Niri Workstation Installer V2

This installer keeps the local stack canonical:

```text
Niri
Fuzzel/local scripts
Kitty
Zsh
Tmux
Neovim
Yazi
AMD/RADV
```

Omarchy, Garuda Dr460nized, and JaKooLit Arch-Hyprland are references, not vendored sources.

## Main Command

```bash
bash install/install.sh arcane-niri
```

Default behavior is dry-run.

The workflow implementation lives in:

```text
install/workflows/arcane_niri_workstation.sh
```

## Discovery

```bash
bash install/install.sh arcane-niri --list-groups
bash install/install.sh arcane-niri --credits
```

## Audits

```bash
bash install/install.sh arcane-niri --audit-local
bash install/install.sh arcane-niri --audit-upstream
bash install/install.sh arcane-niri --references
bash install/install.sh arcane-niri --report
bash install/install.sh arcane-niri --rollback-plan
```

Reports are written to:

```text
~/.cache/arcane-reinstall/reports/
```

`--audit-upstream` is an alias for `--audit-references`; use `--references`
when you also want to fetch/update the local upstream reference cache first.

## Install Package Groups

Dry-run:

```bash
bash install/install.sh arcane-niri --install-group workstation-qol
```

Apply:

```bash
bash install/install.sh arcane-niri --apply --install-group workstation-qol
```

Multiple groups:

```bash
bash install/install.sh arcane-niri \
  --apply \
  --install-group omarchy-compatible \
  --install-group dr460nized-compatible \
  --install-group jakoolit-compatible \
  --install-group workstation-qol
```

Reference-derived reject groups such as `omarchy-reject` and `jakoolit-reject`
are audit-only. The installer blocks them as install targets.

## Enable Service Groups

Dry-run:

```bash
bash install/install.sh arcane-niri --enable-service-group bluetooth
```

Apply:

```bash
bash install/install.sh arcane-niri --apply --enable-service-group bluetooth
```

## Backup Before Apply

```bash
bash install/install.sh arcane-niri --apply --backup --link-configs --link-files
```

Backups are written to:

```text
~/.cache/arcane-reinstall/backups/
```

## Rollback Plan

```bash
bash install/install.sh arcane-niri --rollback-plan
```

This writes a manual rollback checklist to:

```text
~/.cache/arcane-reinstall/reports/rollback-plan.md
```

Rollback is intentionally not automatic. The installer reports what to inspect:
backups, symlinks, services, and packages.

## Hyprland Adaptation Policy

Hyprland itself is not adopted.

Adopt ideas:

- keyboard-first UX;
- command palette thinking;
- launcher discipline;
- OSD/user feedback patterns;
- portal/service awareness;
- package grouping and post-install reporting.
- final-check and health-monitor concepts from JaKooLit-style installer scripts.

Reject direct adoption:

- `hyprland`;
- `hyprlock`;
- `hypridle`;
- `hyprpicker`;
- `xdg-desktop-portal-hyprland`;
- Omarchy launcher dependency;
- upstream Neovim replacement.
- upstream dotfiles downloader scripts.
- auto-install/curl-run scripts.

Adaptation target is Niri + local scripts.

## Invariants

- No curl pipe bash.
- No upstream config overwrite.
- No vendored upstream repo under this repo.
- No Hyprland/KDE/Plasma default install.
- No firewall/Docker/printing/mDNS enablement without explicit service group.
- AMD/RADV local policy remains explicit.
