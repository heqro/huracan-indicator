import QtQuick 2.0
import QtGraphicalEffects 1.0

import org.kde.plasma.core 2.0 as PlasmaCore

MouseArea {
    id: locator
    anchors.fill: parent
    hoverEnabled: true

    readonly property int centerX: width / 2
    readonly property int centerY: height / 2

    // arbitrary measure of distance with respect to the center
    readonly property int diffX: Math.abs(mouseX - centerX)
    readonly property int diffY: Math.abs(mouseY - centerY)

    acceptedButtons: Qt.NoButton

    RadialGradient {
        // trick to center gradient inside cursor
        x: 0
        y : 0
        width: parent.width * 2
        height: parent.height * 2
        opacity: indicator.isMinimized ? 0.05 : 0.60
        Behavior on opacity {
            NumberAnimation {
                id: opacityTransition
                duration: locator.containsMouse ? 400 : 150
                easing.type: Easing.InOutQuad
            }
        }

        gradient: Gradient {
            GradientStop { position: 0.0;
                color: {
                    if (isActive || !indicator.isMinimized)  {
                        if (indicator.configuration.useAppsColors)
                            return indicator.iconBackgroundColor
                        else
                            return theme.highlightColor
                    }
                    if (indicator.isMinimized && !opacityTransition.running) return theme.textColor
                    else return 'transparent'
                }
            }
            GradientStop { position: 0.45; color: 'transparent'}
        }

        horizontalRadius: height * 2
        verticalRadius:   width * 2
    }
}

