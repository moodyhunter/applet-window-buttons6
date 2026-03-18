/*
*  SPDX-FileCopyrightText: 2018 Michail Vourlakos <mvourlakos@gmail.com>
*  SPDX-FileCopyrightText: 2024 Christian Tallner <chrtall@gmx.de>
*
*  This file is part of applet-window-buttons
*
*  SPDX-License-Identifier: GPL-2.0-or-later
*/

import QtQuick
import QtQuick.Layouts
import QtQuick.Controls as QQC2
import org.kde.kcmutils as KCM
import org.kde.kirigami as Kirigami
import org.kde.kitemmodels
import org.kde.plasma.components as PlasmaComponents
import org.kde.plasma.core as PlasmaCore
import org.kde.appletdecoration as AppletDecoration

KCM.SimpleKCM {
    id: root

    property alias cfg_useCurrentDecoration: root.useCurrent
    property alias cfg_selectedPlugin: root.selectedPlugin
    property alias cfg_selectedScheme: root.selectedScheme
    property alias cfg_selectedTheme: root.selectedTheme
    property alias cfg_buttons: root.currentButtons

    property alias cfg_buttonSizePercentage: buttonSizeSpn.value
    property alias cfg_useDecorationMetrics: decorationMetricsChk.checked
    property alias cfg_spacing: spacingSpn.value
    property alias cfg_lengthFirstMargin: lengthFirstSpn.value
    property alias cfg_lengthLastMargin: lengthLastSpn.value
    property alias cfg_lengthMarginsLock: lockItem.locked

    // used as bridge to communicate properly between configuration and ui
    property bool useCurrent
    property string selectedPlugin
    property string selectedScheme
    property string selectedTheme
    property string currentButtons
    // used from the ui
    readonly property bool selectedDecorationExists: decorations.decorationExists(root.selectedPlugin, root.selectedTheme)
    property string currentPlugin: root.useCurrent || !selectedDecorationExists ? decorations.currentPlugin : root.selectedPlugin
    property string currentTheme: root.useCurrent || !selectedDecorationExists ? decorations.currentTheme : root.selectedTheme

    onSelectedPluginChanged: {
        console.log("Selected Plugin CHanged: ", root.selectedPlugin)
    }

    ///START Decoration Items
    AppletDecoration.Bridge {
        id: bridgeItem

        plugin: currentPlugin
        theme: currentTheme
    }

    AppletDecoration.Settings {
        id: settingsItem

        bridge: bridgeItem.bridge
        borderSizesIndex: 0
    }

    AppletDecoration.SharedDecoration {
        id: sharedDecorationItem

        bridge: bridgeItem.bridge
        settings: settingsItem
    }

    AppletDecoration.AuroraeTheme {
        id: auroraeThemeEngine

        readonly property bool isEnabled: decorations.isAurorae(root.currentPlugin, root.currentTheme)

        theme: isEnabled ? currentTheme : ""
    }

    AppletDecoration.DecorationsModel {
        id: decorations
    }

    AppletDecoration.ColorsModel {
        id: colorsModel
    }

    AppletDecoration.PlasmaThemeExtended {
        id: plasmaThemeExtended

        readonly property bool isActive: selectedScheme === "_plasmatheme_"
    }

    SystemPalette {
        id: palette
    }

    // sort decorations based on display name
    KSortFilterProxyModel {
        id: sortedDecorations

        sourceModel: decorations
        sortRoleName: 'display'
        sortOrder: Qt.AscendingOrder
    }
    ///END Decoration Items

    Kirigami.FormLayout {

        // --- Decoration ---
        DecorationsComboBox {
            id: decorationCmb
            Kirigami.FormData.label: i18n("Decoration:")
            Layout.fillWidth: true
            Layout.maximumWidth: Kirigami.Units.gridUnit * 25
        }

        // --- Colors ---
        ColorsComboBox {
            id: colorsCmbBox
            Kirigami.FormData.label: i18n("Colors:")
            visible: !auroraeThemeEngine.isEnabled
            Layout.fillWidth: true
            Layout.maximumWidth: Kirigami.Units.gridUnit * 25
            model: colorsModel
            textRole: "display"
            Component.onCompleted: {
                currentIndex = colorsModel.indexOf(plasmoid.configuration.selectedScheme);
            }
        }

        // --- Buttons ---
        OrderableListView {
            id: activeButtons
            Kirigami.FormData.label: i18n("Buttons:")

            readonly property color schemesBackgroundColor: plasmaThemeExtended.isActive ? plasmaThemeExtended.colors.backgroundColor : colorsModel.backgroundOf(colorsCmbBox.currentIndex)

            itemWidth: 38
            itemHeight: 38
            buttonsStr: root.currentButtons
            orientation: ListView.Horizontal
            color: !auroraeThemeEngine.isEnabled ? schemesBackgroundColor : auroraeThemeEngine.titleBackgroundColor
            buttonSize: buttonSizeSpn.value
            buttonsFirstMargin: lengthFirstSpn.value
            buttonsLastMargin: lengthLastSpn.value
            buttonsSpacing: spacingSpn.value
        }

        Kirigami.Separator {
            Kirigami.FormData.isSection: true
        }

        // --- Metrics (Aurorae only) ---
        QQC2.CheckBox {
            id: decorationMetricsChk
            Kirigami.FormData.label: i18n("Metrics:")
            text: i18n("Use from decoration if any are found")
            visible: auroraeThemeEngine.isEnabled
        }

        // --- Size ---
        QQC2.SpinBox {
            id: buttonSizeSpn
            Kirigami.FormData.label: i18n("Size:")
            from: 40
            to: 100
            enabled: !(auroraeThemeEngine.isEnabled && decorationMetricsChk.checked)
        }

        // --- Spacing ---
        QQC2.SpinBox {
            id: spacingSpn
            Kirigami.FormData.label: i18n("Spacing:")
            from: 0
            to: 24
            enabled: !(auroraeThemeEngine.isEnabled && decorationMetricsChk.checked)
        }

        // --- Left / Top margin ---
        RowLayout {
            Kirigami.FormData.label: plasmoid.configuration.formFactor === PlasmaCore.Types.Horizontal ? i18n("Left margin:") : i18n("Top margin:")

            QQC2.SpinBox {
                id: lengthFirstSpn

                property int lastValue: -1

                from: 0
                to: 24
                onValueChanged: {
                    if (lockItem.locked) {
                        var step = value - lastValue > 0 ? 1 : -1;
                        lastValue = value;
                        lengthLastSpn.value = lengthLastSpn.value + step;
                    }
                }
                Component.onCompleted: {
                    lastValue = plasmoid.configuration.lengthFirstMargin;
                }
            }

            QQC2.ToolButton {
                id: lockItem

                property bool locked: true

                icon.name: locked ? "lock" : "unlock"
                opacity: locked ? 1.0 : 0.5
                onClicked: locked = !locked
            }
        }

        // --- Right / Bottom margin ---
        QQC2.SpinBox {
            id: lengthLastSpn
            Kirigami.FormData.label: plasmoid.configuration.formFactor === PlasmaCore.Types.Horizontal ? i18n("Right margin:") : i18n("Bottom margin:")

            from: 0
            to: 24
            enabled: !lockItem.locked
        }
    }

}
