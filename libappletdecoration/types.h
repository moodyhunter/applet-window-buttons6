/*
 *  SPDX-FileCopyrightText: 2018 Michail Vourlakos <mvourlakos@gmail.com>
 *
 *  This file is part of the libappletdecoration library
 *
 *  SPDX-License-Identifier: GPL-2.0-or-later
 */

#ifndef TYPES_H
#define TYPES_H

#include <QMetaEnum>
#include <QMetaType>
#include <QObject>

class Types
{
    Q_GADGET

  public:
    Types() = delete;
    ~Types(){};

    enum ButtonType
    {
        Menu = 0,
        ApplicationMenu,
        OnAllDesktops,
        Minimize,
        Maximize,
        Close,
        ContextHelp,
        Shade,
        KeepBelow,
        KeepAbove,
        Custom
    };
    Q_ENUM(ButtonType)

    enum Actions
    {
        ActionClose = 0,
        ToggleMinimize,
        ToggleMaximize,
        TogglePinToAllDesktops,
        ToggleKeepAbove
    };
    Q_ENUM(Actions)

    enum ButtonSize
    {
        TinyButton = 0,
        NormalButton,
        LargeButton,
        VeryLargeButton,
        HugeButton,
        VeryHugeButton,
        OversizedButton
    };
    Q_ENUM(ButtonSize)

    enum Visibility
    {
        AlwaysVisible = 0,
        ActiveWindow,
        ActiveMaximizedWindow,
        ShownWindowExists
    };
    Q_ENUM(Visibility)

    enum HiddenState
    {
        SlideOut = 0,
        EmptySpace
    };
    Q_ENUM(HiddenState)
};

#endif
