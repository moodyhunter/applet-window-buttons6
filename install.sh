# SPDX-FileCopyrightText: 2018 Michail Vourlakos <mvourlakos@gmail.com>
# SPDX-License-Identifier: GPL-2.0-or-later
*/
if ! [ -a build ] ; then
    mkdir build
fi
cd build
cmake -DCMAKE_INSTALL_PREFIX=/usr -DCMAKE_BUILD_TYPE=Release -Wnodev ..
make -j$(nproc)
sudo make install
