/*
 *  SPDX-FileCopyrightText: 2024 Christian Tallner <chrtall@gmx.de>
 *
 *  SPDX-License-Identifier: GPL-2.0-or-later
*/
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls as QQC2
import org.kde.kcmutils as KCM
import org.kde.kirigami as Kirigami
import org.kde.plasma.core as PlasmaCore
import org.kde.appletdecoration as AppletDecoration
import org.kde.plasma.plasmoid

KCM.SimpleKCM {
    id: root

    property alias cfg_visibility: root.visibility
    property alias cfg_hiddenState: root.hiddenState
    property alias cfg_perScreenActive: perScreenActiveChk.checked
    property alias cfg_filterByScreen: filterByScreenChk.checked
    property alias cfg_inactiveStateEnabled: inactiveChk.checked
    property alias cfg_borderlessMaximizedWindows: root.borderlessMaximizedWindows

    // used as bridge to communicate properly between configuration and ui
    property int visibility
    property int hiddenState
    property bool borderlessMaximizedWindows: kwinConfig.borderlessMaximizedWindows
    property bool initialBorderlessMaximizedWindowsValue: kwinConfig.borderlessMaximizedWindows

    Component.onCompleted: {
        if(kwinConfig.borderlessMaximizedWindows !== plasmoid.configuration.borderlessMaximizedWindows){
            root.borderlessMaximizedWindows = kwinConfig.borderlessMaximizedWindows
            plasmoid.configuration.borderlessMaximizedWindows = kwinConfig.borderlessMaximizedWindows
        }
    }

    // Signal is fired when the user clicks on the save or apply button in the config page.
    Plasmoid.configuration.onValueChanged: {
        // Only safe KWin Config if value changed.
        // Saving to KWin requires reloading KWin config, which is expensive and should be avoided.
        if (root.borderlessMaximizedWindows !== root.initialBorderlessMaximizedWindowsValue) {
            root.initialBorderlessMaximizedWindowsValue = root.borderlessMaximizedWindows
            kwinConfig.borderlessMaximizedWindows = borderlessMaximizedWindows
        }
    }

    AppletDecoration.KWinConfig {
        id: kwinConfig
    }

    Kirigami.FormLayout {
        id: form

        QQC2.RadioButton {
            id: alwaysVisibleBtn
            Kirigami.FormData.label: i18n("Show:")
            QQC2.ButtonGroup.group: visibilityBtnGroup
            text: i18n("Always visible")
            checked: root.visibility === AppletDecoration.Types.AlwaysVisible
            onCheckedChanged: {
                if (checked)
                    root.visibility = AppletDecoration.Types.AlwaysVisible;

            }
        }

        QQC2.RadioButton {
            id: activeWindowBtn
            QQC2.ButtonGroup.group: visibilityBtnGroup
            text: i18n("Active window is present")
            checked: root.visibility === AppletDecoration.Types.ActiveWindow
            onCheckedChanged: {
                if (checked)
                    root.visibility = AppletDecoration.Types.ActiveWindow;

            }
        }

        QQC2.RadioButton {
            id: activeMaximizedBtn
            QQC2.ButtonGroup.group: visibilityBtnGroup
            text: i18n("Active window is maximized")
            checked: root.visibility === AppletDecoration.Types.ActiveMaximizedWindow
            onCheckedChanged: {
                if (checked)
                    root.visibility = AppletDecoration.Types.ActiveMaximizedWindow;

            }
        }

        QQC2.RadioButton {
            id: shownWindowBtn
            QQC2.ButtonGroup.group: visibilityBtnGroup
            text: i18n("At least one window is shown")
            checked: root.visibility === AppletDecoration.Types.ShownWindowExists
            onCheckedChanged: {
                if (checked)
                    root.visibility = AppletDecoration.Types.ShownWindowExists;

            }
        }

        Item {
            Kirigami.FormData.isSection: true
        }

        QQC2.RadioButton {
            id: slideOutBtn
            Kirigami.FormData.label: i18n("Hidden State:")
            QQC2.ButtonGroup.group: hiddenStateBtnGroup
            text: i18n("Slide out animation")
            checked: root.hiddenState === AppletDecoration.Types.SlideOut
            enabled: root.visibility !== AppletDecoration.Types.AlwaysVisible
            onCheckedChanged: {
                if (checked)
                    root.hiddenState = AppletDecoration.Types.SlideOut;

            }
        }

        QQC2.RadioButton {
            id: emptySpaceBtn
            QQC2.ButtonGroup.group: hiddenStateBtnGroup
            text: i18n("Preserve as empty space")
            checked: root.hiddenState === AppletDecoration.Types.EmptySpace
            enabled: root.visibility !== AppletDecoration.Types.AlwaysVisible
            onCheckedChanged: {
                if (checked)
                    root.hiddenState = AppletDecoration.Types.EmptySpace;

            }
        }

        Item {
            Kirigami.FormData.isSection: true
        }

        QQC2.CheckBox {
            id: filterByScreenChk
            Kirigami.FormData.label: i18n("Filters:")
            text: i18n("Show only for windows in current screen")
        }

        QQC2.CheckBox {
            id: perScreenActiveChk
            text: i18n("Per-screen active window:")
        }

        Item {
            Kirigami.FormData.isSection: true
        }

        QQC2.CheckBox {
            id: inactiveChk
            Kirigami.FormData.label: i18n("Appearance:")
            text: i18n("Draw buttons inactive state when needed")
        }

        Item {
            Kirigami.FormData.isSection: true
        }

        QQC2.CheckBox {
            id: borderlessMaximizedWindowsChk
            Kirigami.FormData.label: i18n("KWin:")
            text: i18n("Borderless Maximized Windows")
            checked: root.borderlessMaximizedWindows
            onCheckedChanged: {
                root.borderlessMaximizedWindows = checked
            }
        }
    }

    QQC2.ButtonGroup {
        id: visibilityBtnGroup
    }

    QQC2.ButtonGroup {
        id: hiddenStateBtnGroup
    }
}
