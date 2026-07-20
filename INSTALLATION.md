# Installation

## Building from source

Install the Plasma 6 / KDecoration3 development dependencies first. Plasma 6.4
or newer is required for the Task Manager `HasNoBorder` role used to follow
native-titlebar changes.

### Arch

```bash
sudo pacman -Syu
sudo pacman -S base-devel cmake extra-cmake-modules qt6-base qt6-declarative kcoreaddons kconfig kdecoration ksvg libplasma plasma-workspace
```

### Fedora

Package names vary by Fedora/KDE spin, but the required development families are
Qt 6, KF6, Plasma 6, KDecoration3, CMake, and ECM:

```bash
sudo dnf install gcc-c++ cmake extra-cmake-modules qt6-qtbase-devel qt6-qtdeclarative-devel kf6-kcoreaddons-devel kf6-kconfig-devel kf6-ksvg-devel plasma-workspace-devel kdecoration-devel
```

### Ubuntu / KDE neon

KDecoration3 packaging names vary across Ubuntu releases. Use KDE neon or a
Plasma 6-capable Ubuntu release and install the Qt 6, KF6, Plasma 6, and
KDecoration3 development packages available for that release.

## Building and installing

```bash
cmake -B build -S .
cmake --build build
sudo cmake --install build
systemctl --user restart plasma-plasmashell.service
```
