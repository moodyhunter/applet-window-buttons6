/*
 * SPDX-FileCopyrightText: 2014 Martin Gräßlin <mgraesslin@kde.org>
 * SPDX-FileCopyrightText: 2018 Michail Vourlakos <mvourlakos@gmail.org>
 *
 * This file is part of the libappletdecoration library
 *
 * SPDX-License-Identifier: GPL-2.0-only OR GPL-3.0-only OR LicenseRef-KDE-Accepted-GPL
 */

#ifndef KDECORATIONS_PREVIEW_CLIENT_H
#define KDECORATIONS_PREVIEW_CLIENT_H

#include "decorationpalette.h"

#include <KDecoration3/Private/DecoratedWindowPrivate>
#include <QObject>
#include <QPalette>
#include <config-decoration.h>
#include <KDecoration3/Decoration>

class QAbstractItemModel;

class PreviewClient
    : public QObject
    , public KDecoration3::DecoratedWindowPrivate
{
    Q_OBJECT
    Q_PROPERTY(KDecoration3::Decoration *decoration READ decoration CONSTANT)
    Q_PROPERTY(QString caption READ caption WRITE setCaption NOTIFY captionChanged)
    Q_PROPERTY(QIcon icon READ icon WRITE setIcon NOTIFY iconChanged)
    Q_PROPERTY(QString iconName READ iconName WRITE setIconName NOTIFY iconNameChanged)
    Q_PROPERTY(bool active READ isActive WRITE setActive NOTIFY activeChanged)
    Q_PROPERTY(bool closeable READ isCloseable WRITE setCloseable NOTIFY closeableChanged)
    Q_PROPERTY(bool keepAbove READ isKeepAbove WRITE setKeepAbove NOTIFY keepAboveChanged)
    Q_PROPERTY(bool keepBelow READ isKeepBelow WRITE setKeepBelow NOTIFY keepBelowChanged)
    Q_PROPERTY(bool maximizable READ isMaximizeable WRITE setMaximizable NOTIFY maximizableChanged)
    Q_PROPERTY(bool maximized READ isMaximized NOTIFY maximizedChanged)
    Q_PROPERTY(bool maximizedVertically READ isMaximizedVertically WRITE setMaximizedVertically NOTIFY maximizedVerticallyChanged)
    Q_PROPERTY(bool maximizedHorizontally READ isMaximizedHorizontally WRITE setMaximizedHorizontally NOTIFY maximizedHorizontallyChanged)
    Q_PROPERTY(bool minimizable READ isMinimizeable WRITE setMinimizable NOTIFY minimizableChanged)
    Q_PROPERTY(bool modal READ isModal WRITE setModal NOTIFY modalChanged)
    Q_PROPERTY(bool movable READ isMoveable WRITE setMovable NOTIFY movableChanged)
    Q_PROPERTY(int desktop READ desktop WRITE setDesktop NOTIFY desktopChanged)
    Q_PROPERTY(bool onAllDesktops READ isOnAllDesktops NOTIFY onAllDesktopsChanged)
    Q_PROPERTY(bool resizable READ isResizeable WRITE setResizable NOTIFY resizableChanged)
    Q_PROPERTY(bool shadeable READ isShadeable WRITE setShadeable NOTIFY shadeableChanged)
    Q_PROPERTY(bool shaded READ isShaded WRITE setShaded NOTIFY shadedChanged)
    Q_PROPERTY(bool providesContextHelp READ providesContextHelp WRITE setProvidesContextHelp NOTIFY providesContextHelpChanged)
    Q_PROPERTY(int width READ width WRITE setWidth NOTIFY widthChanged)
    Q_PROPERTY(int height READ height WRITE setHeight NOTIFY heightChanged)
    Q_PROPERTY(bool bordersTopEdge READ bordersTopEdge WRITE setBordersTopEdge NOTIFY bordersTopEdgeChanged)
    Q_PROPERTY(bool bordersLeftEdge READ bordersLeftEdge WRITE setBordersLeftEdge NOTIFY bordersLeftEdgeChanged)
    Q_PROPERTY(bool bordersRightEdge READ bordersRightEdge WRITE setBordersRightEdge NOTIFY bordersRightEdgeChanged)
    Q_PROPERTY(bool bordersBottomEdge READ bordersBottomEdge WRITE setBordersBottomEdge NOTIFY bordersBottomEdgeChanged)
  public:
    explicit PreviewClient(KDecoration3::DecoratedWindow *client, KDecoration3::Decoration *decoration);
    virtual ~PreviewClient();

    QString caption() const override;
    int desktop() const;
    QIcon icon() const override;
    bool isActive() const override;
    bool isCloseable() const override;
    bool isKeepAbove() const override;
    bool isKeepBelow() const override;
    bool isMaximizeable() const override;
    bool isMaximized() const override;
    bool isMaximizedVertically() const override;
    bool isMaximizedHorizontally() const override;
    bool isMinimizeable() const override;
    bool isModal() const override;
    bool isMoveable() const override;
    bool isOnAllDesktops() const override;
    bool isResizeable() const override;
    bool isShadeable() const override;
    bool isShaded() const override;
    bool providesContextHelp() const override;
    QString windowClass() const override;

    qreal width() const override;
    qreal height() const override;
    qreal scale() const override;
    qreal nextScale() const override;
    QPalette palette() const override;
    QColor color(KDecoration3::ColorGroup group, KDecoration3::ColorRole role) const override;
    Qt::Edges adjacentScreenEdges() const override;

    bool hasApplicationMenu() const override;
    bool isApplicationMenuActive() const override;

    void requestShowToolTip(const QString &text) override;
    void requestHideToolTip() override;

    QSizeF size() const override;

    void requestShowWindowMenu(const QRect &rect) override;

    void requestClose() override;
    void requestContextHelp() override;
    void requestToggleMaximization(Qt::MouseButtons buttons) override;
    void requestMinimize() override;
    void requestToggleKeepAbove() override;
    void requestToggleKeepBelow() override;
    void requestToggleShade() override;
    void requestShowApplicationMenu(const QRect &rect, int actionId) override;
    void requestToggleOnAllDesktops() override;

    void showApplicationMenu(int actionId) override;

    void setCaption(const QString &caption);
    void setActive(bool active);
    void setCloseable(bool closeable);
    void setMaximizable(bool maximizable);
    void setKeepBelow(bool keepBelow);
    void setKeepAbove(bool keepAbove);
    void setMaximizedHorizontally(bool maximized);
    void setMaximizedVertically(bool maximized);
    void setMinimizable(bool minimizable);
    void setModal(bool modal);
    void setMovable(bool movable);
    void setResizable(bool resizable);
    void setShadeable(bool shadeable);
    void setShaded(bool shaded);
    void setProvidesContextHelp(bool contextHelp);
    void setDesktop(int desktop);
    void setColorScheme(QString scheme);

    void setWidth(int width);
    void setHeight(int height);

    QString iconName() const;
    void setIconName(const QString &icon);
    void setIcon(const QIcon &icon);

    bool bordersTopEdge() const;
    bool bordersLeftEdge() const;
    bool bordersRightEdge() const;
    bool bordersBottomEdge() const;

    void setBordersTopEdge(bool enabled);
    void setBordersLeftEdge(bool enabled);
    void setBordersRightEdge(bool enabled);
    void setBordersBottomEdge(bool enabled);

  Q_SIGNALS:
    void captionChanged(const QString &);
    void iconChanged(const QIcon &);
    void iconNameChanged(const QString &);
    void activeChanged(bool);
    void closeableChanged(bool);
    void keepAboveChanged(bool);
    void keepBelowChanged(bool);
    void maximizableChanged(bool);
    void maximizedChanged(bool);
    void maximizedVerticallyChanged(bool);
    void maximizedHorizontallyChanged(bool);
    void minimizableChanged(bool);
    void modalChanged(bool);
    void movableChanged(bool);
    void onAllDesktopsChanged(bool);
    void resizableChanged(bool);
    void shadeableChanged(bool);
    void shadedChanged(bool);
    void providesContextHelpChanged(bool);
    void desktopChanged(int);
    void widthChanged(int);
    void heightChanged(int);
    void paletteChanged(const QPalette &);
    void bordersTopEdgeChanged(bool);
    void bordersLeftEdgeChanged(bool);
    void bordersRightEdgeChanged(bool);
    void bordersBottomEdgeChanged(bool);

    void showWindowMenuRequested();
    void showApplicationMenuRequested();
    void minimizeRequested();
    void closeRequested();

  private:
    QString m_caption;
    QIcon m_icon;
    QString m_iconName;
    QString m_colorScheme;
    DecorationPalette *m_palette{ nullptr };
    bool m_active;
    bool m_closeable;
    bool m_keepBelow;
    bool m_keepAbove;
    bool m_maximizable;
    bool m_maximizedHorizontally;
    bool m_maximizedVertically;
    bool m_minimizable;
    bool m_modal;
    bool m_movable;
    bool m_resizable;
    bool m_shadeable;
    bool m_shaded;
    bool m_providesContextHelp;
    int m_desktop;
    qreal m_width;
    qreal m_height;
    bool m_bordersTopEdge;
    bool m_bordersLeftEdge;
    bool m_bordersRightEdge;
    bool m_bordersBottomEdge;
};

#endif
