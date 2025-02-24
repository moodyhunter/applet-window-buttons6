/*
*  SPDX-FileCopyrightText: 2018 Michail Vourlakos <mvourlakos@gmail.com>
*
*  This file is part of applet-window-buttons
*
*  SPDX-License-Identifier: GPL-2.0-or-later
*/

function addButton(preparedArray, buttonType) {
    if (buttonType === AppletDecoration.Types.Close) {
        preparedArray.push({
            buttonType: AppletDecoration.Types.Close,
            windowOperation: AppletDecoration.Types.ActionClose
        });
    } else if (buttonType === AppletDecoration.Types.Maximize) {
        preparedArray.push({
            buttonType: AppletDecoration.Types.Maximize,
            windowOperation: AppletDecoration.Types.ToggleMaximize
        });
    } else if (buttonType === AppletDecoration.Types.Minimize) {
        preparedArray.push({
            buttonType: AppletDecoration.Types.Minimize,
            windowOperation: AppletDecoration.Types.ToggleMinimize
        });
    } else if (buttonType === AppletDecoration.Types.OnAllDesktops) {
        preparedArray.push({
            buttonType: AppletDecoration.Types.OnAllDesktops,
            windowOperation: AppletDecoration.Types.TogglePinToAllDesktops
        });
    } else if (buttonType === AppletDecoration.Types.Custom) {
        preparedArray.push({
            buttonType: AppletDecoration.Types.Custom,
            windowOperation: -1
        });
    } else if (buttonType === AppletDecoration.Types.KeepAbove) {
        preparedArray.push({
            buttonType: AppletDecoration.Types.KeepAbove,
            windowOperation: AppletDecoration.Types.ToggleKeepAbove
        });
    }
}

function indexOfSplitter(listModel) {
    for (var i = 0; i < listModel.count; ++i) {
        var item = listModel.get(i);

        if (item.buttonType === AppletDecoration.Types.Custom) {
            return i;
        }
    }

    return -1;
}

function initializeControlButtonsModel(buttons, toArray, toListModel, stopOnSeparator) {
    toArray.length = 0;

    for (var i = 0; i < buttons.length; ++i) {
        var type = Number(buttons[i]);

        if (type === AppletDecoration.Types.Custom && stopOnSeparator) {
            break;
        }

        addButton(toArray, Number(buttons[i]));
    }

    toListModel.clear()

    for (var i = 0; i < toArray.length; ++i) {
        toListModel.append(toArray[i]);
    }
}
