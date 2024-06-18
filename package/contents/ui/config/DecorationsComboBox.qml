/*
*  SPDX-FileCopyrightText: 2018 Michail Vourlakos <mvourlakos@gmail.com>
*
*  This file is part of applet-window-buttons
*
*  SPDX-License-Identifier: GPL-2.0-or-later
*/

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import org.kde.kirigami as Kirigami

ComboBox {
    id: combobox

    model: sortedDecorations
    textRole: "display"
    valueRole: "plugin"
    onActivated: {
        var index = combobox.currentIndex;
        if (index === -1)
            return ;

        console.log(currentTheme, combobox.currentText, combobox.currentValue);
        root.useCurrent = false;
        root.selectedPlugin = combobox.currentValue;
        root.selectedTheme = combobox.currentText;
    }
    Component.onCompleted: {
        combobox.currentIndex = combobox.find(root.currentTheme);
    }

    Connections {
        function onClosed() {
            root.forceActiveFocus();
        }

        target: popup
    }

    delegate: MouseArea {
        height: combobox.height
        width: combobox.width
        hoverEnabled: true
        onClicked: {
            combobox.currentIndex = index;
            root.useCurrent = false;
            root.selectedPlugin = plugin;
            root.selectedTheme = theme;
            combobox.popup.close();
        }

        Rectangle {
            id: delegateBackground

            readonly property color selectedColor: Qt.rgba(palette.highlight.r, palette.highlight.g, palette.highlight.b, 0.5)

            anchors.fill: parent
            color: {
                if (containsMouse)
                    return palette.highlight;

                if (combobox.currentIndex === index)
                    return selectedColor;

                return "transparent";
            }

            Label {
                id: label

                anchors.left: parent.left
                anchors.leftMargin: Kirigami.Units.smallSpacing
                anchors.verticalCenter: parent.verticalCenter
                text: display
                color: containsMouse ? palette.highlightedText : palette.text
            }

        }

    }

}
