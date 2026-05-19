# KORA-03 Dotfiles Architecture

## Principle

This repository is the source of truth for a Linux workstation.

It does not distinguish common vs linux because the target platform is Arch Linux / Wayland / Niri.

## Layout

```text
config/   -> ~/.config
bin/      -> ~/.local/bin
install/  -> bootstrap engine
docs/     -> documentation
assets/   -> tracked lightweight assets
```

## Canonical stack

* Arch Linux
* Niri
* Quickshell (external `niriha` config)
* Kitty
* Zsh
* Tmux
* Neovim
* Yazi
* Mise
* Starship
* Atuin
* Taskwarrior / Timewarrior

## Non-goals

* No Hyprland migration.
* No KDE/Plasma migration.
* No upstream vendoring.
* No legacy tree.
* No hidden active files outside `config/`, `bin/`, and `install/`.

## Current shell state

* Legacy shell stack removed.
* Hyprland and Waybar configs removed from the active tree.
* Quickshell remains active at runtime via `~/.config/quickshell/niriha` symlink to a separately cloned repo.
* Dotfiles repo does not vendor Quickshell shell code.
* Launcher fallback remains `fuzzel` until external launcher is finalized.

## Rules

* Every active config lives in `config/`.
* Every executable user command lives in `bin/`.
* Every installer function lives in `install/`.
* Heavy assets should move to a separate repository.
* Secrets are never tracked.
