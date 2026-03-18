/*
*  SPDX-FileCopyrightText: 2018 Michail Vourlakos <mvourlakos@gmail.com>
*  SPDX-FileCopyrightText: 2026 Christian Tallner <chrtall@gmx.de>
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
            return;

        root.useCurrent = false;
        root.selectedPlugin = sortedDecorations.data(sortedDecorations.index(index, 0), Qt.UserRole + 4);
        root.selectedTheme  = sortedDecorations.data(sortedDecorations.index(index, 0), Qt.UserRole + 5);
    }

    Component.onCompleted: {
        var targetPlugin = root.currentPlugin;
        var targetTheme = root.currentTheme;
        var fallback = -1;
        for (var i = 0; i < sortedDecorations.count; i++) {
            var p = sortedDecorations.data(sortedDecorations.index(i, 0), Qt.UserRole + 4);
            var t = sortedDecorations.data(sortedDecorations.index(i, 0), Qt.UserRole + 5);
            if (p === targetPlugin) {
                if (t === targetTheme) {
                    combobox.currentIndex = i;
                    return;
                }
                // fallback for non-theme-engine plugins (e.g. Breeze) whose model theme is ""
                if (t === "" && fallback === -1)
                    fallback = i;
            }
        }
        if (fallback !== -1)
            combobox.currentIndex = fallback;
    }

    popup: Popup {
        y: combobox.height - 1
        width: Math.max(combobox.width, 280)
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
            root.useCurrent = false;
            root.selectedPlugin = model.plugin;
            root.selectedTheme = model.theme;
            combobox.popup.close();
        }

        contentItem: Label {
            leftPadding: Kirigami.Units.smallSpacing
            text: model.display
            color: delegateItem.highlighted ? palette.highlightedText : palette.text
        }
    }
}
