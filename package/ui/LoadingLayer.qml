/*
*  Copyright 2019  Michail Vourlakos <mvourlakos@gmail.com>
*  Copyright 2022  Héctor Iglesias <heqromancer@gmail.com>
*
*  This file is part of Latte-Dock
*
*  Latte-Dock is free software; you can redistribute it and/or
*  modify it under the terms of the GNU General Public License as
*  published by the Free Software Foundation; either version 2 of
*  the License, or (at your option) any later version.
*
*  Latte-Dock is distributed in the hope that it will be useful,
*  but WITHOUT ANY WARRANTY; without even the implied warranty of
*  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
*  GNU General Public License for more details.
*
*  You should have received a copy of the GNU General Public License
*  along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

import QtQuick 2.0
import QtGraphicalEffects 1.0

import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.core 2.0 as PlasmaCore

Item {

    readonly property color loadingColor: theme.positiveTextColor
    required property real progress
    required property int radius

    Rectangle {
        width: progress * parent.width
        height: parent.height
        color: loadingColor
        radius: parent.radius

        Rectangle {
            width: parent.width
            height: parent.height / 4
            radius: parent.radius
            color: Qt.lighter(loadingColor, 1.5)
        }


    }
}
