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
    function displayAt(row) {
        if (row < 0)
            return "";

        return sortedDecorations.data(sortedDecorations.index(row, 0), Qt.DisplayRole);
    }

    displayText: combobox.displayAt(combobox.currentIndex)
    function applySelection(row) {
        if (row < 0)
            return;

        const modelIndex = sortedDecorations.index(row, 0);
        const pluginRole = Qt.UserRole + 4;
        const themeRole = Qt.UserRole + 5;

        root.useCurrent = false;
        root.selectedPlugin = sortedDecorations.data(modelIndex, pluginRole);
        root.selectedTheme = sortedDecorations.data(modelIndex, themeRole);
    }

    function syncCurrentIndexFromSelection() {
        const pluginRole = Qt.UserRole + 4;
        const themeRole = Qt.UserRole + 5;

        for (let row = 0; row < sortedDecorations.rowCount(); ++row) {
            const modelIndex = sortedDecorations.index(row, 0);
            if (sortedDecorations.data(modelIndex, pluginRole) === root.currentPlugin &&
                    sortedDecorations.data(modelIndex, themeRole) === root.currentTheme) {
                combobox.currentIndex = row;
                return;
            }
        }

        combobox.currentIndex = -1;
    }

    onActivated: {
        combobox.applySelection(combobox.currentIndex);
    }
    Component.onCompleted: {
        combobox.syncCurrentIndexFromSelection();
    }
    Connections {
        function onCurrentThemeChanged() {
            combobox.syncCurrentIndexFromSelection();
        }

        function onCurrentPluginChanged() {
            combobox.syncCurrentIndexFromSelection();
        }

        target: root
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
        implicitHeight: combobox.height
        implicitWidth: combobox.width
        hoverEnabled: true
        onClicked: {
            combobox.currentIndex = index;
            combobox.applySelection(index);
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
                text: combobox.displayAt(index)
                color: containsMouse ? palette.highlightedText : palette.text
            }

        }

    }

}
