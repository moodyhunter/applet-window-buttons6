/*
 *  SPDX-FileCopyrightText: 2024 Christian Tallner <chrtall@gmx.de>
 *
 *  SPDX-License-Identifier: GPL-2.0-or-later
*/
#include "kwinconfig.h"
#include <QDBusConnection>

using org::kde::KWin;

KWinConfig::KWinConfig(QObject *parent) : QObject(parent) , config(QStandardPaths::writableLocation(QStandardPaths::GenericConfigLocation) + QLatin1String("/kwinrc"), KConfig::SimpleConfig)
{
    group = config.group(QStringLiteral("Windows"));
    kwin_ptr = new KWin("org.kde.KWin", "/KWin", QDBusConnection::sessionBus(), this);
}

bool KWinConfig::borderlessMaximizedWindows() const
{
    return group.exists() && group.hasKey(QStringLiteral("BorderlessMaximizedWindows")) && group.readEntry(QStringLiteral("BorderlessMaximizedWindows")) == QString("true");
}

void KWinConfig::setBorderlessMaximizedWindows(bool isEnabled)
{
    if(kwin_ptr != nullptr){
        group.writeEntry(QStringLiteral("BorderlessMaximizedWindows"), isEnabled);
        group.sync();
        kwin_ptr->reconfigure();
    }
}
