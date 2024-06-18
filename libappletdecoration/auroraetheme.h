/*
 *  SPDX-FileCopyrightText: 2018 Michail Vourlakos <mvourlakos@gmail.com>
 *
 *  This file is part of the libappletdecoration library
 *
 *  SPDX-License-Identifier: GPL-2.0-or-later
 */

#ifndef AURORAETHEME_H
#define AURORAETHEME_H

#include "types.h"

#include <QColor>
#include <QObject>

class AuroraeTheme : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString theme READ theme WRITE setTheme NOTIFY themeChanged)
    Q_PROPERTY(QString themeName READ themeName NOTIFY themeChanged)
    Q_PROPERTY(QString themePath READ themePath NOTIFY themeChanged)
    Q_PROPERTY(QString themeType READ themeType NOTIFY themeChanged)

    Q_PROPERTY(int buttonHeight READ buttonHeight NOTIFY settingsChanged)
    Q_PROPERTY(int buttonWidth READ buttonWidth NOTIFY settingsChanged)
    Q_PROPERTY(int buttonSpacing READ buttonSpacing NOTIFY settingsChanged)
    Q_PROPERTY(int duration READ duration NOTIFY settingsChanged)

    Q_PROPERTY(float buttonRatio READ buttonRatio NOTIFY settingsChanged)

    Q_PROPERTY(QColor titleBackgroundColor READ titleBackgroundColor NOTIFY settingsChanged)

    Q_PROPERTY(bool hasRestoreButton READ hasRestoreButton NOTIFY settingsChanged)

    Q_PROPERTY(bool hasMonochromeIcons READ hasMonochromeIcons NOTIFY settingsChanged)
    Q_PROPERTY(QString monochromePrefix READ monochromePrefix NOTIFY settingsChanged)

  public:
    explicit AuroraeTheme(QObject *parent = nullptr);
    ~AuroraeTheme() override;
    ;

    QString theme() const;
    void setTheme(QString theme);

    QString themeName() const;
    QString themePath() const;
    QString themeType() const;

    int buttonHeight() const;
    int buttonWidth() const;
    int buttonSpacing() const;
    int duration() const;

    float buttonRatio() const;

    QColor titleBackgroundColor() const;

    bool hasRestoreButton() const;

    bool hasMonochromeIcons() const;
    QString monochromePrefix() const;

  signals:
    void settingsChanged();
    void themeChanged();

  private slots:
    void parseThemeImages();
    void auroraeRCChanged(const QString &filename);

  private:
    void loadSettings();
    void updateAurorae(const QString &themeName);

  private:
    bool m_hasMonochromeIcons{ false };
    bool m_hasRestoreButton{ false };

    int m_buttonHeight{ 24 };
    int m_buttonWidth{ 24 };
    int m_buttonSpacing{ 2 };
    int m_duration{ 0 };

    Types::ButtonSize m_buttonSize{ Types::NormalButton }; // Normal size

    QString m_theme;
    QString m_themeName;
    QString m_themePath;
    QString m_themeType;

    QString m_monochromePrefix;

    QColor m_titleBackgroundColor;
};

#endif
