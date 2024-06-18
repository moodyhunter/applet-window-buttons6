/*
 * SPDX-FileCopyrightText: 2018 Michail Vourlakos <mvourlakos@gmail.com>
 *
 * This file is part of the libappletdecoration library
 *
 * SPDX-License-Identifier: GPL-2.0-or-later
 *
 */

#include "commontools.h"

#include <QFileInfo>
#include <QStandardPaths>

QString standardPath(QString subPath, bool localfirst)
{
    QStringList paths = QStandardPaths::standardLocations(QStandardPaths::GenericDataLocation);

    if (localfirst)
    {
        for (const auto &pt : paths)
        {
            QString ptF = pt + "/" + subPath;
            if (QFileInfo(ptF).exists())
            {
                return ptF;
            }
        }
    }
    else
    {
        for (int i = paths.count() - 1; i >= 0; i--)
        {
            QString ptF = paths[i] + "/" + subPath;
            if (QFileInfo(ptF).exists())
            {
                return ptF;
            }
        }
    }

    //! in any case that above fails
    if (QFileInfo("/usr/share/" + subPath).exists())
    {
        return "/usr/share/" + subPath;
    }

    return "";
}

QStringList standardPaths(bool localfirst)
{
    QStringList paths = QStandardPaths::standardLocations(QStandardPaths::GenericDataLocation);

    if (localfirst)
    {
        return paths;
    }
    else
    {
        QStringList reversed;

        for (int i = paths.count() - 1; i >= 0; i--)
        {
            reversed << paths[i];
        }

        return reversed;
    }
}

QStringList standardPathsFor(QString subPath, bool localfirst)
{
    QStringList paths = standardPaths(localfirst);

    QString separator = subPath.startsWith("/") ? "" : "/";

    for (int i = 0; i < paths.count(); ++i)
    {
        paths[i] = paths[i] + separator + subPath;
    }

    return paths;
}
