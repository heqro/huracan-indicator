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
        id: mainRect
        anchors.fill: parent
        color: 'transparent'
        radius: parent.radius

        Rectangle {

            id: loadingRect
            width: progress * parent.width
            height: parent.height
            color: loadingColor
            radius: parent.radius
            clip: true

            Behavior on width {
                SmoothedAnimation {
                    duration: 200
                    //velocity: 2
                }
            }

            RadialGradient {
                id: loadingGlow
                width: mainRect.width * 4
                height: mainRect.height * 4

                gradient: Gradient {
                    GradientStop { position: 0.0; color: Qt.lighter(loadingColor, 1.5) }
                    GradientStop { position: 0.2; color: loadingColor }
                    GradientStop { position: 0.3; color: Qt.darker(loadingColor, 1.5) }
                }


                x: -mainRect.width * 1.5
                y: -mainRect.height * 1.8

                horizontalRadius: width
                verticalRadius: height / 2

            }

            NumberAnimation {
                id: highlightGlowAnimationFront
                target: loadingGlow
                property: 'x'
                duration: 1800
                from: -mainRect.width * 2
                to: -mainRect.width
                easing.type: Easing.InOutQuad
            }

            NumberAnimation {
                id: highlightGlowAnimationBack
                target: loadingGlow
                property: 'x'
                duration: 1800
                from: -mainRect.width
                to: -mainRect.width * 2
                easing.type: Easing.InOutQuad
            }

            Timer {

                interval: 2000
                repeat: true
                running: true

                property bool tick: true

                onTriggered: {
                    if (tick)
                        highlightGlowAnimationFront.restart()
                    else
                        highlightGlowAnimationBack.restart()
                    tick = !tick
                }
            }

        }


    }
}
