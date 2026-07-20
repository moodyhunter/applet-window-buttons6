#!/usr/bin/env node
'use strict';

const assert = require('node:assert/strict');
const fs = require('node:fs');
const path = require('node:path');

const repoRoot = path.resolve(__dirname, '..');
const mainQml = fs.readFileSync(path.join(repoRoot, 'package/contents/ui/main.qml'), 'utf8');
const tasksQml = fs.readFileSync(path.join(repoRoot, 'package/contents/ui/PlasmaTasksModel.qml'), 'utf8');

function boolProperty(source, name) {
  const match = source.match(new RegExp(`readonly property bool ${name}:\\s*([^\\n]+)`));
  assert.ok(match, `missing readonly property bool ${name}`);
  return match[1].trim();
}

// --- PlasmaTasksModel.qml contract ---

const focusExpr = boolProperty(tasksQml, 'focusOutsideTaskModel');
assert.match(
  focusExpr,
  /!targetTaskItem/,
  'cross-screen focus must not count as outside/unusable while this screen still has a local action target'
);

assert.match(
  tasksQml,
  /readonly property bool hasNoBorder:\s*HasNoBorder === true/,
  'task delegates must expose Plasma 6.4 HasNoBorder as hasNoBorder'
);
assert.match(
  tasksQml,
  /onHasNoBorderChanged:\s*plasmaTasksItem\.updateWindowState\(\)/,
  'titlebar toggles must immediately recompute the represented target'
);
assert.match(
  tasksQml,
  /function borderlessTaskItem\(maximizedOnly\)/,
  'target selection must have a borderless-window selector'
);
assert.match(
  tasksQml,
  /activeTaskItem\.hasNoBorder[\s\S]*borderlessTaskItem\(true\)[\s\S]*if \(lastBorderlessTaskItem\)/,
  'target priority must be active borderless, then maximized borderless, then best shown borderless'
);

// --- main.qml contract ---

const blocksExpr = boolProperty(mainQml, 'blocksInactiveWindowActions');
assert.doesNotMatch(
  blocksExpr,
  /existsMaximizedWindow/,
  'blocking must be based on local target availability, not a broad maximized-window shortcut'
);

const dimsExpr = boolProperty(mainQml, 'dimsInactiveWindowActions');
assert.doesNotMatch(
  dimsExpr,
  /activeFloatingWithoutMaximizedTarget/,
  'a same-screen active floating target should not self-dim; dim only when another local active window obscures the tracked target'
);

assert.match(
  mainQml,
  /readonly property bool isLastActiveWindowBorderless:/,
  'main.qml must expose the represented target titlebar state'
);
assert.match(
  mainQml,
  /if \(!lastActiveTaskItem \|\| !existsWindowShown \|\| !isLastActiveWindowBorderless\)\s*return true;/,
  'all non-AlwaysVisible modes must hide unless the represented target is borderless'
);

// isActive expressions must guard the inactive-gray path with perScreenLocalContext
const isActiveMatches = mainQml.match(/isActive:\s*\{[^}]*perScreenLocalContext[^}]*\}/g);
assert.ok(isActiveMatches && isActiveMatches.length >= 2,
  'both button delegates (pluginButton + auroraeButton) must guard isActive with perScreenLocalContext');
assert.match(
  mainQml,
  /var perScreenLocalContext = root\.perScreenActive && root\.existsWindowShown/,
  'perScreenLocalContext must be perScreenActive && existsWindowShown'
);

// --- State model ---

function desiredState({ inactiveStateEnabled, perScreenActive, hasTrackedWindow, hasActiveTask, hasTargetTaskItem, existsWindowShown, targetObscuredByTrackedWindow }) {
  const focusOutsideTaskModel = hasTrackedWindow && !hasActiveTask && !hasTargetTaskItem;
  const blocksInactiveWindowActions = inactiveStateEnabled && focusOutsideTaskModel;
  const dimsInactiveWindowActions = inactiveStateEnabled && targetObscuredByTrackedWindow;
  const perScreenLocalContext = perScreenActive && existsWindowShown;
  const isLastActiveWindowActive = hasActiveTask;
  const buttonIsGray = blocksInactiveWindowActions ||
    (!perScreenLocalContext && inactiveStateEnabled && existsWindowShown && !isLastActiveWindowActive && !dimsInactiveWindowActions);
  return {
    focusOutsideTaskModel,
    blocksInactiveWindowActions,
    dimsInactiveWindowActions,
    buttonIsGray,
  };
}

function bestTask(tasks, predicate) {
  return tasks.filter(task => !task.isMinimized && predicate(task)).sort((a, b) =>
    b.lastActivated - a.lastActivated || b.stackingOrder - a.stackingOrder)[0] || null;
}

function desiredTarget(tasks) {
  const active = tasks.find(task => task.isActive) || null;
  const shown = bestTask(tasks, () => true);
  const maximized = bestTask(tasks, task => task.isMaximized);
  const borderlessMaximized = bestTask(tasks, task => task.hasNoBorder && task.isMaximized);
  const borderless = bestTask(tasks, task => task.hasNoBorder);

  if (active && active.hasNoBorder && !active.isMinimized)
    return active;
  if (borderlessMaximized)
    return borderlessMaximized;
  if (borderless)
    return borderless;
  if (active && active.isMaximized && !active.isMinimized)
    return active;
  return maximized || active || shown;
}

function desiredMustHide({ alwaysVisible, editMode, target }) {
  if (alwaysVisible || editMode)
    return false;
  return !target || !target.hasNoBorder;
}

