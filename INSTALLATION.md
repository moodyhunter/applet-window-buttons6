Installation
============

## Building from Source
The provided `install.sh` script will build everything and install it for you. Before running the installation script you have to install the dependencies needed for compiling.

### Build Dependencies

- Ubuntu:
```
sudo apt install g++ extra-cmake-modules qt6-base-dev qt6-declarative-dev libkf6declarative-dev libkf6plasma-dev kf6-ksvg-dev libkdecorations2-dev gettext
```
- Fedora:
```
sudo dnf install extra-cmake-modules qt5-qtdeclarative-devel kf5-plasma-devel kf5-kdeclarative-devel kf5-kconfigwidgets-devel kf5-ki18n-devel kdecoration-devel
```
- Arch:
```
sudo pacman -Syu
sudo pacman -S gcc extra-cmake-modules plasma-framework gettext kdecoration
```

### Building and Installing
Once you have installed the dependencies listed above you can execute the build and install script:

```
sh install.sh
```

## Prebuilt Binaries

- Ubuntu: You can install via a PPA on Ubuntu 18.04 (Bionic) or later including KDE Neon.
```
sudo add-apt-repository ppa:krisives/applet-window-buttons
sudo apt install applet-window-buttons
```

- openSUSE: install the package from the official repo
```
sudo zypper in applet-window-buttons
```
