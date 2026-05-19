# Credits - Omarchy and Dr460nized

This repository has its own Niri workflow. It uses Omarchy and Garuda Dr460nized as references, not as vendored code.

## Omarchy

Omarchy is a modern, opinionated Linux distribution by DHH/Basecamp.

Links:

- https://omarchy.org/
- https://github.com/basecamp/omarchy

Local usage:

- Inspiration for a complete Arch desktop bootstrap.
- Reference for package organization and opinionated desktop setup.
- Fetched only into `~/.cache/arcane-reinstall/references/omarchy` when requested.
- Not executed automatically by `install/install.sh arcane-niri`.

## Garuda Dr460nized

Garuda Dr460nized is a stylized Garuda Linux desktop profile/theme family.

Links:

- https://garudalinux.org/
- https://gitlab.com/garuda-linux/themes-and-settings/settings/garuda-dr460nized
- https://gitlab.com/garuda-linux/tools/iso-profiles/-/tree/master/garuda/dr460nized

Local usage:

- Visual inspiration for a polished Arch workstation.
- Reference for theme/layout/package audit.
- Fetched only into `~/.cache/arcane-reinstall/references/` when requested.
- Not applied automatically to KDE, Plasma, Hyprland, or local Niri configs.

## Local Source Of Truth

If upstream behavior conflicts with this repo, this repo wins.

Primary local files:

- `install/workflows/arcane_niri_workstation.sh`
- `install/package_lists/linux/`
- `config/`
- `config/`
- `config/environment.d/30-amd.conf`
- `config/niri/`

## License Boundary

This repository does not vendor Omarchy or Garuda Dr460nized source files in the added reinstall flow.

If future work copies code, configs, themes, or assets from upstream projects, copy the relevant license notices and document exactly which files were imported.
