# Dotfiles

Personal dotfiles with OS-based organization, inspired by `krypton/dotfiles`, but installed with custom symlink scripts instead of GNU Stow.

## Layout

```text
.
├── .config
│   ├── common
│   │   ├── git
│   │   ├── kitty
│   │   ├── mise
│   │   ├── nvim
│   │   ├── starship
│   │   ├── theme
│   │   ├── tmux
│   │   └── zsh
│   └── linux
│       ├── environment.d
│       ├── fontconfig
│       ├── fuzzel
│       ├── niri
│       ├── pipewire
│       ├── swaylock
│       ├── waybar
│       ├── xdg
│       └── xdg-desktop-portal
├── .local
│   └── bin
│       └── linux
│           ├── common.sh
│           ├── niri-actions.sh
│           ├── power-actions.sh
│           ├── system-actions.sh
│           ├── wallpaper-actions.sh
│           └── ...
├── docs
│   ├── examples
│   └── workflow
├── install
│   ├── package_lists
│   │   ├── linux
│   │   └── macos
│   ├── enable_services.sh
│   ├── install.sh
│   ├── install_custom_fonts.sh
│   ├── package_install.sh
│   ├── symlink_configs.sh
│   └── symlink_files.sh
└── README.md
```

## Install

Clone the repo wherever you want and run:

```bash
bash /path/to/dotfiles/install/install.sh
```

What the installer does:

- installs packages from `install/package_lists/<os>/`
- on Linux, installs the conservative AMD/RADV baseline from `install/package_lists/linux/amd.txt`
- installs custom fonts from `saifulapm/my-fonts`
- symlinks `config` and `.config/<os>` into `~/.config`
- symlinks `.local/bin` into `~/.local/bin`
- enables Linux services when applicable

## Notes

- No GNU Stow is used.
- The symlinks point directly to the cloned repo.
- The layout is ready for future `macos` expansion, but only the Linux tree is populated today.
- Large local assets do not live in this repo. Use `~/Pictures/Wallpapers` or set `DOTFILES_WALLPAPER_DIR`; optional sounds live under `~/.local/share/dotfiles/sounds` or `DOTFILES_SOUND_DIR`.

## Arcane Niri Workstation

For a more controlled full-machine rebuild flow, use the central installer in
Arcane Niri mode. It is dry-run by default:

```bash
bash install/install.sh arcane-niri
```

Fetch Omarchy and Garuda Dr460nized as references without running their installers:

```bash
bash install/install.sh arcane-niri --references
```

Apply this repo's actual stack only with explicit flags:

```bash
bash install/install.sh arcane-niri --apply --core
```

Full reference audit plus local install flow:

```bash
bash install/install.sh arcane-niri --apply --all
```

The orchestrator does not execute `curl -fsSL https://omarchy.org/install | bash`. Omarchy and Garuda Dr460nized are treated as references; this repo remains the source of truth.

Read:

- `docs/workflow/reinstall-arcane-desktop.md`
- `docs/workflow/arcane-niri-workstation-installer.md`
- `docs/workflow/package-audit-policy.md`
- `docs/workflow/service-enable-policy.md`
- `docs/workflow/upstream-reference-audit.md`
- `docs/workflow/amd-arcane-desktop.md`
- `docs/references/electronics-learning.md`
- `docs/credits/omarchy-dr460nized.md`
- `docs/credits/upstream-reference-boundary.md`
