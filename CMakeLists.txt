# SPDX-FileCopyrightText: 2018 Michail Vourlakos <mvourlakos@gmail.com>
# SPDX-License-Identifier: GPL-2.0-or-later
cmake_minimum_required(VERSION 3.20 FATAL_ERROR)
project(applet_windowbuttons)

set(CMAKE_CXX_STANDARD 20)
set(VERSION 0.12.0)
set(AUTHOR "Michail Vourlakos")
set(EMAIL "mvourlakos@gmail.com")

set(QT_MIN_VERSION "6.6.0")
set(KF6_MIN_VERSION "5.246.0")
set(KDecoration3_MIN_VERSION "6.2.90")

find_package(ECM ${KF6_MIN_VERSION} REQUIRED NO_MODULE)
set(CMAKE_MODULE_PATH ${ECM_MODULE_PATH} ${ECM_KDE_MODULE_DIR})

find_package(Qt6 ${QT_MIN_VERSION} CONFIG REQUIRED NO_MODULE COMPONENTS DBus Gui Qml Quick)
find_package(KF6 ${KF6_MIN_VERSION} REQUIRED COMPONENTS CoreAddons Config Declarative Package Svg)
find_package(Plasma "5.90" REQUIRED)
find_package(KDecoration3 ${KDecoration3_MIN_VERSION} REQUIRED)

include(ECMFindQmlModule)
include(CheckIncludeFiles)
include(KDECMakeSettings)
include(KDEInstallDirs)

set(KDecoration3_VERSION_MAJOR ${KDecoration3_VERSION_MAJOR})
set(KDecoration3_VERSION_MINOR ${KDecoration3_VERSION_MINOR})

message(STATUS "KDecoration3 VERSION MAJOR : ${KDecoration3_VERSION_MAJOR}")
message(STATUS "KDecoration3 VERSION MINOR : ${KDecoration3_VERSION_MINOR}")

configure_file(${CMAKE_CURRENT_SOURCE_DIR}/libappletdecoration/config-decoration.h.cmake
    ${CMAKE_CURRENT_BINARY_DIR}/libappletdecoration/config-decoration.h)

add_subdirectory(libappletdecoration)
plasma_install_package(package org.kde.windowbuttons)
