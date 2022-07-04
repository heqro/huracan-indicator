import QtQuick 2.0
import QtGraphicalEffects 1.0

import org.kde.plasma.core 2.0 as PlasmaCore

MouseArea {
    id: locator
    anchors.fill: parent
    hoverEnabled: true
    acceptedButtons: Qt.NoButton

    readonly property int animationsDuration: 250

    Connections {
       target: indicator

       function onIsMinimizedChanged() {
            if (isMinimized) {
                decreaseOpacity.restart()
                increaseOpacity.stop()
            }
            else {
                increaseOpacity.restart()
                decreaseOpacity.stop()
            }
       }
    }

    NumberAnimation {
        id: increaseOpacity
        target: rGradient
        property: 'opacity'
        duration: animationsDuration
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
        // trick to center gradient inside cursor
        x: 0
        y : 0
        width: parent.width * 2
        height: parent.height * 2
        opacity: indicator.isMinimized ? 0.05 : 1 // initial binding (will break as soon as we launch animations)

        gradient: Gradient {
            GradientStop { position: 0.0;
                color: {
                    if (isActive || !indicator.isMinimized)  {
                        if (indicator.configuration.useAppsColors)
                            return indicator.iconBackgroundColor
                        else
                            return theme.highlightColor
                    }
                    if (indicator.isMinimized && !decreaseOpacity.running && !increaseOpacity.running) return theme.textColor
                    else return 'transparent'
                }

                Behavior on color {
                    ColorAnimation { duration: animationsDuration }
                }
            }
            GradientStop { position: 0.45; color: 'transparent'}
        }

        horizontalRadius: height * 2
        verticalRadius:   width * 2
    }
}

