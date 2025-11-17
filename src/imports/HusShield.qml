import QtQuick
import QtQuick.Layouts
import HuskarUI.Basic

Item {
    id: control

    property bool animationEnabled: HusTheme.animationEnabled
    property bool leftEnabled: true
    property bool rightEnabled: true
    property string leftText: ''
    property string rightText: ''
    property font leftFont: Qt.font({
        family: HusTheme.HusShield.leftFontFamily,
        pixelSize: HusTheme.HusShield.leftFontSize
    })
    property font rightFont: Qt.font({
        family: HusTheme.HusShield.rightFontFamily,
        pixelSize: HusTheme.HusShield.rightFontSize
    })
    property color colorLeftBg: HusTheme.HusShield.colorLeftBg
    property color colorLeftText: HusTheme.HusShield.colorLeftText
    property color colorRightBg: HusTheme.HusShield.colorRightBg
    property color colorRightText: HusTheme.HusShield.colorRightText
    property HusRadius radiusBg: HusRadius { all: 4 }

    // Delegate 属性
    property Component leftDelegate: __defaultLeftDelegate
    property Component rightDelegate: __defaultRightDelegate

    objectName: '__HusShield__'
    implicitWidth: __row.width
    implicitHeight: __row.height
    visible: leftEnabled || rightEnabled

    // 默认左侧 delegate
    Component {
        id: __defaultLeftDelegate
        HusText {
            text: control.leftText
            font: control.leftFont
            color: control.colorLeftText

            Behavior on color {
                enabled: control.animationEnabled
                ColorAnimation { duration: HusTheme.Primary.durationMid }
            }
        }
    }

    // 默认右侧 delegate
    Component {
        id: __defaultRightDelegate
        HusText {
            text: control.rightText
            font: control.rightFont
            color: control.colorRightText

            Behavior on color {
                enabled: control.animationEnabled
                ColorAnimation { duration: HusTheme.Primary.durationMid }
            }
        }
    }

    Row {
        id: __row
        spacing: 0

        // 左侧部分
        Loader {
            id: __leftLoader
            active: control.leftEnabled
            sourceComponent: HusRectangleInternal {
                implicitWidth: __leftContent.implicitWidth + 16
                implicitHeight: __leftContent.implicitHeight + 8
                color: control.colorLeftBg
                radius: control.radiusBg.all
                topLeftRadius: control.radiusBg.topLeft
                topRightRadius: control.rightEnabled ? 0 : control.radiusBg.topRight
                bottomLeftRadius: control.radiusBg.bottomLeft
                bottomRightRadius: control.rightEnabled ? 0 : control.radiusBg.bottomRight

                Behavior on color {
                    enabled: control.animationEnabled
                    ColorAnimation { duration: HusTheme.Primary.durationMid }
                }

                Loader {
                    id: __leftContent
                    anchors.centerIn: parent
                    sourceComponent: control.leftDelegate
                }
            }
        }

        // 右侧部分
        Loader {
            id: __rightLoader
            active: control.rightEnabled
            sourceComponent: HusRectangleInternal {
                implicitWidth: __rightContent.implicitWidth + 16
                implicitHeight: __rightContent.implicitHeight + 8
                color: control.colorRightBg
                radius: control.radiusBg.all
                topLeftRadius: control.leftEnabled ? 0 : control.radiusBg.topLeft
                topRightRadius: control.radiusBg.topRight
                bottomLeftRadius: control.leftEnabled ? 0 : control.radiusBg.bottomLeft
                bottomRightRadius: control.radiusBg.bottomRight

                Behavior on color {
                    enabled: control.animationEnabled
                    ColorAnimation { duration: HusTheme.Primary.durationMid }
                }

                Loader {
                    id: __rightContent
                    anchors.centerIn: parent
                    sourceComponent: control.rightDelegate
                }
            }
        }
    }
}
