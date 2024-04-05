cmake_minimum_required(VERSION 3.20 FATAL_ERROR)
project(applet_windowbuttons)

cmake_policy(SET CMP0071 NEW)
cmake_policy(SET CMP0160 OLD) # IMPORTED property is read-only for targets

set(CMAKE_CXX_STANDARD 14)
set(VERSION 0.12.0)
set(AUTHOR "Michail Vourlakos")
set(EMAIL "mvourlakos@gmail.com")

set(QT_MIN_VERSION "6.6.0")
set(KF6_MIN_VERSION "6.0.0")
set(KDECORATION2_MIN_VERSION "5.90")
set(PLASMA_MIN_VERSION "5.90")

find_package(ECM ${KF6_MIN_VERSION} REQUIRED NO_MODULE)

set(CMAKE_MODULE_PATH ${ECM_MODULE_PATH} ${ECM_KDE_MODULE_DIR})

find_package(Qt6 ${QT_MIN_VERSION} CONFIG REQUIRED NO_MODULE COMPONENTS Gui Qml Quick DBus Widgets)
find_package(KF6 ${KF6_MIN_VERSION} REQUIRED COMPONENTS CoreAddons Declarative Package Svg I18n Service ConfigWidgets KCMUtils)
find_package(Plasma ${PLASMA_MIN_VERSION} REQUIRED)
find_package(KDecoration2 ${KDECORATION2_MIN_VERSION} REQUIRED)

include(ECMFindQmlModule)
include(CheckIncludeFiles)
include(KDECMakeSettings)
include(KDEInstallDirs)
include(KDECompilerSettings)

set(KDECORATION2_VERSION_MAJOR ${KDecoration2_VERSION_MAJOR})
set(KDECORATION2_VERSION_MINOR ${KDecoration2_VERSION_MINOR})

message(STATUS "KDecoration2 Version: ${KDECORATION2_VERSION_MAJOR}.${KDECORATION2_VERSION_MINOR}")

configure_file(
    ${CMAKE_CURRENT_SOURCE_DIR}/org/kde/appletdecoration/config-decoration.h.cmake
    ${CMAKE_CURRENT_BINARY_DIR}/org/kde/appletdecoration/config-decoration.h
)

qt_standard_project_setup()

add_subdirectory(org/kde/appletdecoration)

plasma_install_package(package org.kde.windowbuttons)
