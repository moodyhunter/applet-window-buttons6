/*
 * SPDX-FileCopyrightText: 2019 Michail Vourlakos <mvourlakos@gmail.org>
 *
 * This file is part of the libappletdecoration library
 *
 * SPDX-License-Identifier: GPL-2.0-only OR GPL-3.0-only OR LicenseRef-KDE-Accepted-GPL
 */

#include "previewshareddecoration.h"

#include "previewbridge.h"
#include "previewbutton.h"
#include "previewsettings.h"

#include <KDecoration3/Decoration>

SharedDecoration::SharedDecoration(QObject *parent) : QObject(parent)
{
    connect(this, &SharedDecoration::bridgeChanged, this, &SharedDecoration::createDecoration);
    connect(this, &SharedDecoration::settingsChanged, this, &SharedDecoration::applySettings);
}

SharedDecoration::~SharedDecoration()
{
}

PreviewBridge *SharedDecoration::bridge() const
{
    return m_bridge.data();
}

void SharedDecoration::setBridge(PreviewBridge *bridge)
{
    if (m_bridge == bridge)
    {
        return;
    }

    if (m_bridge)
    {
        connect(m_bridge, &PreviewBridge::validChanged, this, &SharedDecoration::createDecoration);
    }

    m_bridge = bridge;

    connect(m_bridge, &PreviewBridge::validChanged, this, &SharedDecoration::createDecoration);

    emit bridgeChanged();
}

KDecoration3::Decoration *SharedDecoration::decoration() const
{
    return m_decoration;
}

Settings *SharedDecoration::settings() const
{
    return m_settings.data();
}

void SharedDecoration::setSettings(Settings *settings)
{
    if (m_settings == settings)
    {
        return;
    }

    m_settings = settings;

    createDecoration();

    emit settingsChanged();
}

void SharedDecoration::applySettings()
{
    if (!m_decoration || !m_settings)
    {
        return;
    }

    m_decoration->setSettings(m_settings->settings());
    m_decoration->init();
}

void SharedDecoration::createDecoration()
{
    if (!m_bridge || !m_settings)
    {
        return;
    }

    bool newDecoration = (m_bridge->plugin() != m_lastPlugin || m_bridge->theme() != m_lastTheme);

    if (m_decoration && newDecoration)
    {
        m_decoration->deleteLater();
    }

    if (newDecoration)
    {
        m_decoration = m_bridge->createDecoration(this);
    }

    if (m_decoration)
    {
        m_decoration->setSettings(m_settings->settings());
        m_decoration->create();
        m_decoration->init();
        m_decoration->apply(m_decoration->nextState()->clone());
        m_decoration->setObjectName("applet-window-buttons");
    }

    m_lastPlugin = m_bridge->plugin();
    m_lastTheme = m_bridge->theme();

    emit decorationChanged();
}

void SharedDecoration::initDecoration()
{
    if (m_decoration)
    {
        m_decoration->init();
    }
}
