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

MouseArea {
    id: locator
    anchors.fill: parent
    hoverEnabled: true
    acceptedButtons: Qt.NoButton

    readonly property int animationsDuration: 250

    onEntered: {
        decreaseOpacity.stop()
        increaseOpacity.restart()
    }

    onExited: {
        increaseOpacity.stop()
        decreaseOpacity.restart()
    }

    NumberAnimation {
        id: increaseOpacity
        target: rGradient
        property: 'opacity'
        duration: animationsDuration + 300
        from: 0.05
        to: 1
        easing.type: Easing.InOutQuad
    }

    NumberAnimation {
        id: decreaseOpacity
        target: rGradient
        property: 'opacity'
        duration: animationsDuration
        from: 1
        to: 0.05
        easing.type: Easing.InOutQuad
    }

    RadialGradient {
        id: rGradient
        height: parent.height * 2
        width: parent.width * 2
        opacity: 0 // initial binding (will break as soon as we launch animations)

        gradient: Gradient {
            GradientStop { position: 0.0; color: "#ccfcfcfc"}
            GradientStop { position: 0.05; color: "#bbfcfcfc"}
            GradientStop { position: 0.2; color: "#55fcfcfc"}
            GradientStop { position: 0.3; color: "transparent" }
        }

        states: [
            State {
                name: "left"
                when: (plasmoid.location === PlasmaCore.Types.LeftEdge)

                AnchorChanges {
                    target: rGradient
                    anchors{ top:undefined; bottom:undefined; left:undefined; right:parent.right;
                        horizontalCenter: undefined; verticalCenter: parent.verticalCenter}
                }

                PropertyChanges {
                    target: rGradient
                    verticalRadius: width
                    horizontalRadius: height / 6
                }
            },
            State {
                name: "right"
                when: (plasmoid.location === PlasmaCore.Types.RightEdge)

                AnchorChanges {
                    target: rGradient
                    anchors{ top:undefined; bottom:undefined; left:parent.left; right:undefined;
                        horizontalCenter: undefined; verticalCenter: parent.verticalCenter}
                }

                PropertyChanges {
                    target: rGradient
                    verticalRadius: width
                    horizontalRadius: height / 6
                }

            },
            State {
                name: "bottom"
                when: (plasmoid.location === PlasmaCore.Types.BottomEdge)

                AnchorChanges {
                    target: rGradient
                    anchors{ top:parent.top; bottom:undefined; left:undefined; right:undefined;
                        horizontalCenter: parent.horizontalCenter; verticalCenter: undefined}
                }

                PropertyChanges {
                    target: rGradient
                    horizontalRadius: height
                    verticalRadius: width / 6
                }
            },
            State {
                name: "top"
                when: (plasmoid.location === PlasmaCore.Types.TopEdge)

                AnchorChanges {
                    target: rGradient
                    anchors{ top:undefined; bottom:parent.bottom; left:undefined; right:undefined;
                        horizontalCenter: parent.horizontalCenter; verticalCenter: undefined}
                }

                PropertyChanges {
                    target: rGradient
                    horizontalRadius: height
                    verticalRadius: width / 6
                }
            }
        ]
    }

}
