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

# Material Symbols Rounded variable font (Quickshell UI icons).
fonts_dir="$HOME/.local/share/fonts"
mkdir -p "$fonts_dir"
shopt -s nullglob
material_fonts=("$REPO_DIR/apps/material-symbols/"*.ttf)
shopt -u nullglob
if (( ${#material_fonts[@]} > 0 )); then
    for ttf in "${material_fonts[@]}"; do
        link_one "$(readlink -f "$ttf")" "$fonts_dir/$(basename "$ttf")"
    done
    if command -v fc-cache >/dev/null 2>&1; then
        fc-cache -f "$fonts_dir" >/dev/null
    fi
fi

# Zen browser (user flatpak): profile dir name is non-deterministic, so glob it.
# Requires toolkit.legacyUserProfileCustomizations.stylesheets=true in about:config.
zen_chrome_src="$REPO_DIR/apps/zen/userChrome.css"
if [[ -f "$zen_chrome_src" ]]; then
    shopt -s nullglob
    zen_profiles=("$HOME/.var/app/app.zen_browser.zen/.zen"/*/)
    shopt -u nullglob
    if (( ${#zen_profiles[@]} == 0 )); then
        echo "- zen userChrome (no profile dir yet — run Zen once, then re-run)"
    else
        for profile in "${zen_profiles[@]}"; do
            # times.json is created at profile init; metadata dirs (Crash Reports, Profile Groups) lack it.
            [[ -f "${profile}times.json" ]] || continue
            mkdir -p "${profile}chrome"
            link_one "$zen_chrome_src" "${profile}chrome/userChrome.css"
        done
    fi
fi
