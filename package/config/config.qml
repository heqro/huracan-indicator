

import QtQuick 2.7
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.0

import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0 as PlasmaComponents
import org.kde.plasma.components 3.0 as PlasmaComponents3
import org.kde.plasma.plasmoid 2.0

import org.kde.latte.components 1.0 as LatteComponents

ColumnLayout {
    Layout.fillWidth: true

    readonly property bool deprecatedPropertiesAreHidden: true/*dialog && dialog.hasOwnProperty("deprecatedOptionsAreHidden") && dialog.deprecatedOptionsAreHidden*/

    LatteComponents.SubHeader {
        text: i18n("Appearance")
    }

    ColumnLayout {
        spacing: 0

        RowLayout {
            Layout.fillWidth: true
            spacing: units.smallSpacing
            visible: deprecatedPropertiesAreHidden

            PlasmaComponents.Label {
                text: i18n("Tasks Length")
                horizontalAlignment: Text.AlignLeft
            }

            LatteComponents.Slider {
                id: lengthIntMarginSlider
                Layout.fillWidth: true

                value: Math.round(indicator.configuration.lengthPadding * 100)
                from: 25
                to: maxMargin
                stepSize: 1
                wheelEnabled: false

                readonly property int maxMargin: 80

                onPressedChanged: {
                    if (!pressed) {
                        indicator.configuration.lengthPadding = value / 100;
                    }
                }
            }

            PlasmaComponents.Label {
                text: i18nc("number in percentage, e.g. 85 %","%0 %").arg(currentValue)
                horizontalAlignment: Text.AlignRight
                Layout.minimumWidth: theme.mSize(theme.defaultFont).width * 4
                Layout.maximumWidth: theme.mSize(theme.defaultFont).width * 4

                readonly property int currentValue: lengthIntMarginSlider.value
            }
        }

        RowLayout {
            Layout.fillWidth: true
            spacing: 2

            PlasmaComponents.Label {
                Layout.minimumWidth: implicitWidth
                horizontalAlignment: Text.AlignLeft
                Layout.rightMargin: units.smallSpacing
                text: i18n("Applets Length")
            }

            LatteComponents.Slider {
                id: appletPaddingSlider
                Layout.fillWidth: true

                leftPadding: 0
                value: indicator.configuration.appletPadding * 100
                from: 0
                to: 80
                stepSize: 5
                wheelEnabled: false

                function updateMargin() {
                    if (!pressed) {
                        indicator.configuration.appletPadding = value/100;
                    }
                }

                onPressedChanged: {
                    updateMargin();
                }

                Component.onCompleted: {
                    valueChanged.connect(updateMargin);
                }

                Component.onDestruction: {
                    valueChanged.disconnect(updateMargin);
                }
            }

            PlasmaComponents.Label {
                text: i18nc("number in percentage, e.g. 85 %","%0 %").arg(appletPaddingSlider.value)
                horizontalAlignment: Text.AlignRight
                Layout.minimumWidth: theme.mSize(theme.defaultFont).width * 4
                Layout.maximumWidth: theme.mSize(theme.defaultFont).width * 4
            }
        }
    }


    LatteComponents.SubHeader {
        text: i18n("Options")
    }

    LatteComponents.CheckBoxesColumn {
        Layout.fillWidth: true

        LatteComponents.CheckBox {
            Layout.maximumWidth: dialog.optionsWidth
            text: i18n("Progress animation in background")
            checked: indicator.configuration.progressAnimationEnabled

            onClicked: {
                indicator.configuration.progressAnimationEnabled = !indicator.configuration.progressAnimationEnabled
            }
        }
    }

    LatteComponents.CheckBox {
        Layout.maximumWidth: dialog.optionsWidth
        text: i18n("Show indicators for applets")
        checked: indicator.configuration.enabledForApplets
        tooltip: i18n("Indicators are shown for applets")
        visible: deprecatedPropertiesAreHidden

        onClicked: {
            indicator.configuration.enabledForApplets = !indicator.configuration.enabledForApplets;
        }
    }

    LatteComponents.SubHeader {
        text: i18n("Indicators")
    }

    LatteComponents.CheckBox {
        Layout.maximumWidth: dialog.optionsWidth
        text: i18n("Use applications' colors for background")
        checked: indicator.configuration.useAppsColors
        tooltip: i18n("If the app is active, its background will be painted with its predominant icon color")

        onClicked: {
            indicator.configuration.useAppsColors = !indicator.configuration.useAppsColors;
        }
    }
}
