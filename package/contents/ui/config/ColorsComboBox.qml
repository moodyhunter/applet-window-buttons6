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

    popup: Popup {
        y: combobox.height - 1
        width: Math.max(combobox.width, 300)
        height: Math.min(listView.contentHeight + topPadding + bottomPadding, 400)

        contentItem: ListView {
            id: listView
            clip: true
            model: combobox.delegateModel
            currentIndex: combobox.currentIndex
            ScrollBar.vertical: ScrollBar { policy: ScrollBar.AsNeeded }
        }
    }

    Connections {
        function onClosed() {
            root.forceActiveFocus();
        }

        target: popup
    }

    delegate: ItemDelegate {
        id: delegateItem

        width: combobox.width
        highlighted: combobox.currentIndex === index

        onClicked: {
            combobox.currentIndex = index;
            selectedScheme = model.file;
            combobox.popup.close();
        }

        contentItem: RowLayout {
            spacing: Kirigami.Units.smallSpacing

            Item {
                implicitWidth: 1.25 * label.implicitHeight
                implicitHeight: label.implicitHeight
                opacity: ((model.file == "kdeglobals") || (model.file == "_plasmatheme_")) ? 0 : 1

                Rectangle {
                    width: height
                    height: 0.75 * label.implicitHeight
                    color: model.backgroundColor
                    border.width: 1
                    border.color: delegateItem.highlighted ? palette.highlightedText : palette.text

                    Rectangle {
                        anchors.horizontalCenter: parent.right
                        anchors.verticalCenter: parent.bottom
                        width: parent.width
                        height: parent.height
                        color: model.textColor
                        border.width: parent.border.width
                        border.color: parent.border.color
                    }
                }
            }

            Label {
                id: label

                text: model.display
                color: delegateItem.highlighted ? palette.highlightedText : palette.text
            }
        }
    }
}
