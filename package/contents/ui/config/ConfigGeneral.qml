/*
*  Copyright 2018 Michail Vourlakos <mvourlakos@gmail.com>
*
*  This file is part of applet-window-buttons
*
*  Latte-Dock is free software; you can redistribute it and/or
*  modify it under the terms of the GNU General Public License as
*  published by the Free Software Foundation; either version 2 of
*  the License, or (at your option) any later version.
*
*  Latte-Dock is distributed in the hope that it will be useful,
*  but WITHOUT ANY WARRANTY; without even the implied warranty of
*  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
*  GNU General Public License for more details.
*
*  You should have received a copy of the GNU General Public License
*  along with this program.  If not, see <http://www.gnu.org/licenses/>.
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
    //property var title
    // used as bridge to communicate properly between configuration and ui
    property bool useCurrent
    property string selectedPlugin
    property string selectedScheme
    property string selectedTheme
    property string currentButtons
    // used from the ui
    readonly property bool selectedDecorationExists: decorations.decorationExists(root.selectedPlugin, root.selectedTheme)
    readonly property real centerFactor: 0.3
    readonly property int minimumWidth: 220
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

    ColumnLayout {
        id: mainColumn
        spacing: Kirigami.Units.largeSpacing
        Layout.fillWidth: true

        RowLayout {
            QQC2.Label {
                Layout.minimumWidth: Math.max(centerFactor * root.width, minimumWidth)
                text: i18n("Decoration:")
                horizontalAlignment: Text.AlignRight
            }

            DecorationsComboBox {
                id: decorationCmb

                Layout.minimumWidth: 180
                Layout.preferredWidth: 0.2 * root.width
                Layout.maximumWidth: 300
            }

        }

        RowLayout {
            visible: !auroraeThemeEngine.isEnabled

            QQC2.Label {
                Layout.minimumWidth: Math.max(centerFactor * root.width, minimumWidth)
                text: i18n("Colors:")
                horizontalAlignment: Text.AlignRight
            }

            ColorsComboBox {
                id: colorsCmbBox

                Layout.minimumWidth: 250
                Layout.preferredWidth: 0.3 * root.width
                Layout.maximumWidth: 380
                model: colorsModel
                textRole: "display"
                Component.onCompleted: {
                    currentIndex = colorsModel.indexOf(plasmoid.configuration.selectedScheme);
                }
            }

        }

        GridLayout {
            rowSpacing: Kirigami.Units.largeSpacing
            columnSpacing: Kirigami.Units.largeSpacing
            columns: 2

            QQC2.Label {
                Layout.minimumWidth: Math.max(centerFactor * root.width, minimumWidth)
                text: i18n("Buttons:")
                horizontalAlignment: Text.AlignRight
            }

            OrderableListView {
                id: activeButtons

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

        }

        ColumnLayout {
            id: visualSettings

            GridLayout {
                id: visualSettingsGroup1

                columns: 2

                QQC2.Label {
                    Layout.minimumWidth: Math.max(centerFactor * root.width, minimumWidth)
                    text: i18n("Metrics:")
                    horizontalAlignment: Text.AlignRight
                    visible: auroraeThemeEngine.isEnabled
                }

                QQC2.CheckBox {
                    id: decorationMetricsChk

                    text: i18n("Use from decoration if any are found")
                    visible: auroraeThemeEngine.isEnabled
                }

                QQC2.Label {
                    Layout.minimumWidth: Math.max(centerFactor * root.width, minimumWidth)
                    text: i18n("Size:")
                    horizontalAlignment: Text.AlignRight
                    enabled: !(auroraeThemeEngine.isEnabled && decorationMetricsChk.checked)
                }

                QQC2.SpinBox {
                    id: buttonSizeSpn

                    from: 40
                    to: 100
                    // suffix: " %"
                    enabled: !(auroraeThemeEngine.isEnabled && decorationMetricsChk.checked)
                }

                QQC2.Label {
                    Layout.minimumWidth: Math.max(centerFactor * root.width, minimumWidth)
                    text: i18n("Spacing:")
                    horizontalAlignment: Text.AlignRight
                    enabled: !(auroraeThemeEngine.isEnabled && decorationMetricsChk.checked)
                }

                QQC2.SpinBox {
                    id: spacingSpn

                    from: 0
                    to: 24
                    // suffix: " " + i18nc("pixels","px.")
                    enabled: !(auroraeThemeEngine.isEnabled && decorationMetricsChk.checked)
                }

            }

            GridLayout {
                id: visualSettingsGroup2

                property int lockerHeight: firstLengthLbl.height + rowSpacing / 2

                columns: 3
                rows: 2
                flow: GridLayout.TopToBottom
                columnSpacing: visualSettingsGroup1.columnSpacing
                rowSpacing: visualSettingsGroup1.rowSpacing

                QQC2.Label {
                    id: firstLengthLbl

                    Layout.minimumWidth: Math.max(centerFactor * root.width, minimumWidth)
                    text: plasmoid.configuration.formFactor === PlasmaCore.Types.Horizontal ? i18n("Left margin:") : i18n("Top margin:")
                    horizontalAlignment: Text.AlignRight
                }

                QQC2.Label {
                    Layout.minimumWidth: Math.max(centerFactor * root.width, minimumWidth)
                    text: plasmoid.configuration.formFactor === PlasmaCore.Types.Horizontal ? i18n("Right margin:") : i18n("Bottom margin:")
                    horizontalAlignment: Text.AlignRight
                    enabled: !lockItem.locked
                }

                QQC2.SpinBox {
                    // suffix: " " + i18nc("pixels","px.")

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

                QQC2.SpinBox {
                    id: lengthLastSpn

                    from: 0
                    to: 24
                    // suffix: " " + i18nc("pixels","px.")
                    enabled: !lockItem.locked
                }

                LockItem {
                    id: lockItem

                    Layout.minimumWidth: 40
                    Layout.maximumWidth: 40
                    Layout.alignment: Qt.AlignTop | Qt.AlignLeft
                    Layout.minimumHeight: visualSettingsGroup2.lockerHeight
                    Layout.maximumHeight: Layout.minimumHeight
                    Layout.topMargin: firstLengthLbl.height / 2
                    Layout.rowSpan: 2
                }

            }

        }

    }

}
