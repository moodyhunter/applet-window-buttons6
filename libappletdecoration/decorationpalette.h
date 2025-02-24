/********************************************************************
 KWin - the KDE window manager
 This file is part of the KDE project.

SPDX-FileCopyrightText: 2014 Martin Gräßlin <mgraesslin@kde.org>
SPDX-FileCopyrightText: 2014 Hugo Pereira Da Costa <hugo.pereira@free.fr>
SPDX-FileCopyrightText: 2015 Mika Allan Rauhala <mika.allan.rauhala@gmail.com>

SPDX-License-Identifier: GPL-2.0-or-later
*********************************************************************/

#ifndef KWIN_DECORATION_PALETTE_H
#define KWIN_DECORATION_PALETTE_H

#include <KDecoration3/DecorationSettings>
#include <QFileSystemWatcher>
#include <QPalette>

class DecorationPalette : public QObject
{
    Q_OBJECT
  public:
    DecorationPalette(const QString &colorScheme);

    bool isValid() const;

    QColor color(KDecoration3::ColorGroup group, KDecoration3::ColorRole role) const;
    QPalette palette() const;

  Q_SIGNALS:
    void changed();

  private:
    void update();

    QString m_colorScheme;
    QFileSystemWatcher m_watcher;

    QPalette m_palette;

    QColor m_activeTitleBarColor;
    QColor m_inactiveTitleBarColor;

    QColor m_activeFrameColor;
    QColor m_inactiveFrameColor;

    QColor m_activeForegroundColor;
    QColor m_inactiveForegroundColor;
    QColor m_warningForegroundColor;
};

#endif
