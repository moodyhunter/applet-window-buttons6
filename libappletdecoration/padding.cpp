/*
 * SPDX-FileCopyrightText: 2018 Michail Vourlakos <mvourlakos@gmail.org>
 *
 * This file is part of the libappletdecoration library
 *
 * SPDX-License-Identifier: GPL-2.0-only OR GPL-3.0-only OR LicenseRef-KDE-Accepted-GPL
 */

#include "padding.h"

Padding::Padding(QObject *parent) : QObject(parent)
{
}

Padding::~Padding()
{
}

int Padding::top() const
{
    return m_top;
}

void Padding::setTop(int top)
{
    if (m_top == top)
    {
        return;
    }

    m_top = top;
    emit topChanged();
}

int Padding::left() const
{
    return m_left;
}

void Padding::setLeft(int left)
{
    if (m_left == left)
    {
        return;
    }

    m_left = left;
    emit leftChanged();
}

int Padding::bottom() const
{
    return m_bottom;
}

void Padding::setBottom(int bottom)
{
    if (m_bottom == bottom)
    {
        return;
    }

    m_bottom = bottom;
    emit bottomChanged();
}

int Padding::right() const
{
    return m_right;
}

void Padding::setRight(int right)
{
    if (m_right == right)
    {
        return;
    }

    m_right = right;
    emit rightChanged();
}
