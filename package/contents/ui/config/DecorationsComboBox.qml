/*
*  SPDX-FileCopyrightText: 2018 Michail Vourlakos <mvourlakos@gmail.com>
*
*  This file is part of applet-window-buttons
*
*  SPDX-License-Identifier: GPL-2.0-or-later
*/

import QtQuick
import QtQuick.Controls as QQC2

QQC2.ComboBox {
    id: combobox

    model: ListModel {
        id: decs
    }
    textRole: "display"

    function activateItem(itemIndex) {
        if (itemIndex === 0) {
            root.useCurrent = true;
            root.selectedPlugin = "";
            root.selectedTheme = "";
        } else {
            var d = decorations.get(itemIndex - 1);
            root.useCurrent = false;
            root.selectedPlugin = d.plugin;
            root.selectedTheme = d.theme;
        }
    }

    onActivated: index => activateItem(index)

    Component.onCompleted: {
        decs.append({ "display": i18n("Current") });
        for (var i = 0; i < decorations.count; ++i) {
            decs.append({ "display": decorations.get(i).display });
        }
        currentIndex = root.useCurrent ? 0 : decorations.indexOf(root.selectedPlugin, root.selectedTheme) + 1;
    }

    Connections {
        function onClosed() {
            root.forceActiveFocus();
        }

        target: combobox.popup
    }
}
