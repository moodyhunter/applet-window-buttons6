/*
 * SPDX-FileCopyrightText: 2019 Michail Vourlakos <mvourlakos@gmail.org>
 *
 * This file is part of the libappletdecoration library
 *
 * SPDX-License-Identifier: GPL-2.0-only OR GPL-3.0-only OR LicenseRef-KDE-Accepted-GPL
 */

#ifndef PREVIEWSHAREDDECORATION_H
#define PREVIEWSHAREDDECORATION_H

#include "previewbridge.h"
#include "previewsettings.h"

#include <QObject>

class PreviewBridge;
class PreviewButton;
class Settings;

class SharedDecoration : public QObject
{
    Q_OBJECT
    Q_PROPERTY(PreviewBridge *bridge READ bridge WRITE setBridge NOTIFY bridgeChanged)
    Q_PROPERTY(Settings *settings READ settings WRITE setSettings NOTIFY settingsChanged)

  public:
    explicit SharedDecoration(QObject *parent = nullptr);
    virtual ~SharedDecoration();

    PreviewBridge *bridge() const;
    void setBridge(PreviewBridge *bridge);

    Settings *settings() const;
    void setSettings(Settings *settings);

    KDecoration3::Decoration *decoration() const;

    void initDecoration();

  public Q_SLOTS:
    Q_INVOKABLE void createDecoration();

  Q_SIGNALS:
    void bridgeChanged();
    void decorationChanged();
    void settingsChanged();

  private Q_SLOTS:
    void applySettings();

  private:
    QPointer<PreviewBridge> m_bridge;
    QPointer<KDecoration3::Decoration> m_decoration;
    QPointer<Settings> m_settings;

    QString m_lastPlugin;
    QString m_lastTheme;
};

#endif
