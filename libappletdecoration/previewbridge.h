/*
 * SPDX-FileCopyrightText: 2014 Martin Gräßlin <mgraesslin@kde.org>
 * SPDX-FileCopyrightText: 2018 Michail Vourlakos <mvourlakos@gmail.org>
 *
 * This file is part of the libappletdecoration library
 *
 * SPDX-License-Identifier: GPL-2.0-only OR GPL-3.0-only OR LicenseRef-KDE-Accepted-GPL
 */

#ifndef KDECORATIONS_PREVIEW_BRIDGE_H
#define KDECORATIONS_PREVIEW_BRIDGE_H

#include <KDecoration3/DecorationButton>
#include <KDecoration3/Private/DecorationBridge>
#include <QList>
#include <QPointer>

class KPluginFactory;

class PreviewButtonItem;
class PreviewClient;
class PreviewSettings;

class PreviewBridge : public KDecoration3::DecorationBridge
{
    Q_OBJECT
    Q_PROPERTY(QString plugin READ plugin WRITE setPlugin NOTIFY pluginChanged)
    Q_PROPERTY(QString theme READ theme WRITE setTheme NOTIFY themeChanged)
    Q_PROPERTY(bool valid READ isValid NOTIFY validChanged)

  public:
    explicit PreviewBridge(QObject *parent = nullptr);
    virtual ~PreviewBridge();
    std::unique_ptr<KDecoration3::DecoratedWindowPrivate> createClient(KDecoration3::DecoratedWindow *client, KDecoration3::Decoration *decoration) override;
    std::unique_ptr<KDecoration3::DecorationSettingsPrivate> settings(KDecoration3::DecorationSettings *parent) override;

    PreviewClient *lastCreatedClient()
    {
        return m_lastCreatedClient;
    }
    PreviewSettings *lastCreatedSettings()
    {
        return m_lastCreatedSettings;
    }

    void registerButton(PreviewButtonItem *button);
    void unregisterButton(PreviewButtonItem *button);

    void setPlugin(const QString &plugin);
    QString plugin() const;
    void setTheme(const QString &theme);
    QString theme() const;
    bool isValid() const;

    KDecoration3::Decoration *createDecoration(QObject *parent = nullptr);
    KDecoration3::DecorationButton *createButton(KDecoration3::Decoration *decoration, KDecoration3::DecorationButtonType type, QObject *parent = nullptr);

  public Q_SLOTS:
    void reconfigure();

  Q_SIGNALS:
    void pluginChanged();
    void themeChanged();
    void validChanged();

  private slots:
    void settingsFileChanged(const QString &filename);

  private:
    void createFactory();
    void setValid(bool valid);
    PreviewClient *m_lastCreatedClient;
    PreviewSettings *m_lastCreatedSettings;
    QList<PreviewButtonItem *> m_previewButtons;
    QString m_plugin;
    QString m_theme;
    QPointer<KPluginFactory> m_factory;
    bool m_valid;
};

class BridgeItem : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString plugin READ plugin WRITE setPlugin NOTIFY pluginChanged)
    Q_PROPERTY(QString theme READ theme WRITE setTheme NOTIFY themeChanged)
    Q_PROPERTY(bool valid READ isValid NOTIFY validChanged)
    Q_PROPERTY(PreviewBridge *bridge READ bridge CONSTANT)

  public:
    explicit BridgeItem(QObject *parent = nullptr);
    virtual ~BridgeItem();

    void setPlugin(const QString &plugin)
    {
        m_bridge->setPlugin(plugin);
    }
    QString plugin() const
    {
        return m_bridge->plugin();
    }
    void setTheme(const QString &theme)
    {
        m_bridge->setTheme(theme);
    }
    QString theme() const
    {
        return m_bridge->theme();
    }
    bool isValid() const
    {
        return m_bridge->isValid();
    }

    PreviewBridge *bridge() const
    {
        return m_bridge;
    }

  Q_SIGNALS:
    void pluginChanged();
    void themeChanged();
    void validChanged();

  private:
    PreviewBridge *m_bridge;
};

Q_DECLARE_METATYPE(PreviewBridge *)

#endif
