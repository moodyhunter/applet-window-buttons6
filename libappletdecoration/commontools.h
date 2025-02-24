/*
 * SPDX-FileCopyrightText: 2019 Michail Vourlakos <mvourlakos@gmail.com>
 *
 * This file is part of the libappletdecoration library
 *
 * SPDX-License-Identifier: GPL-2.0-or-later
 *
 */

#include <QString>
#include <QStringList>

//! returns the standard path found that contains the subPath
//! local paths have higher priority by default
QString standardPath(QString subPath, bool localFirst = true);

QStringList standardPaths(bool localfirst = true);
QStringList standardPathsFor(QString subPath, bool localfirst = true);
