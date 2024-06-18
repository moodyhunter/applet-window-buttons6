/*
 *  SPDX-FileCopyrightText: 2019 Michail Vourlakos <mvourlakos@gmail.com>
 *
 *  This file is part of Window Buttons Applet
 *
 *  SPDX-License-Identifier: GPL-2.0-or-later
 */

#include "environment.h"

#include <QDebug>
#include <QProcess>
#include <plasma_version.h>

Environment::Environment(QObject *parent) : QObject(parent)
{
}

Environment::~Environment()
{
    qDebug() << staticMetaObject.className() << "destructed";
}

uint Environment::frameworksVersion() const
{
    return PLASMA_VERSION;
}

uint Environment::plasmaDesktopVersion()
{
    if (m_plasmaDesktopVersion == -1)
    {
        m_plasmaDesktopVersion = identifyPlasmaDesktopVersion();
    }

    return m_plasmaDesktopVersion;
}

uint Environment::makeVersion(uint major, uint minor, uint release) const
{
    return (((major) << 16) | ((minor) << 8) | (release));
}

uint Environment::identifyPlasmaDesktopVersion()
{
    //! Identify Plasma Desktop version
    QProcess process;
    process.start("plasmashell", QStringList() << "-v");
    process.waitForFinished();
    QString output(process.readAllStandardOutput());

    QStringList stringSplit = output.split(" ");

    if (stringSplit.count() >= 2)
    {
        qDebug() << " /////////////////////////";
        QString cleanVersionString = stringSplit[1].remove("\n");
        QStringList plasmaDesktopVersionParts = cleanVersionString.split(".");

        if (plasmaDesktopVersionParts.count() == 3)
        {
            uint maj = plasmaDesktopVersionParts[0].toUInt();
            uint min = plasmaDesktopVersionParts[1].toUInt();
            uint rel = plasmaDesktopVersionParts[2].toUInt();

            if (maj > 0)
            {

                uint desktopVersion = makeVersion(maj, min, rel);

                QString message("Plasma Desktop version:  " + QString::number(maj) + "." + QString::number(min) + "." + QString::number(rel) + " (" +
                                QString::number(desktopVersion) + ")");
                qDebug() << message;
                qDebug() << " /////////////////////////";

                return desktopVersion;
            }
        }

        qDebug() << " /////////////////////////";
    }

    return 0;
}
