# Upstream Reference Audit

The reinstall orchestrator can pull upstream references for inspection.

```bash
bash install/install.sh arcane-niri --references
```

Reference repositories:

- Omarchy: `https://github.com/basecamp/omarchy.git`
- Garuda Dr460nized settings: `https://gitlab.com/garuda-linux/themes-and-settings/settings/garuda-dr460nized.git`
- Garuda ISO profiles: `https://gitlab.com/garuda-linux/tools/iso-profiles.git`
- JaKooLit Arch-Hyprland: `https://github.com/JaKooLit/Arch-Hyprland.git`

Local cache:

```text
~/.cache/arcane-reinstall/references/
```

Reports:

```text
~/.cache/arcane-reinstall/reports/
```

## Reports Created

- `reference-versions.txt`
- `omarchy-files.txt`
- `omarchy-package-files.txt`
- `omarchy-packages-expanded.txt`
- `garuda-dr460nized-settings-files.txt`
- `garuda-dr460nized-iso-profile-files.txt`
- `garuda-dr460nized-packages.txt`
- `jakoolit-arch-hyprland-files.txt`
- `jakoolit-install-scripts.txt`
- `jakoolit-boundary.md`

## How To Use The Reports

Compare upstream package/config ideas with local files:

```bash
less ~/.cache/arcane-reinstall/reports/omarchy-package-files.txt
less ~/.cache/arcane-reinstall/reports/omarchy-packages-expanded.txt
less ~/.cache/arcane-reinstall/reports/garuda-dr460nized-packages.txt
less ~/.cache/arcane-reinstall/reports/garuda-dr460nized-settings-files.txt
less ~/.cache/arcane-reinstall/reports/jakoolit-install-scripts.txt
```

Then decide whether anything belongs in:

```text
install/package_lists/linux/
config/
config/
```

## Policy

Do not copy upstream files blindly.

Accept upstream ideas only when they fit the local stack:

- Niri instead of Hyprland as the primary compositor.
- Local scripts and Fuzzel as the shell/menu layer.
- AMD/RADV policy preserved.
- Existing zsh/tmux/nvim/yazi workflow preserved.
- No destructive overwrite of user config.
- Upstream scripts can inspire local phases, but should not be run directly.
