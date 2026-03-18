#!/usr/bin/env bash
# SPDX-FileCopyrightText: 2018 Michail Vourlakos <mvourlakos@gmail.com>
# SPDX-FileCopyrightText: 2026 Christian Tallner <chrtall@gmx.de>
# SPDX-License-Identifier: GPL-2.0-or-later
cmake -G Ninja -S . -B build -DCMAKE_INSTALL_PREFIX=/usr -DCMAKE_BUILD_TYPE=Release -Wnodev
ninja -C build
sudo ninja -C build install
