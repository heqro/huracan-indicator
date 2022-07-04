import QtQuick 2.0
import QtGraphicalEffects 1.0

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


    onContainsMouseChanged: {
        if (!containsMouse) {
           xAnimation.start()
           yAnimation.start()
        }
    }

    NumberAnimation {
        id: xAnimation
        target: radialGradient
        property: 'x'
        from: radialGradient.x
        duration: 500
        to: -radialGradient.width/2
        easing.type: Easing.InOutQuad
    }

    NumberAnimation {
        id: yAnimation
        target: radialGradient
        property: 'y'
        from: radialGradient.y
        duration: 500
        to: -radialGradient.height/2
        easing.type: Easing.InOutQuad
    }



    onExited: {
        if (isActive) {
            xAnimation.start()
            yAnimation.start()
        }
    }

    onEntered: {
        xAnimation.stop()
        yAnimation.stop()
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
            when: true
            value: -radialGradient.width / 2
        }

        Binding { // dummy binding to properly initialize highlighting
            id: initGradientY
            target: radialGradient
            property: 'y'
            when: true
            value: -radialGradient.height / 2
        }

        width: parent.width * 2
        height: parent.height * 2
        opacity: {

            if (!indicator.isActive && !locator.containsMouse) return 0
            if (indicator.isActive) return 0.85

            if (locator.containsMouse) {
                return 0.5
            } else {
                return 0.01
            }
        }

        Behavior on opacity {
            NumberAnimation {
                id: opacityTransition
                duration: 400
                easing.type: Easing.InOutQuad
            }
        }

        gradient: Gradient {
            GradientStop { position: 0.0; color: "#ccfcfcfc"}
            GradientStop { position: 0.05; color: "#bbfcfcfc"}
            GradientStop { position: 0.2; color: "#55fcfcfc"}
            GradientStop { position: 0.48; color: "transparent" }
        }

        horizontalRadius:1.5 * (2.2*centerY + Math.sqrt(diffX * diffX + diffY * diffY)/2)
        verticalRadius:  1.5 * (2.2*centerX + Math.sqrt(diffX * diffX + diffY * diffY)/2)

    }
}

