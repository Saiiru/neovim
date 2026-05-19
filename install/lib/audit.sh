#!/usr/bin/env bash
# Installer Audit Library (KORA-03)

audit_symlink() {
    local src="$1"
    local dst="$2"
    
    if [[ ! -e "$dst" ]]; then
        printf "[MISSING] %s\n" "$dst"
        return 1
    fi

    if [[ ! -L "$dst" ]]; then
        printf "[WRONG_TYPE] %s (Expected symlink)\n" "$dst"
        return 1
    fi

    local current_src
    current_src=$(readlink -f "$dst")
    if [[ "$current_src" != "$(readlink -f "$src")" ]]; then
        printf "[MISMATCH] %s -> %s (Expected: %s)\n" "$dst" "$current_src" "$src"
        return 1
    fi

    printf "[OK] %s\n" "$dst"
}

audit_package() {
    local pkg="$1"
    if command -v pacman >/dev/null; then
        if pacman -Qi "$pkg" >/dev/null 2>&1; then
            printf "[OK] Package: %s\n" "$pkg"
        else
            printf "[MISSING] Package: %s\n" "$pkg"
        fi
    fi
}
