/*
 * SPDX-FileCopyrightText: 2018 Michail Vourlakos <mvourlakos@gmail.com>
 *
 * This file is part of the libappletdecoration library
 *
 * SPDX-License-Identifier: GPL-2.0-or-later
 *
 */

#include "themeextended.h"

#include "commontools.h"
#include "schemecolors.h"

#include <KConfigGroup>
#include <KDirWatch>
#include <KSharedConfig>
#include <QDebug>
#include <QDir>

#define DEFAULTCOLORSCHEME "default.colors"

ExtendedTheme::ExtendedTheme(QObject *parent) : QObject(parent)
{
    load();

    connect(&m_theme, &Plasma::Theme::themeChanged, this, &ExtendedTheme::load);
    connect(&m_theme, &Plasma::Theme::themeChanged, this, &ExtendedTheme::themeChanged);
}

ExtendedTheme::~ExtendedTheme()
{
    m_colorsScheme->deleteLater();
}

void ExtendedTheme::load()
{
    loadThemePaths();
}

QObject *ExtendedTheme::colors() const
{
    return m_colorsScheme;
}

void ExtendedTheme::setOriginalSchemeFile(const QString &file)
{
    if (m_originalSchemePath == file)
    {
        return;
    }

    m_originalSchemePath = file;

    qDebug() << "Window Buttons : plasma theme original colors ::: " << m_originalSchemePath;

    updateDefaultScheme();

    emit themeChanged();
}

//! WM records need to be updated based on the colors that
//! plasma will use in order to be consistent. Such an example
//! are the Breeze color schemes that have different values for
//! WM and the plasma theme records
void ExtendedTheme::updateDefaultScheme()
{
    QString defaultFilePath = m_extendedThemeDir.path() + "/" + DEFAULTCOLORSCHEME;
    if (QFileInfo(defaultFilePath).exists())
    {
        QFile(defaultFilePath).remove();
    }

    QFile(m_originalSchemePath).copy(defaultFilePath);
    m_colorsSchemePath = defaultFilePath;

    updateDefaultSchemeValues();

    if (m_colorsScheme)
    {
        disconnect(m_colorsScheme, &SchemeColors::colorsChanged, this, &ExtendedTheme::themeChanged);
        m_colorsScheme->deleteLater();
    }

    m_colorsScheme = new SchemeColors(this, m_colorsSchemePath, true);
    connect(m_colorsScheme, &SchemeColors::colorsChanged, this, &ExtendedTheme::themeChanged);

    qDebug() << "Window Buttons : plasma theme default colors ::: " << m_colorsSchemePath;

    emit colorsChanged();
}

void ExtendedTheme::updateDefaultSchemeValues()
{
    //! update WM values based on original scheme
    KSharedConfigPtr originalPtr = KSharedConfig::openConfig(m_originalSchemePath);
    KSharedConfigPtr defaultPtr = KSharedConfig::openConfig(m_colorsSchemePath);

    if (originalPtr && defaultPtr)
    {
        KConfigGroup normalWindowGroup(originalPtr, u"Colors:Window"_qs);
        KConfigGroup defaultWMGroup(defaultPtr, u"WM"_qs);

        defaultWMGroup.writeEntry("activeBackground", normalWindowGroup.readEntry("BackgroundNormal", QColor()));
        defaultWMGroup.writeEntry("activeForeground", normalWindowGroup.readEntry("ForegroundNormal", QColor()));

        defaultWMGroup.sync();
    }
}

void ExtendedTheme::loadThemePaths()
{
    m_themePath = standardPath("plasma/desktoptheme/" + m_theme.themeName());

    if (QDir(m_themePath + "/widgets").exists())
    {
        m_themeWidgetsPath = m_themePath + "/widgets";
    }
    else
    {
        m_themeWidgetsPath = standardPath("plasma/desktoptheme/default/widgets");
    }

    qDebug() << "Window Buttons : current plasma theme ::: " << m_theme.themeName();
    qDebug() << "Window Buttons : theme path ::: " << m_themePath;
    qDebug() << "Window Buttons : theme widgets path ::: " << m_themeWidgetsPath;

    //! clear kde connections
    for (auto &c : m_kdeConnections)
    {
        disconnect(c);
    }

    //! assign color schemes
    QString themeColorScheme = m_themePath + "/colors";

    if (QFileInfo(themeColorScheme).exists())
    {
        setOriginalSchemeFile(themeColorScheme);
    }
    else
    {
        //! when plasma theme uses the kde colors
        //! we track when kde color scheme is changing
        QString kdeSettingsFile = QDir::homePath() + "/.config/kdeglobals";

        KDirWatch::self()->addFile(kdeSettingsFile);

        m_kdeConnections[0] = connect(KDirWatch::self(), &KDirWatch::dirty, this,
                                      [&, kdeSettingsFile](const QString &path)
                                      {
                                          if (path == kdeSettingsFile)
                                          {
                                              this->setOriginalSchemeFile(SchemeColors::possibleSchemeFile("kdeglobals"));
                                          }
                                      });

        m_kdeConnections[1] = connect(KDirWatch::self(), &KDirWatch::created, this,
                                      [&, kdeSettingsFile](const QString &path)
                                      {
                                          if (path == kdeSettingsFile)
                                          {
                                              this->setOriginalSchemeFile(SchemeColors::possibleSchemeFile("kdeglobals"));
                                          }
                                      });

        setOriginalSchemeFile(SchemeColors::possibleSchemeFile("kdeglobals"));
    }
}
