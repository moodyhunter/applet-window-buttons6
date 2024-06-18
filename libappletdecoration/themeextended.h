/*
 * SPDX-FileCopyrightText: 2018 Michail Vourlakos <mvourlakos@gmail.com>
 *
 * This file is part of the libappletdecoration library
 *
 * SPDX-License-Identifier: GPL-2.0-or-later
 *
 */

#ifndef PLASMAEXTENDEDTHEME_H
#define PLASMAEXTENDEDTHEME_H

#include "schemecolors.h"

#include <KConfigGroup>
#include <KSharedConfig>
#include <KSvg/FrameSvg>
#include <Plasma/Theme>
#include <QObject>
#include <QTemporaryDir>
#include <array>

class ExtendedTheme : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QObject *colors READ colors NOTIFY colorsChanged)

  public:
    ExtendedTheme(QObject *parent = nullptr);
    ~ExtendedTheme() override;
    ;

    QObject *colors() const;

    void load();

  signals:
    void colorsChanged();
    void themeChanged();

  private:
    void loadThemePaths();

    void setOriginalSchemeFile(const QString &file);
    void updateDefaultScheme();
    void updateDefaultSchemeValues();

  private:
    QString m_themePath;
    QString m_themeWidgetsPath;
    QString m_colorsSchemePath;
    QString m_originalSchemePath;

    std::array<QMetaObject::Connection, 2> m_kdeConnections;

    QTemporaryDir m_extendedThemeDir;
    KConfigGroup m_themeGroup;
    Plasma::Theme m_theme;

    SchemeColors *m_colorsScheme{ nullptr };
};

#endif
