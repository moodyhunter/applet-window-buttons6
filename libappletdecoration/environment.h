/*
 *  SPDX-FileCopyrightText: 2019 Michail Vourlakos <mvourlakos@gmail.com>
 *
 *  This file is part of Window Buttons Applet
 *
 *  SPDX-License-Identifier: GPL-2.0-or-later
 */

#ifndef ENVIRONMENT_H
#define ENVIRONMENT_H

#include <QJSEngine>
#include <QObject>
#include <QQmlEngine>

class Environment final : public QObject
{
    Q_OBJECT
    Q_PROPERTY(uint frameworksVersion READ frameworksVersion NOTIFY frameworksVersionChanged)
    Q_PROPERTY(uint plasmaDesktopVersion READ plasmaDesktopVersion NOTIFY plasmaDesktopVersionChanged)

  public:
    virtual ~Environment();

    bool compositingActive() const;
    bool isPlatformWayland() const;

    uint frameworksVersion() const;
    uint plasmaDesktopVersion();

    static QObject *instance(QQmlEngine *engine, QJSEngine *scriptEngine)
    {
        Q_UNUSED(engine)
        Q_UNUSED(scriptEngine)

        // NOTE: QML engine is the owner of this resource
        return new Environment;
    }

  public slots:
    Q_INVOKABLE uint makeVersion(uint major, uint minor, uint release) const;

  signals:
    void frameworksVersionChanged();
    void plasmaDesktopVersionChanged();

  private:
    explicit Environment(QObject *parent = nullptr);

    void loadPlasmaDesktopVersion();

    uint identifyPlasmaDesktopVersion();

  private:
    int m_plasmaDesktopVersion{ -1 };
};

#endif // ENVIRONMENT_H
