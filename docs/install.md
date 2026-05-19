# Installation Guide

## Usage
The `install/install.sh` script is the entry point for setting up or updating the environment.

### Commands
- `./install/install.sh`: Runs the default installation flow.
- `./install/install.sh arcane-niri`: Runs the auditable Niri workstation flow.

### Future Contract (WIP)
- `./install/install.sh link all`: Symlinks all configurations in `config/` to `~/.config/`.
- `./install/install.sh packages <group>`: Installs a specific package list from `install/packages/`.
- `./install/install.sh audit`: Checks system state against the dotfiles.

## Safety
- **Backups:** Automatic backups are created in `~/.config.backup/` or via the `install/lib/backup.sh` system.
- **Dry-run:** The `arcane-niri` flow defaults to dry-run unless `--apply` is passed.
