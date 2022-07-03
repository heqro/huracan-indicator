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

    NumberAnimation {
        id: xAnimation
        target: radialGradient
        property: 'x'
        from: radialGradient.x
        to: -radialGradient.width/2
        easing.type: Easing.InOutQuad
    }

    NumberAnimation {
        id: yAnimation
        target: radialGradient
        property: 'y'
        from: radialGradient.y
        to: -radialGradient.height/2
        easing.type: Easing.InOutQuad
    }

    onExited: {
        if (!isMinimized) {
            xAnimation.start()
            yAnimation.start()
        }
    }

    onEntered: {
        initGradientX.when = false
        initGradientY.when = false
    }

    RadialGradient {
        id: radialGradient
        // trick to center gradient inside cursor
        Binding {
            target: radialGradient
            property: 'x'
            when: locator.containsMouse
            value: mouseX - radialGradient.width / 2
        }

        Binding {
            target: radialGradient
            property: 'y'
            when: locator.containsMouse
            value: mouseY - radialGradient.height / 2
        }

        Binding { // dummy binding to properly initialize highlighting
            id: initGradientX
            target: radialGradient
            property: 'x'
            when: !locator.containsMouse
            value: -radialGradient.width / 2
        }

        Binding { // dummy binding to properly initialize highlighting
            id: initGradientY
            target: radialGradient
            property: 'y'
            when: !locator.containsMouse
            value: -radialGradient.height / 2
        }

        width: parent.width * 2
        height: parent.height * 2
        opacity: locator.containsMouse ? 0.85 : indicator.isMinimized ? 0.05 : 0.60
        Behavior on opacity {
            NumberAnimation {
                id: opacityTransition
                duration: locator.containsMouse ? 400 : 150
                easing.type: Easing.InOutQuad
            }
        }

        gradient: Gradient {
            GradientStop { position: 0.0; color: "#ccfcfcfc"}
            GradientStop { position: 0.05; color: "#bbfcfcfc"}
            GradientStop { position: 0.2; color: "#55fcfcfc"}
            GradientStop { position: 0.48; color: "transparent" }
        }

        horizontalRadius: moving ? 1.5 * (2.2*centerY + Math.sqrt(diffX * diffX + diffY * diffY)/2) : height * 3
        verticalRadius:   moving ? 1.5 * (2.2*centerX + Math.sqrt(diffX * diffX + diffY * diffY)/2) : width * 3

        states: [
            State {
                name: "top"
                when: !indicator.configuration.glowReversed

                AnchorChanges {
                    target: glowGradient
                    anchors{horizontalCenter:parent.horizontalCenter; verticalCenter:parent.top}
                }
            },
            State {
                name: "bottom"
                when: indicator.configuration.glowReversed

                AnchorChanges {
                    target: glowGradient
                    anchors{horizontalCenter:parent.horizontalCenter; verticalCenter:parent.bottom}
                }
            }
        ]
    }

    Item {
        id: gradientMask
        anchors.fill: glowGradient

        Rectangle {
            id: glowMaskRect
            anchors.top: parent.verticalCenter
            anchors.left: parent.horizontalCenter
            width: root.width
            height: root.height
            radius: backRect.radius
        }

        visible: false
    }

    Rectangle {
        anchors.fill: parent
        radius: 4
        color: "transparent"
        clip: true

        OpacityMask {
            anchors.horizontalCenter: parent.left
            anchors.verticalCenter: parent.top
            width: glowGradient.width
            height: glowGradient.height

            source: glowGradient
            maskSource: gradientMask
            visible: backRect.visible || borderRectangle.visible
            opacity: indicator.isHovered ? indicator.configuration.glowOpacity + 0.2 : indicator.configuration.glowOpacity
        }
    }
}

