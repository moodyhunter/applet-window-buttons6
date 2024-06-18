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

Item {
    id: main

    property bool locked: true
    readonly property int verticalSubHeight: height - (button.height / 2)

    SystemPalette {
        id: palette
    }

    ColumnLayout {
        id: column

        spacing: 0
        opacity: locked ? 1 : 0.5

        Rectangle {
            id: subRectTop

            Layout.minimumWidth: button.width / 2 + Layout.minimumHeight / 2
            Layout.minimumHeight: 3
            Layout.maximumWidth: Layout.minimumWidth
            Layout.maximumHeight: Layout.minimumHeight
            color: palette.text
        }

        Rectangle {
            Layout.leftMargin: subRectTop.Layout.minimumWidth - subRectTop.Layout.minimumHeight
            Layout.minimumWidth: subRectTop.Layout.minimumHeight
            Layout.minimumHeight: verticalSubHeight
            Layout.maximumWidth: Layout.minimumWidth
            Layout.maximumHeight: Layout.minimumHeight
            color: palette.text
        }

        Kirigami.Icon {
            id: button

            width: 24
            height: 24
            source: locked ? "lock" : "unlock"
        }

        Rectangle {
            Layout.leftMargin: subRectTop.Layout.minimumWidth - subRectTop.Layout.minimumHeight
            Layout.minimumWidth: subRectTop.Layout.minimumHeight
            Layout.minimumHeight: verticalSubHeight
            Layout.maximumWidth: Layout.minimumWidth
            Layout.maximumHeight: Layout.minimumHeight
            color: palette.text
        }

        Rectangle {
            Layout.minimumWidth: subRectTop.Layout.minimumWidth
            Layout.minimumHeight: subRectTop.Layout.minimumHeight
            Layout.maximumWidth: Layout.minimumWidth
            Layout.maximumHeight: Layout.minimumHeight
            color: palette.text
        }

    }

    MouseArea {
        anchors.fill: column
        onClicked: locked = !locked
    }

}
