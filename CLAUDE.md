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

### `dhenley-rice-meta` package

`.spec` is an empty `noarch` package whose only purpose is its `Requires:` list. Adding/removing a package from the rice means editing the `Requires:` block in `dhenley-rice-meta.spec`, bumping `Version:`, and adding a `%changelog` entry — then rebuild and `rpm-ostree install` the new RPM. Treat this file as the source of truth for which system packages the rice depends on; `install.sh` only handles user-level config.

### Theme cohesion

The "Grothmar Valley" palette is defined once in `config/hypr/palette.conf` (Hyprland variables: `$twilight`, `$ember`, `$parchment`, etc.) and re-expressed as raw hex in app configs that can't `source` it (`config/mako/config`, `config/rofi/grothmar.rasi`, kitty themes under `config/kitty/kitty-themes/themes/Grothmar.conf`, `config/quickshell/Theme.qml`). When changing palette colors, update `palette.conf` *and* every app config that hardcodes the same hex — they are not auto-synchronized. Within quickshell itself, all components import the singleton `Theme` from `qmldir`, so the palette lives in one place per-app.

### Quickshell viewport layout

`config/quickshell/` follows the Caelestia-style "viewport" pattern, not a plain anchored panel:

- `shell.qml` instantiates a `Variants { model: Quickshell.screens }` so each monitor gets its own `Scope` containing one `ContentWindow` and four `EdgeExclusion` sidecars (one per edge).
- `ContentWindow.qml` is a full-screen `PanelWindow` with `exclusionMode: ExclusionMode.Ignore` and a multi-rect `mask: Region { ... }` covering only the four perimeter strips — clicks in the inner cutout pass through to apps below. The window paints the four `Theme.twilight` strips that form the wrap, places `RoundCorner` overlays at each inner corner of the cutout to fillet them, and hosts `Bar.qml` (a `ColumnLayout` of widgets with a `Layout.fillHeight` spacer dividing top-aligned launchers from bottom-aligned clock/power) inset into the left strip.
- `EdgeExclusion.qml` is an invisible 1×1 sidecar `PanelWindow` parameterized by `edge` (`"top"`/`"right"`/`"bottom"`/`"left"`) whose only job is to set `exclusiveZone: Theme.barWidth` so the compositor reserves space for that side of the wrap. ContentWindow itself reserves nothing.
- `RoundCorner.qml` is a Canvas-based component that paints an L-shape with a quarter-circle cutout in one of four orientations; positioned at each inner corner of the cutout, it rounds the cutout corner with the wrap's `Theme.twilight` color.
- Components (`AppLauncher`, `PowerButton`, `Clock`) are registered in `qmldir` and styled via the `Theme` singleton.

When adding a new popout, paint it inside `ContentWindow` (so it shares the masked surface) and extend the `mask` Region to cover its bounds. Don't put `exclusiveZone` on `ContentWindow`, or the masked-passthrough invariant breaks — add or adjust an `EdgeExclusion` sidecar instead.
