# SPDX-FileCopyrightText: 2018 Michail Vourlakos <mvourlakos@gmail.com>
# SPDX-License-Identifier: GPL-2.0-or-later
cmake_minimum_required(VERSION 3.10 FATAL_ERROR)

set(QT_MIN_VERSION "6.6.0")
set(KF6_MIN_VERSION "6.0.0")

find_package(ECM 0.0.11 REQUIRED NO_MODULE)
set(CMAKE_MODULE_PATH ${ECM_MODULE_PATH} ${ECM_KDE_MODULE_DIR})

set(kwin_xml /usr/${KDE_INSTALL_DBUSINTERFACEDIR}/org.kde.KWin.xml)
message(STATUS "KWIN_XML Path : ${kwin_xml}")
set(KWinConfig_SRCS)
qt_add_dbus_interface(KWinConfig_SRCS ${kwin_xml} kwin_interface )

set(appletdecoration_SRCS
    appletdecorationplugin.cpp
    auroraetheme.cpp
    buttonsmodel.cpp
    commontools.cpp
    decorationsmodel.cpp
    decorationpalette.cpp
    environment.cpp
    padding.cpp
    previewbutton.cpp
    previewbridge.cpp
    previewclient.cpp
    previewsettings.cpp
    previewshareddecoration.cpp
    schemecolors.cpp
    schemesmodel.cpp
    themeextended.cpp
    types.cpp
    kwinconfig.cpp
    ${KWinConfig_SRCS}
)

add_library(appletdecorationplugin SHARED ${appletdecoration_SRCS})

find_package(Qt6 ${QT_MIN_VERSION} CONFIG REQUIRED Quick DBus Widgets)
find_package(KF6 ${KF6_MIN_VERSION} REQUIRED COMPONENTS CoreAddons I18n Service ConfigWidgets KCMUtils)
find_package(KDecoration2 REQUIRED)

target_link_libraries(appletdecorationplugin
    Qt6::Core
    Qt6::DBus
    Qt6::Widgets
    Qt6::Quick
    KF6::CoreAddons
    KF6::ConfigWidgets
    KF6::I18n
    Plasma::Plasma
    KF6::Service
    KF6::Svg
    KF6::KCMUtils
    KDecoration2::KDecoration
    KDecoration2::KDecoration2Private
)

# install plugin
install(TARGETS appletdecorationplugin DESTINATION ${KDE_INSTALL_QMLDIR}/org/kde/appletdecoration)

install(DIRECTORY qml/ DESTINATION ${KDE_INSTALL_QMLDIR}/org/kde/appletdecoration)

install(FILES qmldir DESTINATION ${KDE_INSTALL_QMLDIR}/org/kde/appletdecoration)
