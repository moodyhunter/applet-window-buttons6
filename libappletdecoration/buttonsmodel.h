/*
 * SPDX-FileCopyrightText: 2014 Martin Gräßlin <mgraesslin@kde.org>
 * SPDX-FileCopyrightText: 2018  Michail Vourlakos <mvourlakos@gmail.org>
 *
 * This file is part of the libappletdecoration library
 *
 * SPDX-License-Identifier: GPL-2.0-only OR GPL-3.0-only OR LicenseRef-KDE-Accepted-GPL
 */

#ifndef KDECOARTIONS_PREVIEW_BUTTONS_MODEL_H
#define KDECOARTIONS_PREVIEW_BUTTONS_MODEL_H

#include <KDecoration3/DecorationButton>
#include <QAbstractListModel>

class PreviewBridge;

class ButtonsModel : public QAbstractListModel
{
    Q_OBJECT
  public:
    explicit ButtonsModel(const QVector<KDecoration3::DecorationButtonType> &buttons, QObject *parent = 0);
    explicit ButtonsModel(QObject *parent = nullptr);
    virtual ~ButtonsModel();
    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;
    int rowCount(const QModelIndex &parent = QModelIndex()) const override;
    QHash<int, QByteArray> roleNames() const override;

    QVector<KDecoration3::DecorationButtonType> buttons() const
    {
        return m_buttons;
    }

    Q_INVOKABLE void remove(int index);
    Q_INVOKABLE void up(int index);
    Q_INVOKABLE void down(int index);
    Q_INVOKABLE void move(int sourceIndex, int targetIndex);

    void add(KDecoration3::DecorationButtonType type);
    Q_INVOKABLE void add(int index, int type);

  private:
    QVector<KDecoration3::DecorationButtonType> m_buttons;
};

#endif
