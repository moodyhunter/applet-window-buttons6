/*
*  SPDX-FileCopyrightText: 2018 Michail Vourlakos <mvourlakos@gmail.com>
*
*  This file is part of applet-window-buttons
*
*  SPDX-License-Identifier: GPL-2.0-or-later
*/

import QtQml.Models 2.2
import QtQuick 2.7
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.plasmoid 2.0
import org.kde.taskmanager 0.1 as TaskManager

Item {
    id: plasmaTasksItem

    property bool filterByScreen: true
    readonly property bool existsWindowActive: activeTaskItem && tasksRepeater.count > 0 && (root.perScreenActive || activeTaskItem.isActive)
    readonly property bool existsWindowShown: shownTaskItem && tasksRepeater.count > 0
    readonly property bool hasTrackedWindow: tasksRepeater.count > 0
    property bool existsMaximizedWindow: false
    readonly property bool targetWindowIsActive: targetTaskItem && existsWindowShown && targetTaskItem.isActive
    readonly property bool hasActiveTask: activeTaskItem && activeTaskItem.isActive
    readonly property bool focusOutsideTaskModel: hasTrackedWindow && !hasActiveTask && !targetTaskItem
    readonly property bool targetObscuredByTrackedWindow: targetTaskItem && existsWindowShown && !targetWindowIsActive && hasActiveTask && activeTaskItem !== targetTaskItem
    readonly property bool activeFloatingWithoutMaximizedTarget: targetTaskItem && existsWindowShown && !existsMaximizedWindow && targetWindowIsActive
    readonly property Item lastActiveTaskItem: targetTaskItem
    property Item activeTaskItem: null
    property Item lastMaximizedTaskItem: null
    property Item lastBorderlessTaskItem: null
    property Item shownTaskItem: null
    property Item targetTaskItem: null

    function bestShownTaskItem() {
        var bestTask = null;

        for (var i = 0; i < tasksRepeater.count; ++i) {
            var task = tasksRepeater.itemAt(i);

            if (!task || task.isMinimized)
                continue;

            if (!bestTask || task.lastActivated > bestTask.lastActivated || (task.lastActivated === bestTask.lastActivated && task.stackingOrder > bestTask.stackingOrder))
                bestTask = task;
        }

        return bestTask;
    }

    function maximizedTaskItem() {
        var bestTask = null;

        for (var i = 0; i < tasksRepeater.count; ++i) {
            var task = tasksRepeater.itemAt(i);

            if (!task || !task.isMaximized || task.isMinimized)
                continue;

            if (!bestTask || task.lastActivated > bestTask.lastActivated || (task.lastActivated === bestTask.lastActivated && task.stackingOrder > bestTask.stackingOrder))
                bestTask = task;
        }

        return bestTask;
    }

    function borderlessTaskItem(maximizedOnly) {
        var bestTask = null;

        for (var i = 0; i < tasksRepeater.count; ++i) {
            var task = tasksRepeater.itemAt(i);

            if (!task || !task.hasNoBorder || task.isMinimized || (maximizedOnly && !task.isMaximized))
                continue;

            if (!bestTask || task.lastActivated > bestTask.lastActivated || (task.lastActivated === bestTask.lastActivated && task.stackingOrder > bestTask.stackingOrder))
                bestTask = task;
        }

        return bestTask;
    }

    function updateWindowState() {
        shownTaskItem = bestShownTaskItem();
        lastMaximizedTaskItem = maximizedTaskItem();
        lastBorderlessTaskItem = borderlessTaskItem(false);
        existsMaximizedWindow = lastMaximizedTaskItem !== null;

        if (activeTaskItem && activeTaskItem.hasNoBorder && !activeTaskItem.isMinimized) {
            targetTaskItem = activeTaskItem;
            return;
        }

        var borderlessMaximizedTaskItem = borderlessTaskItem(true);
        if (borderlessMaximizedTaskItem) {
            targetTaskItem = borderlessMaximizedTaskItem;
            return;
        }

        if (lastBorderlessTaskItem) {
            targetTaskItem = lastBorderlessTaskItem;
            return;
        }

        if (activeTaskItem && activeTaskItem.isMaximized && !activeTaskItem.isMinimized) {
            targetTaskItem = activeTaskItem;
            return;
        }

        targetTaskItem = lastMaximizedTaskItem || activeTaskItem || shownTaskItem;
    }

    function activeTask() {
        for (var i = 0; i < tasksRepeater.count; ++i) {
            var task = tasksRepeater.itemAt(i);

            if (task && task.isActive)
                return task;
        }

        return null;
    }

    function actionTargetTaskItem() {
        updateWindowState();
        return targetTaskItem;
    }

    function toggleMaximized() {
        var task = actionTargetTaskItem();

        if (task)
            task.toggleMaximized();

    }

    function toggleMinimized() {
        var task = actionTargetTaskItem();

        if (task)
            task.toggleMinimized();

    }

    function toggleClose() {
        var task = actionTargetTaskItem();

        if (task)
            task.toggleClose();

    }

    function togglePinToAllDesktops() {
        var task = actionTargetTaskItem();

        if (task)
            task.togglePinToAllDesktops();

    }

    function toggleKeepAbove() {
        var task = actionTargetTaskItem();

        if (task)
            task.toggleKeepAbove();

    }

    // To get current activity name
    TaskManager.ActivityInfo {
        id: activityInfo
    }

    // To get virtual desktop name
    TaskManager.VirtualDesktopInfo {
        id: virtualDesktopInfo
    }

    TaskManager.TasksModel {
        id: tasksModel

        sortMode: TaskManager.TasksModel.SortVirtualDesktop
        groupMode: TaskManager.TasksModel.GroupDisabled
        screenGeometry: root.screenGeometry
        activity: activityInfo.currentActivity
        virtualDesktop: virtualDesktopInfo.currentDesktop
        filterByScreen: plasmaTasksItem.filterByScreen
        filterByVirtualDesktop: true
        filterByActivity: true
    }

    Repeater {
        id: tasksRepeater

        model: DelegateModel {
            model: tasksModel

            delegate: Item {
                id: task

                readonly property string title: display
                readonly property bool isMinimized: IsMinimized === true ? true : false
                readonly property bool isMaximized: IsMaximized === true ? true : false
                readonly property bool isActive: IsActive === true ? true : false
                readonly property bool hasNoBorder: HasNoBorder === true
                readonly property bool isOnAllDesktops: IsOnAllVirtualDesktops === true ? true : false
                readonly property bool isKeepAbove: IsKeepAbove === true ? true : false
                readonly property bool isClosable: IsClosable === true ? true : false
                readonly property bool isMinimizable: IsMinimizable === true ? true : false
                readonly property bool isMaximizable: IsMaximizable === true ? true : false
                readonly property bool isVirtualDesktopsChangeable: IsVirtualDesktopsChangeable === true ? true : false
                readonly property double lastActivated: LastActivated ? LastActivated : 0
                readonly property int stackingOrder: StackingOrder ? StackingOrder : 0

                function modelIndex() {
                    return tasksModel.makeModelIndex(index);
                }

                function toggleMaximized() {
                    tasksModel.requestToggleMaximized(modelIndex());
                }

                function toggleMinimized() {
                    tasksModel.requestToggleMinimized(modelIndex());
                }

                function toggleClose() {
                    tasksModel.requestClose(modelIndex());
                }

                function togglePinToAllDesktops() {
                    tasksModel.requestVirtualDesktops(modelIndex(), isOnAllDesktops ? [virtualDesktopInfo.currentDesktop] : []);
                }

                function toggleKeepAbove() {
                    tasksModel.requestToggleKeepAbove(modelIndex());
                }

                onIsActiveChanged: {
                    plasmaTasksItem.activeTaskItem = isActive ? task : plasmaTasksItem.activeTask();
                    plasmaTasksItem.updateWindowState();
                }
                onIsMinimizedChanged: plasmaTasksItem.updateWindowState()
                onIsMaximizedChanged: plasmaTasksItem.updateWindowState()
                onHasNoBorderChanged: plasmaTasksItem.updateWindowState()
                onLastActivatedChanged: plasmaTasksItem.updateWindowState()
                onStackingOrderChanged: plasmaTasksItem.updateWindowState()
                Component.onCompleted: {
                    if (isActive)
                        plasmaTasksItem.activeTaskItem = task;

                    plasmaTasksItem.updateWindowState();
                }
                Component.onDestruction: {
                    if (plasmaTasksItem.activeTaskItem === task)
                        plasmaTasksItem.activeTaskItem = null;

                    if (plasmaTasksItem.lastMaximizedTaskItem === task)
                        plasmaTasksItem.lastMaximizedTaskItem = null;

                    if (plasmaTasksItem.lastBorderlessTaskItem === task)
                        plasmaTasksItem.lastBorderlessTaskItem = null;

                    if (plasmaTasksItem.shownTaskItem === task)
                        plasmaTasksItem.shownTaskItem = null;

                    if (plasmaTasksItem.targetTaskItem === task)
                        plasmaTasksItem.targetTaskItem = null;

                    Qt.callLater(plasmaTasksItem.updateWindowState);
                }
            }

        }

    }

}
