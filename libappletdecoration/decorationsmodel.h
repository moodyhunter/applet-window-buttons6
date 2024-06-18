/*
 * SPDX-FileCopyrightText: 2014 Martin Gräßlin <mgraesslin@kde.org>
 * SPDX-FileCopyrightText: 2018 Michail Vourlakos <mvourlakos@gmail.org>
 *
 * This file is part of the libappletdecoration library
 *
 * SPDX-License-Identifier: GPL-2.0-only OR GPL-3.0-only OR LicenseRef-KDE-Accepted-GPL
 */

#ifndef DECORATIONSMODEL_H
#define DECORATIONSMODEL_H

#include <QAbstractListModel>

class DecorationsModel : public QAbstractListModel
{
    Q_OBJECT
    Q_PROPERTY(int count READ count NOTIFY countChanged)
    Q_PROPERTY(QString currentPlugin READ currentPlugin NOTIFY currentPluginChanged)
    Q_PROPERTY(QString currentTheme READ currentTheme NOTIFY currentThemeChanged)

  public:
    explicit DecorationsModel(QObject *parent = nullptr);
    virtual ~DecorationsModel();

    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;
    int rowCount(const QModelIndex &parent = QModelIndex()) const override;
    QHash<int, QByteArray> roleNames() const override;

    QModelIndex findDecoration(const QString &pluginName, const QString &themeName = QString()) const;

    QMap<QString, QString> knsProviders() const
    {
        return m_knsProvides;
    }

    int count() const;

    QString currentPlugin() const;
    QString currentTheme() const;

  public Q_SLOTS:
    Q_INVOKABLE bool decorationExists(const QString &plugin, const QString &theme);
    Q_INVOKABLE bool isAurorae(const QString &plugin, const QString &theme);

  signals:
    void countChanged();
    void currentThemeChanged();
    void currentPluginChanged();

  private slots:
    void init();
    void loadCurrents();
    void kwinChanged(const QString &filename);
    void setCurrentPlugin(QString plugin);
    void setCurrentTheme(QString theme);

  private:
    bool pluginExists(const QString &plugin);

  private:
    struct Data
    {
        QString pluginName;
        QString themeName;
        QString visibleName;
        bool isAuroraeTheme = false;
        bool configuration = false;
    };

    QString m_currentPlugin;
    QString m_currentTheme;

    std::vector<Data> m_plugins;
    QMap<QString, QString> m_knsProvides;
};

#endif
