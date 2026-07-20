# Window Buttons Applet

This Plasma 6 applet provides window controls in a Plasma panel. It is intended
for global-menu and top-panel layouts where the panel can act as the titlebar for
borderless windows.

## Window targeting and titlebar behavior

The applet keeps the existing Plasma package id (`org.kde.windowbuttons`) and
tracks the window represented by its controls independently from global focus.

## Fixed problem

Tying both visibility and button actions only to the active window breaks a
top-panel workflow:

1. A maximized, borderless window is visually represented by the top panel.
2. A small floating window, dialog, picker, or helper gets focus above it.
3. The panel still looks like the maximized window's titlebar.
4. Pressing the panel close/maximize/minimize buttons unexpectedly affects the
   focused floating window instead of the maximized window behind it.

The applet makes the panel buttons target the maximized window on the current
screen, because that is the window the panel visually represents. Focus is only
used as a fallback when no maximized window exists.

Changes:

- Outside Always Visible and panel edit mode, controls are shown exactly when the
  represented window has KWin's `HasNoBorder` state. Toggling the native titlebar
  with Meta+B therefore updates the panel immediately for floating, tiled, and
  maximized windows, without duplicate controls.
- Borderless targets are preferred in this order: active borderless, maximized
  borderless, then most recently activated/stacked borderless. This preserves
  the maximized-window target behind a focused titled helper while also
  supporting borderless floating and tiled windows.
- Window button actions prefer the maximized window on the current screen. If a
  floating dialog or helper window is focused above a maximized window, the
  panel buttons still operate on the maximized window they visually represent.
- If no maximized window exists on that screen, actions fall back to the active
  window, preserving the useful upstream behavior for normal/floating sessions.
- The old "Active window is maximized" behavior is treated as a compatibility
  alias for the maximized-window behavior, because tying panel titlebar
  visibility to focus is misleading when floating windows overlap maximized
  windows.
- A real `MaximizedWindowExists` visibility mode is added and exposed in the
  Behavior settings as "Maximized window is shown".
- Maximized-window detection uses Plasma's `TaskManager.TasksModel` after its
  existing screen, virtual desktop, and activity filters. With "Show only for
  windows in current screen" enabled, visibility and actions are screen-local.
- "Draw buttons inactive state when needed" is evaluated against the window
  represented by the panel buttons, not whichever floating window currently has
  focus. If the target window is inactive, the panel buttons use inactive
  decoration colors;
  when that target window is active, they use active colors.
- If focus moves to a special window outside Plasma's task model, such as
  Yakuake, the represented window buttons become truly inactive and clicks do
  nothing. If focus moves to a normal tracked floating window, the represented
  buttons stay usable but are dimmed to show that their target is not focused.
- Button release and hover events are forwarded to KDecoration with corrected
  coordinates, avoiding stale pointer state caused by mismatched event geometry.
- Synthetic Qt input events use Qt 6 constructors while keeping
  `event->position()` in KDecoration's local coordinate system and preserving the
  originating pointer device.
- Decoration buttons are recreated when the represented target window changes,
  which keeps Breeze's internal maximize/restore `checked` state synchronized
  even when both the old and new targets are maximized.

The goal is to provide predictable defaults for Plasma setups where borderless
windows use the top panel for their window controls.

## Plasma 6 / KDecoration3 compatibility

The current code targets Plasma 6 and KDecoration3. Plasma 6.3 introduced the
KDecoration3 API break so server-side decorations can handle fractional scaling
with floating-point geometry. The code intentionally builds against
KDecoration3 rather than carrying KDecoration2 compatibility shims.

Minimum build/runtime expectations:

- Qt >= 6.6
- KDE Frameworks >= 6.0
- Plasma >= 6.4 (for the Task Manager `HasNoBorder` role)
- KDecoration3 >= 6.3
- CMake >= 3.20
- C++20 compiler

The native button bridge uses KDecoration3 `DecorationButton` and
`DecoratedWindow` state, including the button `checked` state used by Breeze for
maximize/restore and on-all-desktops glyphs. When changing this area, test both
Breeze plugin buttons and Aurorae buttons because they use different rendering
paths.

## Install from source

```bash
cmake -B build -S .
cmake --build build
sudo cmake --install build
systemctl --user restart plasma-plasmashell.service
```

Avoid injecting a rebuilt native QML module into a running plasmashell through a
local import override. For native plugin experiments, install a normal package
or use an isolated Plasma/plasmoid test session.

## Audit notes

- Keep the code aligned with KDE's KDecoration3 direction: avoid KDecoration2
  compatibility paths and prefer `QRectF`/floating geometry APIs where available.
- Runtime debug logging should stay out of normal builds; use temporary local
  instrumentation for diagnosis and remove it before committing.
- Treat `TaskManager.TasksModel` state as asynchronous. Prefer small,
  observable UI refreshes over stale task-pointer caches when decoration state
  changes.
