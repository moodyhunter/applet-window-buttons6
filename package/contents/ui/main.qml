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

import "../code/tools.js" as ModelTools
import QtQuick
import QtQuick.Layouts
import org.kde.appletdecoration as AppletDecoration
import org.kde.plasma.core as PlasmaCore
import org.kde.plasma.plasmoid

PlasmoidItem {
    id: root

    // plasmoid.userConfiguringChanged: {
    //     console.log("Config Changed")
    // }

    property int animatedMinimumWidth: minimumWidth
    property int animatedMinimumHeight: minimumHeight
    property int screen: plasmoid.containment.screen
    readonly property bool inEditMode: plasmoid.userConfiguring || plasmoid.containment.corona.editMode
    readonly property bool mustHide: {
        if (visibility === AppletDecoration.Types.AlwaysVisible || inEditMode)
            return false;

        if (visibility === AppletDecoration.Types.ActiveWindow && !existsWindowActive)
            return true;

        if (visibility === AppletDecoration.Types.ActiveMaximizedWindow && (!isLastActiveWindowMaximized || !existsWindowActive))
            return true;

        if (visibility === AppletDecoration.Types.ShownWindowExists && !existsWindowShown)
            return true;

        return false;
    }
    readonly property bool selectedDecorationExists: decorations.decorationExists(plasmoid.configuration.selectedPlugin, plasmoid.configuration.selectedTheme)
    readonly property bool slideAnimationEnabled: ((visibility !== AppletDecoration.Types.AlwaysVisible) && (plasmoid.configuration.hiddenState === AppletDecoration.Types.SlideOut))
    readonly property bool isEmptySpaceEnabled: plasmoid.configuration.hiddenState === AppletDecoration.Types.EmptySpace
    readonly property int visibility: plasmoid.configuration.visibility
    readonly property bool perScreenActive: plasmoid.configuration.perScreenActive
    readonly property int minimumWidth: {
        if (plasmoid.formFactor === PlasmaCore.Types.Horizontal) {
            if (mustHide && !isEmptySpaceEnabled && slideAnimationEnabled && !plasmoid.userConfiguring)
                return 0;

        }
        return plasmoid.formFactor === PlasmaCore.Types.Horizontal ? buttonsArea.width : -1;
    }
    readonly property int minimumHeight: {
        if (plasmoid.formFactor === PlasmaCore.Types.Vertical) {
            if (mustHide && !isEmptySpaceEnabled && slideAnimationEnabled && !plasmoid.userConfiguring)
                return 0;

        }
        return plasmoid.formFactor === PlasmaCore.Types.Horizontal ? -1 : buttonsArea.height;
    }
    readonly property string buttonsStr: plasmoid.configuration.buttons
    // START visual properties
    property bool inactiveStateEnabled: inEditMode ? false : plasmoid.configuration.inactiveStateEnabled
    property int thickPadding: {
        if (auroraeThemeEngine.isEnabled && plasmoid.configuration.useDecorationMetrics)
            return plasmoid.formFactor === PlasmaCore.Types.Horizontal ? ((root.height - auroraeThemeEngine.buttonHeight) / 2) - 1 : ((root.width - auroraeThemeEngine.buttonHeight) / 2) - 1;

        //! Plasma panels code
        if (plasmoid.formFactor === PlasmaCore.Types.Horizontal)
            return (root.height - (root.height * (plasmoid.configuration.buttonSizePercentage / 100))) / 2;
        else
            return (root.width - (root.width * (plasmoid.configuration.buttonSizePercentage / 100))) / 2;
    }
    property int lengthFirstMargin: plasmoid.configuration.lengthFirstMargin
    property int lengthLastMargin: plasmoid.configuration.lengthLastMargin
    property int lengthFirstPadding: Math.min(lengthFirstMargin, lengthMidPadding)
    property int lengthMidPadding: spacing / 2
    property int lengthLastPadding: Math.min(lengthLastMargin, lengthMidPadding)
    property int spacing: {
        if (auroraeThemeEngine.isEnabled && plasmoid.configuration.useDecorationMetrics)
            return auroraeThemeEngine.buttonSpacing;

        return plasmoid.configuration.spacing;
    }
    //! make sure that on startup it will always be shown
    readonly property bool existsWindowActive: (windowInfoLoader.item && windowInfoLoader.item.existsWindowActive)
    readonly property bool existsWindowShown: (windowInfoLoader.item && windowInfoLoader.item.existsWindowShown)
    readonly property bool isLastActiveWindowPinned: lastActiveTaskItem && existsWindowShown && lastActiveTaskItem.isOnAllDesktops
    readonly property bool isLastActiveWindowMaximized: lastActiveTaskItem && existsWindowShown && lastActiveTaskItem.isMaximized
    readonly property bool isLastActiveWindowKeepAbove: lastActiveTaskItem && existsWindowShown && lastActiveTaskItem.isKeepAbove
    readonly property bool isLastActiveWindowClosable: lastActiveTaskItem && existsWindowShown && lastActiveTaskItem.isClosable
    readonly property bool isLastActiveWindowMaximizable: lastActiveTaskItem && existsWindowShown && lastActiveTaskItem.isMaximizable
    readonly property bool isLastActiveWindowMinimizable: lastActiveTaskItem && existsWindowShown && lastActiveTaskItem.isMinimizable
    readonly property bool isLastActiveWindowVirtualDesktopsChangeable: lastActiveTaskItem && existsWindowShown && lastActiveTaskItem.isVirtualDesktopsChangeable
    property bool hasDesktopsButton: false
    property bool hasMaximizedButton: false
    property bool hasKeepAboveButton: false
    readonly property Item lastActiveTaskItem: windowInfoLoader.item.lastActiveTaskItem
    // START decoration properties
    property string currentPlugin: plasmoid.configuration.useCurrentDecoration || !selectedDecorationExists ? decorations.currentPlugin : plasmoid.configuration.selectedPlugin
    property string currentTheme: plasmoid.configuration.useCurrentDecoration || !selectedDecorationExists ? decorations.currentTheme : plasmoid.configuration.selectedTheme
    property string currentScheme: {
        if (plasmaThemeExtended.isActive)
            return plasmaThemeExtended.colors.schemeFile;

        return plasmoid.configuration.selectedScheme === "kdeglobals" ? colorsModel.defaultSchemeFile() : plasmoid.configuration.selectedScheme;
    }
    property var tasksPreparedArray: []

    ///functions
    function initButtons() {
        if (!buttonsRecreator.running)
            buttonsRecreator.start();

    }

    function initializeControlButtonsModel() {
        console.log("recreating buttons");
        sharedDecorationItem.createDecoration();
        var buttonsList = buttonsStr.split('|');
        ModelTools.initializeControlButtonsModel(buttonsList, tasksPreparedArray, controlButtonsModel, true);
    }

    function discoverButtons() {
        var hasMax = false;
        var hasPin = false;
        var hasKeepAbove = false;
        for (var i = 0; i < tasksPreparedArray.length; ++i) {
            if (tasksPreparedArray[i].buttonType === AppletDecoration.Types.Maximize)
                hasMax = true;
            else if (tasksPreparedArray[i].buttonType === AppletDecoration.Types.OnAllDesktops)
                hasPin = true;
            else if (tasksPreparedArray[i].buttonType === AppletDecoration.Types.KeepAbove)
                hasKeepAbove = true;
        }
        hasMaximizedButton = hasMax;
        hasDesktopsButton = hasPin;
        hasKeepAboveButton = hasKeepAbove;
    }

    function performActiveWindowAction(windowOperation) {
        if (windowOperation === AppletDecoration.Types.ActionClose)
            windowInfoLoader.item.toggleClose();
        else if (windowOperation === AppletDecoration.Types.ToggleMaximize)
            windowInfoLoader.item.toggleMaximized();
        else if (windowOperation === AppletDecoration.Types.ToggleMinimize)
            windowInfoLoader.item.toggleMinimized();
        else if (windowOperation === AppletDecoration.Types.TogglePinToAllDesktops)
            windowInfoLoader.item.togglePinToAllDesktops();
        else if (windowOperation === AppletDecoration.Types.ToggleKeepAbove)
            windowInfoLoader.item.toggleKeepAbove();
    }

    clip: true
    Layout.fillHeight: plasmoid.formFactor === PlasmaCore.Types.Horizontal ? true : false
    Layout.fillWidth: plasmoid.formFactor === PlasmaCore.Types.Horizontal ? false : true
    Layout.minimumWidth: plasmoid.formFactor === PlasmaCore.Types.Horizontal ? animatedMinimumWidth : -1
    Layout.minimumHeight: plasmoid.formFactor === PlasmaCore.Types.Horizontal ? -1 : animatedMinimumHeight
    Layout.preferredHeight: Layout.minimumHeight
    Layout.preferredWidth: Layout.minimumWidth
    Layout.maximumHeight: Layout.minimumHeight
    Layout.maximumWidth: Layout.minimumWidth
    preferredRepresentation: fullRepresentation
    Plasmoid.onFormFactorChanged: plasmoid.configuration.formFactor = plasmoid.formFactor
    Plasmoid.status: {
        if (mustHide && !isEmptySpaceEnabled) {
            if ((plasmoid.formFactor === PlasmaCore.Types.Horizontal && animatedMinimumWidth === 0) || (plasmoid.formFactor === PlasmaCore.Types.Vertical && animatedMinimumHeight === 0))
                return PlasmaCore.Types.HiddenStatus;

        }
        return PlasmaCore.Types.ActiveStatus;
    }
    onButtonsStrChanged: initButtons()
    Component.onCompleted: {
        if (plasmoid.configuration.buttons.indexOf("9") === -1)
            plasmoid.configuration.buttons = plasmoid.configuration.buttons.concat("|9");

        initButtons();
    }

    Connections {
        target: bridgeItem
        onPluginChanged: initButtons()
    }

    Connections {
        target: buttonsRepeater
        onCountChanged: discoverButtons()
    }

    ListModel {
        id: controlButtonsModel
    }

    //!
    Loader {
        id: windowInfoLoader

        sourceComponent: plasmaTasksModel

        Component {
            id: plasmaTasksModel

            PlasmaTasksModel {
                filterByScreen: plasmoid.configuration.filterByScreen
            }

        }

    }

    ///Decoration Items
    AppletDecoration.Bridge {
        id: bridgeItem

        plugin: currentPlugin
        theme: currentTheme
    }

    AppletDecoration.Settings {
        id: settingsItem

        bridge: bridgeItem.bridge
        borderSizesIndex: 0 // Normal
    }

    AppletDecoration.SharedDecoration {
        id: sharedDecorationItem

        bridge: bridgeItem.bridge
        settings: settingsItem
    }

    AppletDecoration.DecorationsModel {
        id: decorations
    }

    AppletDecoration.ColorsModel {
        id: colorsModel
    }

    AppletDecoration.PlasmaThemeExtended {
        id: plasmaThemeExtended

        readonly property bool isActive: plasmoid.configuration.selectedScheme === "_plasmatheme_"
    }

    AppletDecoration.AuroraeTheme {
        id: auroraeThemeEngine

        readonly property bool isEnabled: decorations.isAurorae(currentPlugin, currentTheme)

        theme: isEnabled ? currentTheme : ""
    }

    Grid {
        id: buttonsArea

        readonly property int buttonThickness: plasmoid.formFactor === PlasmaCore.Types.Horizontal ? root.height - 2 * thickPadding : root.width - 2 * thickPadding

        rowSpacing: 0
        columnSpacing: 0
        rows: plasmoid.formFactor === PlasmaCore.Types.Horizontal ? 1 : 0
        columns: plasmoid.formFactor === PlasmaCore.Types.Horizontal ? 0 : 1
        opacity: mustHide && !inEditMode && (!root.slideAnimationEnabled || (root.slideAnimationEnabled && plasmoid.status === PlasmaCore.Types.HiddenStatus)) ? 0 : 1 //wait for slide-out animation
        visible: opacity === 0 ? false : true

        Repeater {
            id: buttonsRepeater

            model: controlButtonsModel
            delegate: auroraeThemeEngine.isEnabled ? auroraeButton : pluginButton
        }

    }

    Component {
        id: pluginButton

        AppletDecoration.Button {
            id: cButton

            readonly property bool isVisible: {
                if (visibility === AppletDecoration.Types.AlwaysVisible || inEditMode)
                    return true;

                if (type === AppletDecoration.Types.Close)
                    return root.isLastActiveWindowClosable;
                else if (type === AppletDecoration.Types.Maximize)
                    return root.isLastActiveWindowMaximizable;
                else if (type === AppletDecoration.Types.Minimize)
                    return root.isLastActiveWindowMinimizable;
                else if (type === AppletDecoration.Types.OnAllDesktops)
                    return root.isLastActiveWindowVirtualDesktopsChangeable;
                return true;
            }
            readonly property int firstPadding: {
                if (index === 0)
                    return lengthFirstMargin;
                else
                    return lengthMidPadding;
            }
            readonly property int lastPadding: {
                if (index >= 0 && index === buttonsRepeater.count - 1)
                    return lengthLastMargin;
                else
                    return lengthMidPadding;
            }

            width: plasmoid.formFactor === PlasmaCore.Types.Horizontal ? buttonsArea.buttonThickness + padding.left + padding.right : buttonsArea.buttonThickness + 2 * thickPadding
            height: plasmoid.formFactor === PlasmaCore.Types.Horizontal ? buttonsArea.buttonThickness + 2 * thickPadding : buttonsArea.buttonThickness + padding.top + padding.bottom
            bridge: bridgeItem.bridge
            sharedDecoration: sharedDecorationItem
            scheme: root.currentScheme
            type: buttonType
            isActive: {
                //!   FIXME-TEST PERIOD: Disabled because it shows an error from c++ theme when its value is changed
                //!   and breaks in some cases the buttons coloring through the schemeFile
                if (root.inactiveStateEnabled && !root.existsWindowActive)
                    return false;

                return true;
            }
            isOnAllDesktops: root.isLastActiveWindowPinned
            isMaximized: root.isLastActiveWindowMaximized
            isKeepAbove: root.isLastActiveWindowKeepAbove
            localX: x
            localY: y
            opacity: isVisible ? 1 : 0
            visible: (isVisible && !root.isEmptySpaceEnabled) || root.isEmptySpaceEnabled
            onClicked: {
                root.performActiveWindowAction(windowOperation);
            }

            padding {
                left: plasmoid.formFactor === PlasmaCore.Types.Horizontal ? firstPadding : thickPadding
                right: plasmoid.formFactor === PlasmaCore.Types.Horizontal ? lastPadding : thickPadding
                top: plasmoid.formFactor === PlasmaCore.Types.Horizontal ? thickPadding : firstPadding
                bottom: plasmoid.formFactor === PlasmaCore.Types.Horizontal ? thickPadding : lastPadding
            }

        }

    }

    Component {
        id: auroraeButton

        AppletDecoration.AuroraeButton {
            id: aButton

            readonly property int firstPadding: {
                if (index === 0)
                    return lengthFirstMargin;
                else
                    return lengthMidPadding;
            }
            readonly property int lastPadding: {
                if (index >= 0 && index === buttonsRepeater.count - 1)
                    return lengthLastMargin;
                else
                    return lengthMidPadding;
            }
            readonly property bool isVisible: {
                if (visibility === AppletDecoration.Types.AlwaysVisible || inEditMode)
                    return true;

                if (buttonType === AppletDecoration.Types.Close)
                    return root.isLastActiveWindowClosable;
                else if (buttonType === AppletDecoration.Types.Maximize)
                    return root.isLastActiveWindowMaximizable;
                else if (buttonType === AppletDecoration.Types.Minimize)
                    return root.isLastActiveWindowMinimizable;
                else if (buttonType === AppletDecoration.Types.OnAllDesktops)
                    return root.isLastActiveWindowVirtualDesktopsChangeable;
                return true;
            }

            width: plasmoid.formFactor === PlasmaCore.Types.Horizontal ? auroraeTheme.buttonRatio * buttonsArea.buttonThickness + leftPadding + rightPadding : buttonsArea.buttonThickness + 2 * thickPadding
            height: plasmoid.formFactor === PlasmaCore.Types.Horizontal ? buttonsArea.buttonThickness + 2 * thickPadding : buttonsArea.buttonThickness + topPadding + bottomPadding
            leftPadding: plasmoid.formFactor === PlasmaCore.Types.Horizontal ? firstPadding : thickPadding
            rightPadding: plasmoid.formFactor === PlasmaCore.Types.Horizontal ? lastPadding : thickPadding
            topPadding: plasmoid.formFactor === PlasmaCore.Types.Horizontal ? thickPadding : firstPadding
            bottomPadding: plasmoid.formFactor === PlasmaCore.Types.Horizontal ? thickPadding : lastPadding
            isActive: {
                //!   FIXME-TEST PERIOD: Disabled because it shows an error from c++ theme when its value is changed
                //!   and breaks in some cases the buttons coloring through the schemeFile
                if (root.inactiveStateEnabled && !root.existsWindowActive)
                    return false;

                return true;
            }
            isOnAllDesktops: root.isLastActiveWindowPinned
            isMaximized: root.isLastActiveWindowMaximized
            isKeepAbove: root.isLastActiveWindowKeepAbove
            buttonType: model.buttonType
            auroraeTheme: auroraeThemeEngine
            monochromeIconsEnabled: auroraeThemeEngine.hasMonochromeIcons
            monochromeIconsColor: "transparent"
            opacity: isVisible ? 1 : 0
            visible: (isVisible && !root.isEmptySpaceEnabled) || root.isEmptySpaceEnabled
            onClicked: {
                root.performActiveWindowAction(windowOperation);
            }
        }

    }
    ///END Visual Items

    //! this timer is used in order to not call too many times the recreation
    //! of buttons with no reason.
    Timer {
        id: buttonsRecreator

        interval: 200
        onTriggered: {
            initializeControlButtonsModel();
        }
    }

    //START Behaviors
    Behavior on animatedMinimumWidth {
        enabled: slideAnimationEnabled && plasmoid.formFactor === PlasmaCore.Types.Horizontal

        NumberAnimation {
            duration: 250
            easing.type: Easing.InCubic
        }

    }

    Behavior on animatedMinimumHeight {
        enabled: slideAnimationEnabled && plasmoid.formFactor === PlasmaCore.Types.Vertical

        NumberAnimation {
            duration: 250
            easing.type: Easing.InCubic
        }

    }
    //END Behaviors

}
