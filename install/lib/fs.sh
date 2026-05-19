#!/usr/bin/env bash
# Installer Filesystem Library (KORA-03)

ensure_dir() {
    local dir="$1"
    if [[ ! -d "$dir" ]]; then
        if [[ "${DRY_RUN:-false}" == "true" ]]; then
            log_dry "Would create directory: $dir"
        else
            mkdir -p "$dir"
            log_info "Created directory: $dir"
        fi
    fi
}

safe_link() {
    local src="$1"
    local dst="$2"
    
    if [[ ! -e "$src" ]]; then
        log_error "Source does not exist: $src"
        return 1
    fi

    ensure_dir "$(dirname "$dst")"

    if [[ -L "$dst" ]]; then
        local current_src
        current_src=$(readlink -f "$dst")
        if [[ "$current_src" == "$(readlink -f "$src")" ]]; then
            log_success "Link already correct: $dst"
            return 0
        fi
        log_warn "Link mismatch at $dst. Backing up..."
        backup_file "$dst"
    elif [[ -e "$dst" ]]; then
        log_warn "File exists at $dst. Backing up..."
        backup_file "$dst"
    fi

    if [[ "${DRY_RUN:-false}" == "true" ]]; then
        log_dry "Would link: $src -> $dst"
    else
        ln -sf "$src" "$dst"
        log_success "Linked: $dst -> $src"
    fi
}
