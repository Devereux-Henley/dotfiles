Name:           dhenley-rice-meta
Version:        0.2.0
Release:        1%{?dist}
Summary:        Meta-package aggregating dhenley's Hyprland rice layered packages
License:        MIT
BuildArch:      noarch

Requires:       hyprland
Requires:       hyprland-guiutils
Requires:       hyprpaper
Requires:       kitty
Requires:       mako
Requires:       quickshell
Requires:       rofi-wayland
Requires:       xdg-desktop-portal-hyprland

%description
Empty meta-package whose dependencies are the set of packages dhenley
wants layered on rpm-ostree for the Hyprland rice. Install/uninstall
this single package via rpm-ostree to enable/disable the entire rice
in one transaction.

%files

%changelog
* Sun May 03 2026 Devereux Henley <devereux.henley@gmail.com> - 0.2.0-1
- Add hyprpaper for wallpaper management

* Sun May 03 2026 Devereux Henley <devereux.henley@gmail.com> - 0.1.0-1
- Initial meta-package: hyprland, hyprland-guiutils, kitty, mako,
  quickshell, rofi-wayland, xdg-desktop-portal-hyprland
