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

ComboBox {
    id: combobox

    function fileAt(row) {
        if (row < 0)
            return "";

        return combobox.model.data(combobox.model.index(row, 0), Qt.UserRole + 4);
    }

    function backgroundColorAt(row) {
        if (row < 0)
            return "transparent";

        return combobox.model.data(combobox.model.index(row, 0), Qt.UserRole + 5);
    }

    function textColorAt(row) {
        if (row < 0)
            return palette.text;

        return combobox.model.data(combobox.model.index(row, 0), Qt.UserRole + 6);
    }

    function displayAt(row) {
        if (row < 0)
            return "";

        return combobox.model.data(combobox.model.index(row, 0), Qt.DisplayRole);
    }

    function applySelection(row) {
        if (row < 0)
            return;

        selectedScheme = combobox.fileAt(row);
    }

    onActivated: {
        combobox.applySelection(combobox.currentIndex);
    }
    displayText: combobox.displayAt(combobox.currentIndex)

    Connections {
        function onClosed() {
            root.forceActiveFocus();
        }

        target: popup
    }

    delegate: MouseArea {
        width: combobox.width
        height: combobox.height
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

            RowLayout {
                id: delegateRow

                height: parent.height

                Item {
                    Layout.leftMargin: 2
                    width: 1.25 * label.height
                    height: label.height
                    opacity: ((combobox.fileAt(index) == "kdeglobals") || (combobox.fileAt(index) == "_plasmatheme_")) ? 0 : 1

                    Rectangle {
                        width: height
                        height: 0.75 * label.height
                        color: combobox.backgroundColorAt(index)
                        border.width: 1
                        border.color: containsMouse || (combobox.currentIndex === index) ? palette.highlightedText : palette.text

                        Rectangle {
                            anchors.horizontalCenter: parent.right
                            anchors.verticalCenter: parent.bottom
                            width: parent.width
                            height: parent.height
                            color: combobox.textColorAt(index)
                            border.width: parent.border.width
                            border.color: parent.border.color
                        }

                    }

                }

                Label {
                    id: label

                    text: combobox.displayAt(index)
                    color: containsMouse ? palette.highlightedText : palette.text
                }

            }

        }

    }

}
