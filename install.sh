#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

ts="$(date +%Y%m%d-%H%M%S)"

link_one() {
    local src_abs="$1" dest="$2"
    local name
    name="$(basename "$dest")"

    if [[ -L "$dest" ]]; then
        if [[ "$(readlink -f "$dest")" == "$src_abs" ]]; then
            echo "= $name (already linked)"
            return
        fi
        rm "$dest"
        echo "~ $name (replaced existing symlink)"
    elif [[ -e "$dest" ]]; then
        local backup="${dest}.bak.${ts}"
        mv "$dest" "$backup"
        echo "~ $name (backed up existing → $(basename "$backup"))"
    else
        echo "+ $name"
    fi

    ln -s "$src_abs" "$dest"
}

link_tree() {
    local src_root="$1" dest_root="$2"
    [[ -d "$src_root" ]] || return 0
    mkdir -p "$dest_root"
    while IFS= read -r -d '' entry; do
        local src_abs
        src_abs="$(readlink -f "$entry")"
        link_one "$src_abs" "$dest_root/$(basename "$entry")"
    done < <(find "$src_root" -mindepth 1 -maxdepth 1 -print0)
}

link_tree "$REPO_DIR/config" "${XDG_CONFIG_HOME:-$HOME/.config}"
link_tree "$REPO_DIR/home"   "$HOME"
