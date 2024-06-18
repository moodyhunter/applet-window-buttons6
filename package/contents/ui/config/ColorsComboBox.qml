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

    Connections {
        function onClosed() {
            root.forceActiveFocus();
        }

        target: popup
    }

    delegate: MouseArea {
        width: combobox.width
        height: combobox.height
        hoverEnabled: true
        onClicked: {
            combobox.currentIndex = index;
            selectedScheme = model.file;
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
                    opacity: ((file == "kdeglobals") || (file == "_plasmatheme_")) ? 0 : 1

                    Rectangle {
                        width: height
                        height: 0.75 * label.height
                        color: backgroundColor
                        border.width: 1
                        border.color: containsMouse || (combobox.currentIndex === index) ? palette.highlightedText : palette.text

                        Rectangle {
                            anchors.horizontalCenter: parent.right
                            anchors.verticalCenter: parent.bottom
                            width: parent.width
                            height: parent.height
                            color: textColor
                            border.width: parent.border.width
                            border.color: parent.border.color
                        }

                    }

                }

                Label {
                    id: label

                    text: display
                    color: containsMouse ? palette.highlightedText : palette.text
                }

            }

        }

    }

}
