/*
 * SPDX-FileCopyrightText: 2018 Michail Vourlakos <mvourlakos@gmail.com>
 *
 * This file is part of the libappletdecoration library
 *
 * SPDX-License-Identifier: GPL-2.0-or-later
 *
 */

#ifndef SCHEMESMODEL_H
#define SCHEMESMODEL_H

#include <QAbstractListModel>

class SchemeColors;

class SchemesModel : public QAbstractListModel
{
    Q_OBJECT

  public:
    explicit SchemesModel(QObject *parent = nullptr);
    virtual ~SchemesModel();

    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;
    int rowCount(const QModelIndex &parent = QModelIndex()) const override;
    QHash<int, QByteArray> roleNames() const override;

    Q_INVOKABLE int indexOf(QString file) const;
    Q_INVOKABLE QColor backgroundOf(const int &index) const;

    Q_INVOKABLE QString defaultSchemeFile() const;
  private slots:
    void initSchemes();

  private:
    void insertSchemeInList(QString file);

  private:
    QString m_defaultSchemeFile;
    QList<SchemeColors *> m_schemes;
};

#endif