const titledFloating = { id: 'titled-floating', hasNoBorder: false, isMaximized: false, isMinimized: false, isActive: true, lastActivated: 40, stackingOrder: 40 };
const borderlessFloating = { id: 'borderless-floating', hasNoBorder: true, isMaximized: false, isMinimized: false, isActive: true, lastActivated: 50, stackingOrder: 50 };
const borderlessTiled = { id: 'borderless-tiled', hasNoBorder: true, isMaximized: false, isMinimized: false, isActive: true, lastActivated: 60, stackingOrder: 60 };
const borderlessMaximized = { id: 'borderless-maximized', hasNoBorder: true, isMaximized: true, isMinimized: false, isActive: false, lastActivated: 30, stackingOrder: 30 };
const titledMaximized = { id: 'titled-maximized', hasNoBorder: false, isMaximized: true, isMinimized: false, isActive: true, lastActivated: 70, stackingOrder: 70 };

assert.equal(desiredMustHide({ alwaysVisible: false, editMode: false, target: desiredTarget([borderlessFloating]) }), false,
  'borderless floating target shows panel buttons');
assert.equal(desiredMustHide({ alwaysVisible: false, editMode: false, target: desiredTarget([borderlessTiled]) }), false,
  'borderless tiled target shows panel buttons');
assert.equal(desiredMustHide({ alwaysVisible: false, editMode: false, target: desiredTarget([borderlessMaximized]) }), false,
  'borderless maximized target shows panel buttons');
assert.equal(desiredMustHide({ alwaysVisible: false, editMode: false, target: desiredTarget([titledMaximized]) }), true,
  'enabling the native titlebar on a maximized target hides panel buttons');
assert.equal(desiredMustHide({ alwaysVisible: false, editMode: false, target: desiredTarget([titledFloating]) }), true,
  'a titled floating target does not duplicate controls in the panel');
assert.equal(desiredTarget([borderlessMaximized, titledFloating]).id, 'borderless-maximized',
  'borderless maximized target stays represented behind an active titled floating window');
assert.equal(desiredTarget([titledMaximized, { ...borderlessFloating, isActive: false }]).id, 'borderless-floating',
  'a shown borderless floating window outranks a titled maximized target');
assert.equal(desiredMustHide({ alwaysVisible: true, editMode: false, target: titledMaximized }), false,
  'AlwaysVisible explicitly overrides titlebar-aware hiding');
assert.equal(desiredMustHide({ alwaysVisible: false, editMode: true, target: titledMaximized }), false,
  'edit mode explicitly overrides titlebar-aware hiding');

const titlebarToggleTarget = { ...borderlessMaximized };
assert.equal(desiredMustHide({ alwaysVisible: false, editMode: false, target: titlebarToggleTarget }), false,
  'maximized target starts visible while borderless');
titlebarToggleTarget.hasNoBorder = false;
assert.equal(desiredMustHide({ alwaysVisible: false, editMode: false, target: titlebarToggleTarget }), true,
  'enabling the native titlebar immediately flips the same target to hidden');
titlebarToggleTarget.hasNoBorder = true;
assert.equal(desiredMustHide({ alwaysVisible: false, editMode: false, target: titlebarToggleTarget }), false,
  'disabling the native titlebar immediately flips the same target back to visible');

// Per-screen: maximized local target stays bright when focus moves to another screen
assert.deepEqual(desiredState({
  inactiveStateEnabled: true,
  perScreenActive: true,
  hasTrackedWindow: true,
  hasActiveTask: false,
  hasTargetTaskItem: true,
  existsWindowShown: true,
  targetObscuredByTrackedWindow: false,
}), {
  focusOutsideTaskModel: false,
  blocksInactiveWindowActions: false,
  dimsInactiveWindowActions: false,
  buttonIsGray: false,
}, 'per-screen: local target stays bright under cross-screen focus');

// Same-screen: floating-over-target dims without blocking
assert.deepEqual(desiredState({
  inactiveStateEnabled: true,
  perScreenActive: true,
  hasTrackedWindow: true,
  hasActiveTask: true,
  hasTargetTaskItem: true,
  existsWindowShown: true,
  targetObscuredByTrackedWindow: true,
}), {
  focusOutsideTaskModel: false,
  blocksInactiveWindowActions: false,
  dimsInactiveWindowActions: true,
  buttonIsGray: false,
}, 'same-screen floating-over-target dims without blocking');

// No local target: remains blocked/gray
assert.deepEqual(desiredState({
  inactiveStateEnabled: true,
  perScreenActive: true,
  hasTrackedWindow: true,
  hasActiveTask: false,
  hasTargetTaskItem: false,
  existsWindowShown: false,
  targetObscuredByTrackedWindow: false,
}), {
  focusOutsideTaskModel: true,
  blocksInactiveWindowActions: true,
  dimsInactiveWindowActions: false,
  buttonIsGray: true,
}, 'no local target remains blocked');

// perScreenActive off: standard inactive gray behavior preserved
assert.deepEqual(desiredState({
  inactiveStateEnabled: true,
  perScreenActive: false,
  hasTrackedWindow: true,
  hasActiveTask: false,
  hasTargetTaskItem: true,
  existsWindowShown: true,
  targetObscuredByTrackedWindow: false,
}), {
  focusOutsideTaskModel: false,
  blocksInactiveWindowActions: false,
  dimsInactiveWindowActions: false,
  buttonIsGray: true,
}, 'perScreenActive off: standard inactive gray behavior preserved');

console.log('windowbuttons state contract ok');
