/*
*  SPDX-FileCopyrightText: 2018 Michail Vourlakos <mvourlakos@gmail.com>
*  SPDX-FileCopyrightText: 2024 Christian Tallner <chrtall@gmx.de>
*
*  This file is part of applet-window-buttons
*
*  SPDX-License-Identifier: GPL-2.0-or-later
*/

import QtQuick
import org.kde.plasma.configuration

ConfigModel {
    ConfigCategory {
        name: i18n("General")
        icon: "preferences-desktop-display-color"
        source: "config/ConfigGeneral.qml"
    }

    ConfigCategory {
        name: i18n("Behavior")
        icon: "preferences-desktop"
        source: "config/ConfigBehavior.qml"
    }
}
