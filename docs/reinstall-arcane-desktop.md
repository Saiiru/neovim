# Reinstall Arcane Desktop

This is the safe reinstall path for this dotfiles repo.

The goal is not to become a raw Omarchy clone. The goal is to keep the current Sairu/Arcane stack reproducible while using Omarchy and Garuda Dr460nized as upstream references for desktop bootstrap quality, polish, and package audit.

## Current Source of Truth

- `install/package_lists/linux/`
- `install/install.sh`
- `install/install.sh`
- `install/workflows/arcane_niri_workstation.sh`
- `config/`
- `config/`
- `config/niri/`
- `config/environment.d/30-amd.conf`

## Desktop Shape

- Window system: Niri.
- Shell/HUD: local scripts, Fuzzel menus, and optional Waybar.
- Launcher: Fuzzel.
- Terminal: Kitty.
- Editor: Neovim.
- Shell: Zsh, Starship, Atuin.
- Multiplexer: Tmux.
- File workflow: Yazi, Dolphin, PCManFM.
- AMD: RADV is explicit; Steam uses the safe wrapper.

## Dry Run First

```bash
bash install/install.sh arcane-niri
```

This prints the plan and skips all system-changing phases.

## Fetch Upstream References

```bash
bash install/install.sh arcane-niri --references
```

This clones or updates references into:

```text
~/.cache/arcane-reinstall/references/
```

It also writes reports into:

```text
~/.cache/arcane-reinstall/reports/
```

Nothing from those repositories is copied into your config automatically.

## Full Apply

Use this only after reading package lists and checking the plan:

```bash
bash install/install.sh arcane-niri --apply --all
```

This runs:

- reference fetch/audit;
- package install;
- custom fonts;
- config symlinks;
- file symlinks;
- mise configuration;
- Linux services;
- Neovim/Tmux plugin sync.

## Practical Fresh Install

On a fresh Arch-based install, the safer sequence is:

```bash
bash install/install.sh arcane-niri --references
```

Then:

```bash
bash install/install.sh arcane-niri \
  --apply \
  --install-packages \
  --install-fonts
```

Then:

```bash
bash install/install.sh arcane-niri \
  --apply \
  --link-configs \
  --link-files \
  --configure-mise \
  --enable-services \
  --sync-apps
```

## Minimal Restore

If the system already has packages installed:

```bash
bash install/install.sh arcane-niri \
  --apply \
  --link-configs \
  --link-files \
  --enable-services
```

## What Not To Do Blindly

Do not run this as part of this dotfiles flow:

```bash
curl -fsSL https://omarchy.org/install | bash
```

Reason: the official Omarchy installer is intentionally opinionated and may configure Hyprland, packages, services, themes, and system behavior outside this repo's Niri design.

## Validation

After applying:

```bash
systemctl --user status pipewire.socket
systemctl --user status wireplumber.service
niri validate ~/.config/niri/config.kdl
```

## AMD Validation

```bash
printenv AMD_VULKAN_ICD
vulkaninfo --summary
```

Expected local policy:

```text
AMD_VULKAN_ICD=RADV
```

Steam should be launched through the safe wrapper:

```text
steam-safe
```

## Upgrade Policy

- Pull this repo first.
- Run dry-run.
- Fetch references only if you want to audit upstream changes.
- Apply package/config phases selectively.
- Never let upstream reference repos overwrite local config without manual review.
