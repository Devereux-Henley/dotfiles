# dotfiles

Personal Hyprland rice for Fedora rpm-ostree, themed "Grothmar Valley".

Two outputs:

- Configuration files installed into `$HOME` via symlinks (`./install.sh`).
- An RPM meta-package (`packages/dhenley-rice-meta`) pulling in every layered system
  package the rice depends on, so the host side installs/removes in a single
  `rpm-ostree` transaction.

## Layout

| Path | Purpose |
| --- | --- |
| `config/<app>/` | Symlinked into `~/.config/<app>` (whole directory becomes one symlink). |
| `home/.<file>` | Symlinked into `~/.<file>`. |
| `apps/<app>/` | Special-cased installs handled inline in `install.sh` (Zen `userChrome.css`, Material Symbols font). |
| `packages/dhenley-rice-meta/` | Spec for the meta-package (source of truth for layered system packages). |

## Install

```bash
./install.sh                              # symlink configs and fonts into $HOME
make -C packages/dhenley-rice-meta rpm    # build the meta-package RPM (podman)
```

See `CLAUDE.md` for architectural notes (palette plumbing, Quickshell panel layout, Spicetify/Zen specifics, Copr provenance).

## Inspiration

The Quickshell icon strategy — Material Symbols Rounded as a variable font with
per-instance `FILL`/`GRAD`/`opsz`/`wght` axes, rendered as text glyphs rather
than SVG — is borrowed from
[caelestia-dots/shell](https://github.com/caelestia-dots/shell). The
`MaterialIcon.qml` component mirrors theirs.
