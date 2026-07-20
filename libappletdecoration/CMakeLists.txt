# SPDX-FileCopyrightText: 2018 Michail Vourlakos <mvourlakos@gmail.com>
# SPDX-License-Identifier: GPL-2.0-or-later
cmake_minimum_required(VERSION 3.20 FATAL_ERROR)

find_package(ECM ${KF6_MIN_VERSION} REQUIRED NO_MODULE)
set(CMAKE_MODULE_PATH ${ECM_MODULE_PATH} ${ECM_KDE_MODULE_DIR})

set(kwin_xml "${KDE_INSTALL_FULL_DBUSINTERFACEDIR}/org.kde.KWin.xml")
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
find_package(KDecoration3 ${KDecoration3_MIN_VERSION} REQUIRED)

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
    KDecoration3::KDecoration
    KDecoration3::KDecoration3Private
)

# install plugin
install(TARGETS appletdecorationplugin DESTINATION ${KDE_INSTALL_QMLDIR}/org/kde/appletdecoration)

install(DIRECTORY qml/ DESTINATION ${KDE_INSTALL_QMLDIR}/org/kde/appletdecoration)

install(FILES qmldir DESTINATION ${KDE_INSTALL_QMLDIR}/org/kde/appletdecoration)
