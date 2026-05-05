Name:           dhenley-rice-meta
Version:        0.5.0
Release:        1%{?dist}
Summary:        Meta-package aggregating dhenley's Hyprland rice layered packages
License:        MIT
BuildArch:      noarch

# Requires copr lionheartp/Hyprland
Requires:       hyprland
Requires:       hyprland-guiutils
Requires:       hyprpaper
Requires:       hyprshutdown
Requires:       hyprqt6engine
Requires:       xdg-desktop-portal-hyprland
# Also from copr lionheartp/Hyprland (newer than Fedora main):
Requires:       kitty
Requires:       quickshell

Requires:       mako
Requires:       rofi-wayland
Requires:       playerctl

# Requires copr mo-k12/personal
Requires:       xdg-desktop-portal-termfilechooser
# Requires copr lihaohong/yazi
Requires:       yazi

%description
Empty meta-package whose dependencies are the set of packages dhenley
wants layered on rpm-ostree for the Hyprland rice. Install/uninstall
this single package via rpm-ostree to enable/disable the entire rice
in one transaction.

%files

%changelog
* Tue May 05 2026 Devereux Henley <devereux.henley@gmail.com> - 0.5.0-1
- Add playerctl for the Quickshell Spotify widget (MPRIS control).

* Mon May 04 2026 Devereux Henley <devereux.henley@gmail.com> - 0.4.0-1
- Add hyprshutdown (graceful logout/shutdown) and hyprqt6engine
  (Qt6 theme provider) from copr lionheartp/Hyprland.

* Mon May 04 2026 Devereux Henley <devereux.henley@gmail.com> - 0.3.0-1
- Add yazi (copr: lihaohong/yazi) and xdg-desktop-portal-termfilechooser
  (copr: mo-k12/personal). Both COPRs must be enabled before layering.

* Sun May 03 2026 Devereux Henley <devereux.henley@gmail.com> - 0.2.0-1
- Add hyprpaper for wallpaper management

* Sun May 03 2026 Devereux Henley <devereux.henley@gmail.com> - 0.1.0-1
- Initial meta-package: hyprland, hyprland-guiutils, kitty, mako,
  quickshell, rofi-wayland, xdg-desktop-portal-hyprland
