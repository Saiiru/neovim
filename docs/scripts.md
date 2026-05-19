# Operational Scripts

All executable commands live in the `bin/` directory and are categorized by function.

## Categories
- `bin/niri/`: Niri-specific controls.
- `bin/device/`: Hardware and status scripts (Audio, Battery, Network).
- `bin/session/`: Session management (Start, Power, Lock).
- `bin/media/`: Media controls and status.
- `bin/wallpaper/`: Wallpaper management.
- `bin/health/`: System diagnostics and repository audit.

## Shared Library
Scripts should source `bin/lib/core.sh` for logging, notifications, and common checks.

## Niri / Shell scripts
- `bin/session/kora-session`: session wrapper used by Niri keybinds.
- `bin/niri/validate`: helper for `niri validate -c config/niri/config.kdl`.
- `bin/niri/screenshot-selection`: region capture to clipboard (`grim + slurp + wl-copy`).
- `bin/wallpaper/wallpaper-control`: wallpaper entrypoint (`init`, `set`, `random`, `list`, `current`).
