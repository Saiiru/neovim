#!/usr/bin/env bash
# Installer Backup Library (KORA-03)

BACKUP_DIR="$HOME/.dotfiles_backup/$(date +%Y%m%d_%H%M%S)"
MANIFEST="$BACKUP_DIR/manifest.txt"

backup_file() {
    local target="$1"
    [[ ! -e "$target" ]] && return 0

    ensure_dir "$BACKUP_DIR"
    
    local rel_path
    rel_path=$(realpath --relative-to="$HOME" "$target")
    local backup_path="$BACKUP_DIR/$rel_path"

    if [[ "${DRY_RUN:-false}" == "true" ]]; then
        log_dry "Would backup $target to $backup_path"
    else
        mkdir -p "$(dirname "$backup_path")"
        cp -a "$target" "$backup_path"
        echo "$target -> $backup_path" >> "$MANIFEST"
        log_info "Backed up: $target"
    fi
}

show_backups() {
    if [[ -d "$HOME/.dotfiles_backup" ]]; then
        ls -dt "$HOME/.dotfiles_backup"/*
    else
        log_info "No backups found."
    fi
}
