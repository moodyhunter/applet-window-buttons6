/*
 * SPDX-FileCopyrightText: 2014 Martin Gräßlin <mgraesslin@kde.org>
 * SPDX-FileCopyrightText: 2018 Michail Vourlakos <mvourlakos@gmail.org>
 *
 * This file is part of the libappletdecoration library
 *
 * SPDX-License-Identifier: GPL-2.0-only OR GPL-3.0-only OR LicenseRef-KDE-Accepted-GPL
 */

#ifndef KDECORATIONS_PREVIEW_BUTTON_ITEM_H
#define KDECORATIONS_PREVIEW_BUTTON_ITEM_H

#include "previewshareddecoration.h"

#include <KDecoration3/DecorationButton>
#include <QMargins>
#include <QPointer>
#include <QQuickPaintedItem>

class Padding;
class PreviewBridge;
class PreviewClient;

class PreviewButtonItem : public QQuickPaintedItem
{
    Q_OBJECT
    Q_PROPERTY(PreviewBridge *bridge READ bridge WRITE setBridge NOTIFY bridgeChanged)
    Q_PROPERTY(SharedDecoration *sharedDecoration READ sharedDecoration WRITE setSharedDecoration NOTIFY sharedDecorationChanged)

    Q_PROPERTY(bool isActive READ isActive WRITE setIsActive NOTIFY isActiveChanged);
    Q_PROPERTY(bool isMaximized READ isMaximized WRITE setIsMaximized NOTIFY isMaximizedChanged)
    Q_PROPERTY(bool isOnAllDesktops READ isOnAllDesktops WRITE setIsOnAllDesktops NOTIFY isOnAllDesktopsChanged)
    Q_PROPERTY(bool isKeepAbove READ isKeepAbove WRITE setIsKeepAbove NOTIFY isKeepAboveChanged)

    Q_PROPERTY(int localX READ localX WRITE setLocalX NOTIFY localXChanged)
    Q_PROPERTY(int localY READ localY WRITE setLocalY NOTIFY localYChanged)

    Q_PROPERTY(int type READ typeAsInt WRITE setType NOTIFY typeChanged)

    Q_PROPERTY(QString scheme READ scheme WRITE setScheme NOTIFY schemeChanged)
    Q_PROPERTY(Padding *padding READ padding NOTIFY paddingChanged)

  public:
    explicit PreviewButtonItem(QQuickItem *parent = nullptr);
    virtual ~PreviewButtonItem();
    void paint(QPainter *painter) override;

    PreviewBridge *bridge() const;
    void setBridge(PreviewBridge *bridge);

    SharedDecoration *sharedDecoration() const;
    void setSharedDecoration(SharedDecoration *sharedDecoration);

    KDecoration3::Decoration *decoration() const;

    bool isActive() const;
    void setIsActive(bool active);

    bool isMaximized() const;
    void setIsMaximized(bool maximized);

    bool isOnAllDesktops() const;
    void setIsOnAllDesktops(bool onalldesktops);

    bool isKeepAbove() const;
    void setIsKeepAbove(bool keepabove);

    int localX() const;
    void setLocalX(int x);

    int localY() const;
    void setLocalY(int y);

    KDecoration3::DecorationButtonType type() const;
    int typeAsInt() const;
    void setType(KDecoration3::DecorationButtonType type);
    void setType(int type);

    QString scheme() const;
    void setScheme(QString scheme);

    Padding *padding() const;

    QRect visualGeometry() const;

  Q_SIGNALS:
    void bridgeChanged();
    void isActiveChanged();
    void isMaximizedChanged();
    void isOnAllDesktopsChanged();
    void isKeepAboveChanged();
    void localXChanged();
    void localYChanged();
    void paddingChanged();
    void schemeChanged();
    void sharedDecorationChanged();
    void typeChanged();

    void clicked();

  protected:
    void mouseDoubleClickEvent(QMouseEvent *event) override;
    void mouseMoveEvent(QMouseEvent *event) override;
    void mousePressEvent(QMouseEvent *event) override;
    void mouseReleaseEvent(QMouseEvent *event) override;
    void hoverEnterEvent(QHoverEvent *event) override;
    void hoverLeaveEvent(QHoverEvent *event) override;
    void hoverMoveEvent(QHoverEvent *event) override;
    void focusOutEvent(QFocusEvent *event) override;

    void componentComplete() override;

  private Q_SLOTS:
    void createButton();
    void syncInternalGeometry();

    void onButtonDamaged();
    void onDecorationDamaged(const QRegion &region);

  private:
    QPointer<PreviewBridge> m_bridge;
    QPointer<PreviewClient> m_client;
    QPointer<SharedDecoration> m_sharedDecoration;
    QPointer<KDecoration3::Decoration> m_lastAppliedDecoration;

    KDecoration3::DecorationButton *m_button = nullptr;
    KDecoration3::DecorationButtonType m_type = KDecoration3::DecorationButtonType::Custom;

    bool m_isActive{ true };
    bool m_isMaximized{ false };
    bool m_isOnAllDesktops{ false };
    bool m_isKeepAbove{ false };

    int m_localX;
    int m_localY;

    QString m_scheme;
    QRect m_internalGeometry;
    QRect m_fullGeometry;
    QRect m_visualGeometry;

    Padding *m_padding;
};

#endif
