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

Item{
    id: rectangleItem

    property bool isActive: indicator.isActive || (indicator.isWindow && indicator.hasActive)
    property bool showProgress: false

    //Rectangle {
        //anchors.fill: parent
        //radius: backRect.radius
        //color: indicator.iconBackgroundColor
        //visible: isActive
        //opacity: 0.65
    //}

    Loader { // progress bar design loader
        anchors.fill: parent
        asynchronous: true
        active: indicator.configuration.progressAnimationEnabled && rectangleItem.showProgress && indicator.progress > 0
        sourceComponent: LoadingLayer {
            progress: Math.min(indicator.progress, 100) / 100
            radius: backRect.radius * 2
        }
    }

    Rectangle { // this boy right here shows inactivity
        id: backRect
        anchors.fill: parent
        radius: indicator.currentIconSize / 16
        color: "#10fcfcfc";
        clip: true
    }

    HighlightGradient { // show user pointer with launched applications
        clip: true
        z: 1
    }

    Rectangle {
        anchors.fill: parent
        radius: 4
        color: "transparent"
        clip: true

        StatusGradient {}
    }

      Rectangle {
        id: borderRectangle
        anchors.fill: parent
        color: "transparent"
        border.width: 1
        border.color: theme.backgroundColor
        radius: backRect.radius
        clip: true

        Rectangle {
            anchors.fill: parent
            anchors.margins: parent.border.width
            radius: backRect.radius
            color: "transparent"
            border.width: 1
            border.color: Qt.rgba(theme.textColor.r,theme.textColor.g,theme.textColor.b, isMinimized ? 0.15 : 0.35)
        }
        z: 1
    }


}
