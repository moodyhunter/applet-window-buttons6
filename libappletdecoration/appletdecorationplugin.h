/*
 *  SPDX-FileCopyrightText: 2018 Michail Vourlakos <mvourlakos@gmail.com>
 *
 *  This file is part of the libappletdecoration library
 *
 *  SPDX-License-Identifier: GPL-2.0-or-later
 */

#ifndef APPLETDECORATIONPLUGIN_H
#define APPLETDECORATIONPLUGIN_H

#include <QQmlExtensionPlugin>

class AppletDecorationPlugin : public QQmlExtensionPlugin
{
    Q_OBJECT
    Q_PLUGIN_METADATA(IID "org.qt-project.Qt.QQmlExtensionInterface")

  public:
    void registerTypes(const char *uri) override;
};

#endif
