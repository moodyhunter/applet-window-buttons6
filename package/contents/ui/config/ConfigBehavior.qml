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
    property alias cfg_customSlideAnimation: customSlideAnimationChk.checked
    property alias cfg_slideAnimationDuration: slideAnimationDurationSpin.value
    property alias cfg_slideAnimationAcceleration: slideAnimationAccelerationSpin.value
    property alias cfg_borderlessMaximizedWindows: root.borderlessMaximizedWindows

    // used as bridge to communicate properly between configuration and ui
    property int visibility
    property int hiddenState
    readonly property bool customSlideControlsEnabled: customSlideAnimationChk.checked && slideOutBtn.checked && root.visibility !== AppletDecoration.Types.AlwaysVisible
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
            id: maximizedWindowBtn
            QQC2.ButtonGroup.group: visibilityBtnGroup
            text: i18n("Maximized window is shown")
            checked: root.visibility === AppletDecoration.Types.ActiveMaximizedWindow || root.visibility === AppletDecoration.Types.MaximizedWindowExists
            onCheckedChanged: {
                if (checked)
                    root.visibility = AppletDecoration.Types.MaximizedWindowExists;

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

        QQC2.CheckBox {
            id: customSlideAnimationChk
            Kirigami.FormData.label: i18n("Slide animation:")
            text: i18n("Use custom timing")
            enabled: slideOutBtn.checked && root.visibility !== AppletDecoration.Types.AlwaysVisible
        }

        RowLayout {
            Kirigami.FormData.label: i18n("Duration:")
            enabled: root.customSlideControlsEnabled
            opacity: enabled ? 1 : 0.45

            QQC2.Slider {
                id: slideAnimationDurationSlider

                Layout.fillWidth: true
                from: 50
                to: 1000
                stepSize: 10
                snapMode: QQC2.Slider.SnapAlways
                value: slideAnimationDurationSpin.value
                onMoved: slideAnimationDurationSpin.value = Math.round(value / 10) * 10
            }

            QQC2.SpinBox {
                id: slideAnimationDurationSpin

                from: 50
                to: 1000
                stepSize: 10
                textFromValue: function(value) {
                    return i18n("%1 ms", value);
                }
                valueFromText: function(text) {
                    return parseInt(text);
                }
            }
        }

        RowLayout {
            Kirigami.FormData.label: i18n("Acceleration:")
            enabled: root.customSlideControlsEnabled
            opacity: enabled ? 1 : 0.45

            QQC2.Slider {
                id: slideAnimationAccelerationSlider

                Layout.fillWidth: true
                from: 0
                to: 4
                stepSize: 1
                snapMode: QQC2.Slider.SnapAlways
                value: slideAnimationAccelerationSpin.value
                onMoved: slideAnimationAccelerationSpin.value = Math.round(value)
            }

            QQC2.SpinBox {
                id: slideAnimationAccelerationSpin

                from: 0
                to: 4
                textFromValue: function(value) {
                    if (value === 0)
                        return i18n("None");
                    if (value === 1)
                        return i18n("Soft");
                    if (value === 2)
                        return i18n("Default");
                    if (value === 3)
                        return i18n("Fast");

                    return i18n("Aggressive");
                }
                valueFromText: function(text) {
                    if (text === i18n("None"))
                        return 0;
                    if (text === i18n("Soft"))
                        return 1;
                    if (text === i18n("Default"))
                        return 2;
                    if (text === i18n("Fast"))
                        return 3;

                    return 4;
                }
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
