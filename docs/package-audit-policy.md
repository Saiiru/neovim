# Package Audit Policy

Package lists are contracts. They must stay small, named, and explicit.

## Core Lists

- `common.txt`
- `dev.txt`
- `gui.txt`
- `wayland.txt`
- `amd.txt`
- `aur.txt`
- `flatpak.txt`

These are used by the existing base installer.

## Optional Audit Lists

- `omarchy-compatible.txt`
- `omarchy-optional.txt`
- `omarchy-reject.txt`
- `dr460nized-compatible.txt`
- `dr460nized-optional.txt`
- `dr460nized-reject.txt`
- `amd-gaming-optional.txt`
- `workstation-quality-of-life.txt`
- `jakoolit-compatible.txt`
- `jakoolit-optional.txt`
- `jakoolit-reject.txt`

These are installed only by explicit `--install-group`.

## Classification

Use these labels mentally:

- `adopt`: aligned with Niri and local scripts.
- `optional`: useful but changes threat model or dependencies.
- `reject`: conflicts with local stack.
- `reference-only`: useful idea, not a local dependency.

## Rules

- Do not add Hyprland/KDE replacement packages to core lists.
- Do not put Docker, printing, Avahi/mDNS, firewall, or gaming/multilib into default core.
- Every optional list must have comments explaining risk or role.
- Reject lists are not install targets.
- Packages missing from the local pacman sync database should be commented out
  or moved to an AUR/Flatpak/manual path before group installation.
- Run local audit before expanding defaults.

## Commands

```bash
bash install/install.sh arcane-niri --audit-local
bash install/install.sh arcane-niri --report
```

The local audit writes:

```text
~/.cache/arcane-reinstall/reports/local-package-audit.md
~/.cache/arcane-reinstall/reports/local-package-duplicates.txt
~/.cache/arcane-reinstall/reports/local-package-missing-pacman.txt
```
