Installation
============

## Building from Source
The provided `install.sh` script will build everything and install it for you. Before running the installation script you have to install the dependencies needed for compiling.

### Build Dependencies

- Ubuntu:
```
sudo apt install g++ cmake extra-cmake-modules qt6-base-dev qt6-declarative-dev libkf6declarative-dev libkf6coreaddons-dev libkf6config-dev libkf6package-dev kf6-ksvg-dev libkdecorations3-dev gettext
```
- Fedora:
```
sudo dnf install gcc-c++ cmake extra-cmake-modules qt6-qtdeclarative-devel kf6-kcoreaddons-devel kf6-kconfig-devel kf6-kdeclarative-devel kf6-kpackage-devel kf6-ksvg-devel kdecoration-devel plasma-devel
```
- Arch:
```
sudo pacman -Syu
sudo pacman -S gcc cmake extra-cmake-modules qt6-declarative kf6-coreaddons kf6-config kf6-declarative kf6-package kf6-svg kdecoration plasma
```

### Building and Installing
Once you have installed the dependencies listed above you can execute the build and install script:

```
sh install.sh
```
