# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this repo is

Personal dotfiles for a Fedora rpm-ostree workstation running a Hyprland desktop ("Grothmar Valley" rice). Two outputs:

1. Configuration files installed into `$HOME` via symlinks.
2. An RPM meta-package (`dhenley-rice-meta`) that pulls in every layered system package the rice depends on, so the host side of the rice can be installed/removed in a single `rpm-ostree` transaction.

## Common commands

```bash
./install.sh                              # symlink config/* → $XDG_CONFIG_HOME, home/* → $HOME
make -C packages/dhenley-rice-meta rpm    # build the meta-package RPM (requires podman)
make -C packages/dhenley-rice-meta clean  # remove dist/ and .rpmbuild/
```

The RPM is built inside a `registry.fedoraproject.org/fedora:44` container via podman — no host-side `rpm-build` install needed. Output lands in `packages/dhenley-rice-meta/dist/`.

## Architecture

### `install.sh` symlink semantics

`install.sh` walks `config/` and `home/` at depth 1 and symlinks each entry into `$XDG_CONFIG_HOME` (default `~/.config`) and `$HOME` respectively. Per-entry behavior:

- Existing symlink already pointing at the repo path → left alone.
- Existing symlink pointing elsewhere → replaced.
- Existing real file/directory → renamed to `<name>.bak.<timestamp>` before linking.

Because linking is at depth 1, *the entire `~/.config/<app>` directory becomes a symlink to this repo*. Anything an app writes back into that directory (caches, runtime state) lands inside the repo. The `.gitignore` excludes `*.bak`, `.rpmbuild/`, `dist/`, and `*.rpm` but does not blanket-ignore app-generated state — if you add a config tree for an app that writes runtime files into it, add ignores explicitly.

### Adding a new dotfile

