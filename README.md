# Window Buttons Applet

This is a Plasma 6 applet that shows window buttons in your panels. This plasmoid was initially coming from [Latte land](https://phabricator.kde.org/source/latte-dock/repository/master/) but it can also support Plasma panels.


# Requires

- C++20 compiler (GCC 10+, Clang 12+)
- CMake >= 3.20
- Qt >= 6.10
- KF6 >= 6.22
- Plasma >= 6.6
- KDecoration3 >= 6.2.90

**Qt6 modules**: Core DBus Gui Qml Quick Widgets

**KF6 modules**: CoreAddons Config ConfigWidgets Declarative I18n KCMUtils Package Service Svg

**Build tools**: extra-cmake-modules ninja


# Install

You can execute `sh install.sh` in the root directory as long as you have installed the previous mentioned development packages. For more details please read [INSTALLATION.md](/INSTALLATION.md)
