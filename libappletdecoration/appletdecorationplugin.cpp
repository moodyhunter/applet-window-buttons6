/*
 *  SPDX-FileCopyrightText: 2018 Michail Vourlakos <mvourlakos@gmail.com>
 *
 *  This file is part of the libappletdecoration library
 *
 *  SPDX-License-Identifier: GPL-2.0-or-later
 */

#include "appletdecorationplugin.h"

#include "auroraetheme.h"
#include "decorationsmodel.h"
#include "environment.h"
#include "kwinconfig.h"
#include "padding.h"
#include "previewbridge.h"
#include "previewbutton.h"
#include "previewclient.h"
#include "previewsettings.h"
#include "previewshareddecoration.h"
#include "schemesmodel.h"
#include "themeextended.h"
#include "types.h"

#include <KDecoration2/Decoration>
#include <QQmlEngine>
#include <QtQml>

void AppletDecorationPlugin::registerTypes(const char *uri)
{
    Q_ASSERT(uri == QLatin1String("org.kde.appletdecoration"));
    qmlRegisterUncreatableType<Types>(uri, 0, 1, "Types", "Applet decoration types");

    qmlRegisterType<AuroraeTheme>(uri, 0, 1, "AuroraeTheme");
    qmlRegisterType<BridgeItem>(uri, 0, 1, "Bridge");
    qmlRegisterType<Settings>(uri, 0, 1, "Settings");
    qmlRegisterType<PreviewButtonItem>(uri, 0, 1, "Button");
    qmlRegisterType<DecorationsModel>(uri, 0, 1, "DecorationsModel");
    qmlRegisterType<SchemesModel>(uri, 0, 1, "ColorsModel");
    qmlRegisterType<SharedDecoration>(uri, 0, 1, "SharedDecoration");
    qmlRegisterType<ExtendedTheme>(uri, 0, 1, "PlasmaThemeExtended");
    qmlRegisterType<KWinConfig>(uri, 0, 1, "KWinConfig");

    qmlRegisterAnonymousType<Padding>("", 1);
    qmlRegisterAnonymousType<PreviewClient>("", 1);
    qmlRegisterAnonymousType<PreviewBridge>("", 1);
    qmlRegisterAnonymousType<KDecoration2::Decoration>("", 1);

    qmlRegisterSingletonType<Environment>(uri, 0, 1, "Environment", &Environment::instance);
}