- A `~/.config/<app>` directory → put the directory at `config/<app>/`. The whole directory becomes one symlink.
- A `~/.<file>` → put it at `home/.<file>`.
- No edits to `install.sh` are required; it discovers entries dynamically.
- Anything that doesn't fit those two patterns (e.g. files that need to land inside a wildcarded profile path) lives under `apps/<app>/`, with an explicit special-case in `install.sh`. Current examples:
  - `apps/zen/userChrome.css` is symlinked into `~/.var/app/app.zen_browser.zen/.zen/<profile>/chrome/userChrome.css` for every profile (Zen also requires `toolkit.legacyUserProfileCustomizations.stylesheets=true` in `about:config`).
  - `apps/material-symbols/*.ttf` is symlinked into `~/.local/share/fonts/`, then `fc-cache -f` runs to register the variable font (used by `config/quickshell/MaterialIcon.qml`).
  - `apps/material-symbols/icons/` is **not** in git (`.gitignore`'d). Names listed in `apps/material-symbols/icons.list` are fetched from `google/material-design-icons` on every `install.sh` run (idempotent — existing files are left alone) and recolored with the parchment fill (`#F5DEB3`). Add a glyph to use in rofi rows by appending its symbol name to `icons.list` and re-running `./install.sh`.

### `dhenley-rice-meta` package

`.spec` is an empty `noarch` package whose only purpose is its `Requires:` list. Adding/removing a package from the rice means editing the `Requires:` block in `dhenley-rice-meta.spec`, bumping `Version:`, and adding a `%changelog` entry — then rebuild and `rpm-ostree install` the new RPM. Treat this file as the source of truth for which system packages the rice depends on; `install.sh` only handles user-level config.

Some `Requires:` come from third-party Copr repos rather than Fedora's official repos. The spec marks these with a `# Requires copr <owner>/<project>` comment immediately above the dependency. Before `rpm-ostree install dhenley-rice-meta-*.rpm` will resolve, the matching `.repo` files must be present under `/etc/yum.repos.d/` — fetch each one from `https://copr.fedorainfracloud.org/coprs/<owner>/<project>/repo/fedora-44/<owner>-<project>-fedora-44.repo`. Currently required Coprs:

- `lionheartp/Hyprland` — strict source for `hyprland`, `hyprland-guiutils`, `hyprpaper`, `xdg-desktop-portal-hyprland` (not in Fedora main); also provides newer `kitty` and `quickshell` than Fedora's, which the rice prefers (Copr ranks above `fedora` repo by default).
- `mo-k12/personal` — for `xdg-desktop-portal-termfilechooser`.
- `lihaohong/yazi` — for `yazi`.

### Spicetify (Spotify theming)

`spicetify-cli` is installed inside a `spicetify` toolbox container (Fedora 44). Spotify itself is a **user-scope** flatpak (not system) — that's a hard requirement so spicetify can write `xpui.spa` as the user. `~/.config/spicetify` is symlinked into `config/spicetify/` here; `Themes/Grothmar/color.ini` re-expresses the Grothmar palette as Spicetify color slots and is what `current_theme = Grothmar` / `color_scheme = base` in `config-xpui.ini` selects.

After every Spotify auto-update the patch is wiped — re-run `toolbox run --container spicetify spicetify apply` to restore it. If `palette.conf` colors change, also update `config/spicetify/Themes/Grothmar/color.ini` and re-apply.

### Theme cohesion

The "Grothmar Valley" palette is defined once in `config/hypr/palette.conf` (Hyprland variables: `$twilight`, `$ember`, `$parchment`, etc.) and re-expressed as raw hex in app configs that can't `source` it (`config/mako/config`, `config/rofi/grothmar.rasi`, kitty themes under `config/kitty/kitty-themes/themes/Grothmar.conf`, `config/quickshell/Theme.qml`). When changing palette colors, update `palette.conf` *and* every app config that hardcodes the same hex — they are not auto-synchronized. Within quickshell itself, all components import the singleton `Theme` from `qmldir`, so the palette lives in one place per-app.

### Quickshell layout

`config/quickshell/` is composed of three independent layer-shell panels — there is no perimeter wrap. `shell.qml` filters `Quickshell.screens` to the primary screen and instantiates one `Scope` containing:

- `LeftBar.qml` — full-height left-edge `PanelWindow` reserving `Theme.barWidth + Theme.spacing` via `exclusiveZone`. It paints only a centered rounded "island" (`Theme.wrapColor`, `Theme.rounding`) covering the middle 80% of the screen height, with a small inset from the screen edge. Hosts `Bar.qml` (a `ColumnLayout` of widgets with a `Layout.fillHeight` spacer dividing top-aligned launchers from bottom-aligned clock/power).
- `SpotifyPanel.qml` — full-width top-edge `PanelWindow` with `exclusionMode: ExclusionMode.Ignore` and a multi-rect `mask` containing a thin invisible trigger strip at `y=0` plus the widget bounds when open. Hovering the strip (or the widget itself, or dragging its slider) slides `SpotifyWidget` down from `y=-implicitHeight` to `y=0`. Trigger strip mask collapses to width 0 when no track is playing.
- `VolumePanel.qml` — right-edge `PanelWindow` (top+right+bottom anchored, `width = popout.implicitWidth + triggerWidth`) with the same trigger-strip-plus-popout-bounds mask pattern. Hovering the right-edge strip (or the popout itself) slides `VolumePopout` in from `x=root.width` to `x=0`.
- `SpotifyWidget` and `VolumePopout` are pure visual/interaction components — they don't position themselves; their parent panel animates their `y`/`x` via `Behavior` based on a hover-derived `open` property.

All three panels live on the layer-shell Top layer (Quickshell default). Tiled clients respect `LeftBar`'s `exclusiveZone`, so they can't cover the bar; the Spotify and Volume panels use `Ignore` mode and only capture input where their masks live, so the rest of the screen passes through to apps below.

When adding a new edge widget, mirror the `SpotifyPanel`/`VolumePanel` pattern: a `PanelWindow` with `Ignore` exclusion, a mask containing a thin always-on trigger strip plus a conditional bounds region for the widget, and `Behavior on x/y` on the widget bound to `panel.open`. Components are registered in `qmldir` and styled via the `Theme` singleton.
