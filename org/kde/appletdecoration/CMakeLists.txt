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
)

qt_add_qml_module(
    tmp_module
    URI org.kde.appletdecoration
    VERSION 1.0

    # [PAST_MAJOR_VERSIONS ...]
    # [STATIC | SHARED]
    PLUGIN_TARGET tmp_module

    # [OUTPUT_DIRECTORY output_dir]
    # [RESOURCE_PREFIX resource_prefix]
    # [CLASS_NAME class_name]
    # [TYPEINFO typeinfo]
    # IMPORTS QtGui QtQuick

    # [OPTIONAL_IMPORTS ...]
    # [DEFAULT_IMPORTS ...]
    # [DEPENDENCIES ...]
    # [IMPORT_PATH ...]
    SOURCES ${appletdecoration_SRCS}
    QML_FILES qml/AuroraeButton.qml

    # [RESOURCES ...]
    # [OUTPUT_TARGETS out_targets_var]
    # [DESIGNER_SUPPORTED]
    # [FOLLOW_FOREIGN_VERSIONING]
    # [NAMESPACE namespace]
    # [NO_PLUGIN]
    # [NO_PLUGIN_OPTIONAL]
    # [NO_CREATE_PLUGIN_TARGET]
    # [NO_GENERATE_PLUGIN_SOURCE]
    # [NO_GENERATE_QMLTYPES]
    # [NO_GENERATE_QMLDIR]
    # [NO_LINT]
    # [NO_CACHEGEN]
    # [NO_RESOURCE_TARGET_PATH]
    # [NO_IMPORT_SCAN]
    # [ENABLE_TYPE_COMPILER]
    # [TYPE_COMPILER_NAMESPACE namespace]
    # [QMLTC_EXPORT_DIRECTIVE export_macro]
    # [QMLTC_EXPORT_FILE_NAME header_defining_export_macro]
)

target_link_libraries(tmp_module PRIVATE
    Qt6::Quick
    KF6::CoreAddons
    KF6::ConfigWidgets
    KF6::I18n
    KF6::Service
    KF6::Svg
    KF6::KCMUtils
    Plasma::Plasma
    KDecoration2::KDecoration
    KDecoration2::KDecoration2Private
)

# add_library(appletdecorationplugin SHARED ${appletdecoration_SRCS})

# target_link_libraries(appletdecorationplugin
# Qt6::Core
# Qt6::DBus
# Qt6::Widgets
# Qt6::Quick
# KF6::CoreAddons
# KF6::ConfigWidgets
# KF6::I18n
# Plasma::Plasma
# KF6::Service
# KF6::Svg
# KF6::KCMUtils
# KDecoration2::KDecoration
# KDecoration2::KDecoration2Private
# )

# # install plugin
# install(TARGETS appletdecorationplugin DESTINATION ${KDE_INSTALL_QMLDIR}/org/kde/appletdecoration)

# install(DIRECTORY qml/ DESTINATION ${KDE_INSTALL_QMLDIR}/org/kde/appletdecoration)

# install(FILES qmldir DESTINATION ${KDE_INSTALL_QMLDIR}/org/kde/appletdecoration)
