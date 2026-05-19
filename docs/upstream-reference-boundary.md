# Upstream Reference Boundary

This repo may inspect upstream projects, but it does not vendor them.

## References

Omarchy:

- https://omarchy.org/
- https://github.com/basecamp/omarchy

Garuda Dr460nized:

- https://garudalinux.org/
- https://gitlab.com/garuda-linux/themes-and-settings/settings/garuda-dr460nized
- https://gitlab.com/garuda-linux/tools/iso-profiles

JaKooLit Arch-Hyprland:

- https://github.com/JaKooLit/Arch-Hyprland

## Boundary

Allowed:

- package audit;
- service audit;
- UX pattern notes;
- installer structure ideas;
- GPU detection policy;
- installer final-check and health-monitor concepts;
- manual links and credits.

Not allowed without explicit license work:

- copying upstream configs;
- copying scripts;
- copying themes;
- copying wallpapers;
- copying fonts;
- copying icons/assets.
- copying upstream SDDM themes as local assets without license review.

## External Assets Repository

Heavy or third-party assets should live outside this dotfiles repository.

Recommended shape:

```text
Saiiru/arcane-assets
  wallpapers/
  sounds/
  fonts/
  licenses/
  sources.md
```

This dotfiles repo should reference assets through environment variables such as:

```text
DOTFILES_WALLPAPER_DIR
DOTFILES_SOUND_DIR
```

Do not vendor upstream artwork into this repo.

## Current Installer Boundary

The canonical local command remains:

```bash
bash install/install.sh arcane-niri
```

The name is kept for backward compatibility, but the policy is the Arcane Niri
Workstation model: Omarchy, Garuda, and JaKooLit are references only,
while Niri and local scripts remain the local source of truth.
