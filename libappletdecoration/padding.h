/*
 * SPDX-FileCopyrightText: 2018 Michail Vourlakos <mvourlakos@gmail.org>
 *
 * This file is part of the libappletdecoration library
 *
 * SPDX-License-Identifier: GPL-2.0-only OR GPL-3.0-only OR LicenseRef-KDE-Accepted-GPL
 */

#ifndef PADDING_H
#define PADDING_H

#include <QObject>

class Padding : public QObject
{
    Q_OBJECT

    Q_PROPERTY(int top READ top WRITE setTop NOTIFY topChanged);
    Q_PROPERTY(int left READ left WRITE setLeft NOTIFY leftChanged);
    Q_PROPERTY(int bottom READ bottom WRITE setBottom NOTIFY bottomChanged);
    Q_PROPERTY(int right READ right WRITE setRight NOTIFY rightChanged);

  public:
    explicit Padding(QObject *parent = nullptr);
    virtual ~Padding();

    int top() const;
    void setTop(int top);

    int left() const;
    void setLeft(int left);

    int bottom() const;
    void setBottom(int bottom);

    int right() const;
    void setRight(int right);

  signals:
    void topChanged();
    void leftChanged();
    void bottomChanged();
    void rightChanged();

  private:
    int m_top = 0;
    int m_left = 0;
    int m_bottom = 0;
    int m_right = 0;
};

#endif
