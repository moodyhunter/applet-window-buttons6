/*
 *  SPDX-FileCopyrightText: 2024 Christian Tallner <chrtall@gmx.de>
 *
 *  SPDX-License-Identifier: GPL-2.0-or-later
*/
#include <KConfig>
#include <KConfigGroup>
#include <QObject>
#include "kwin_interface.h"
#ifndef APPLET_WINDOWBUTTONS_KWINCONFIG_H
#define APPLET_WINDOWBUTTONS_KWINCONFIG_H


class KWinConfig : public QObject
{
    Q_OBJECT
    Q_PROPERTY(
        bool borderlessMaximizedWindows
        READ borderlessMaximizedWindows
        WRITE setBorderlessMaximizedWindows
        NOTIFY borderlessMaximizedWindowsChanged
    )

  public:
    explicit KWinConfig(QObject *parent = nullptr);

    bool borderlessMaximizedWindows() const;
    void setBorderlessMaximizedWindows(bool isEnabled);

  signals:
    void borderlessMaximizedWindowsChanged();

  private:
    KConfig config;
    KConfigGroup group;
    org::kde::KWin *kwin_ptr = nullptr;
};

#endif // APPLET_WINDOWBUTTONS_KWINCONFIG_H
