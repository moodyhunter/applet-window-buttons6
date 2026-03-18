Installation
============

Building from Source
--------------------

The provided `install.sh` script will build everything and install it for you. Before running the installation script you have to install the dependencies needed for compiling.

### Build Dependencies

- Ubuntu 25.04+:

```bash
sudo apt install build-essential cmake extra-cmake-modules gettext qt6-base-dev qt6-declarative-dev libkf6coreaddons-dev libkf6config-dev libkf6declarative-dev libkf6package-dev libkf6svg-dev libkf6i18n-dev libkf6service-dev libkf6configwidgets-dev libkf6kcmutils-dev libplasma-dev libkdecorations3-dev
```

> Note: Ubuntu 24.04 ships KDecoration2, not KDecoration3. Building requires Ubuntu 25.04+ or the Kubuntu Backports PPA.

- openSUSE Tumbleweed:

```bash
sudo zypper install cmake gcc-c++ extra-cmake-modules gettext-tools qt6-base-devel qt6-declarative-devel kf6-kcoreaddons-devel kf6-kconfig-devel kf6-kdeclarative-devel kf6-kpackage-devel kf6-ksvg-devel kf6-ki18n-devel kf6-kservice-devel kf6-kconfigwidgets-devel kf6-kcmutils-devel plasma6-devel kdecoration6-devel
```

- Fedora:

```bash
sudo dnf install cmake gcc-c++ extra-cmake-modules gettext qt6-qtbase-devel qt6-qtdeclarative-devel kf6-kcoreaddons-devel kf6-kconfig-devel kf6-kdeclarative-devel kf6-kpackage-devel kf6-ksvg-devel kf6-ki18n-devel kf6-kservice-devel kf6-kconfigwidgets-devel kf6-kcmutils-devel libplasma-devel kdecoration-devel
```

- Arch:

```bash
sudo pacman -Syu
sudo pacman -S cmake gcc extra-cmake-modules gettext qt6-base qt6-declarative kcoreaddons kconfig kdeclarative kpackage ksvg ki18n kservice kconfigwidgets kcmutils plasma-workspace kdecoration
```

Building and Installing
-----------------------

Once you have installed the dependencies listed above you can execute the build and install script:

```bash
sh install.sh
```
