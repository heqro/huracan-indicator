import QtQuick 2.0
import QtGraphicalEffects 1.0

MouseArea {
    id: locator
    anchors.fill: parent
    hoverEnabled: true

    property bool moving: true

    readonly property int centerX: width / 2
    readonly property int centerY: height / 2

    // arbitrary measure of distance with respect to the center
    readonly property int diffX: Math.abs(mouseX - centerX)
    readonly property int diffY: Math.abs(mouseY - centerY)

    acceptedButtons: Qt.NoButton

    RadialGradient {
        // trick to center gradient inside cursor
        x: moving ? mouseX - width / 2 : 0
        y : moving ? mouseY - height / 2 : 0
        width: parent.width * 2
        height: parent.height * 2
        opacity: moving ? locator.containsMouse * 0.85 : indicator.isMinimized ? 0.05 : 0.60
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
                    if (moving || isActive || !indicator.isMinimized) return indicator.iconBackgroundColor
                    if (indicator.isMinimized && !opacityTransition.running) return theme.textColor
                    else return 'transparent'
                }
            }
            GradientStop { position: 0.45; color: 'transparent'}
        }

        horizontalRadius: moving ? 1.5 * (2.2*centerY + Math.sqrt(diffX * diffX + diffY * diffY)/2) : height * 3
        verticalRadius:   moving ? 1.5 * (2.2*centerX + Math.sqrt(diffX * diffX + diffY * diffY)/2) : width * 3
    }
}

