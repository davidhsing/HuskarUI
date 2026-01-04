import QtQuick
import QtQuick.Shapes
import HuskarUI.Basic

Item {
    id: control

    enum AlignType {
        AlignLeft = 0,
        AlignCenter = 1,
        AlignRight = 2
    }

    enum LineStyle {
        LineSolid = 0,
        LineDashed = 1
    }

    property bool animationEnabled: HusTheme.animationEnabled
    property bool titleVisible: !!control.titleText
    property string titleText: ''
    property font titleFont: Qt.font({
        family: themeSource.fontFamily,
        pixelSize: parseInt(themeSource.fontSize)
    })
    property int titleAlign: HusDivider.AlignLeft
    property int titlePadding: 20
    property int lineStyle: HusDivider.LineSolid
    property real lineWidth: 1
    property list<real> dashPattern: [4, 2]
    property int orientation: Qt.Horizontal
    property color colorText: themeSource.colorText
    property color colorSplit: themeSource.colorSplit
    property var themeSource: HusTheme.HusDivider

    property Component titleDelegate: HusText {
        text: {
            if (control.orientation === Qt.Horizontal) {
                return control.titleText;
            }
            return !control.titleText ? '' : control.titleText.split('').join('\n');
        }
        font: control.titleFont
        color: control.colorText
    }
    property Component splitDelegate: Shape {
        id: __shape

        property real lineX: __titleLoader.x + __titleLoader.implicitWidth / 2
        property real lineY: __titleLoader.y + __titleLoader.implicitHeight / 2

        ShapePath {
            strokeStyle: control.lineStyle === HusDivider.LineSolid ? ShapePath.SolidLine : ShapePath.DashLine
            strokeColor: control.colorSplit
            strokeWidth: control.lineWidth
            dashPattern: control.dashPattern
            fillColor: 'transparent'
            startX: control.orientation === Qt.Horizontal ? 0 : __shape.lineX
            startY: control.orientation === Qt.Horizontal ? __shape.lineY : 0

            PathLine {
                x: {
                    if (control.orientation === Qt.Horizontal) {
                        return control.titleText === '' ? 0 : __titleLoader.x - 10;
                    } else {
                        return __shape.lineX;
                    }
                }
                y: control.orientation === Qt.Horizontal ? __shape.lineY : __titleLoader.y - 10
            }
        }

        ShapePath {
            strokeStyle: control.lineStyle === HusDivider.LineSolid ? ShapePath.SolidLine : ShapePath.DashLine
            strokeColor: control.colorSplit
            strokeWidth: control.lineWidth
            dashPattern: control.dashPattern
            fillColor: 'transparent'
            startX: {
                if (control.orientation === Qt.Horizontal) {
                    return control.titleText === '' ? 0 : (__titleLoader.x + __titleLoader.implicitWidth + 10);
                } else {
                    return __shape.lineX;
                }
            }
            startY: {
                if (control.orientation === Qt.Horizontal) {
                    return __shape.lineY;
                } else {
                    return control.titleText === '' ? 0 : (__titleLoader.y + __titleLoader.implicitHeight + 10);
                }
            }

            PathLine {
                x: control.orientation === Qt.Horizontal ?  control.width : __shape.lineX
                y: control.orientation === Qt.Horizontal ? __shape.lineY : control.height
            }
        }
    }
    property string ariaConstrual: titleText

    objectName: '__HusDivider__'

    Behavior on colorSplit { enabled: control.animationEnabled; ColorAnimation { duration: HusTheme.Primary.durationFast } }
    Behavior on colorText { enabled: control.animationEnabled; ColorAnimation { duration: HusTheme.Primary.durationFast } }

    Loader {
        id: __splitLoader
        sourceComponent: control.splitDelegate
    }

    Loader {
        id: __titleLoader
        z: 1
        anchors.top: (control.orientation !== Qt.Horizontal && control.titleAlign === HusDivider.AlignLeft) ? parent.top : undefined
        anchors.topMargin: (control.orientation !== Qt.Horizontal && control.titleAlign === HusDivider.AlignLeft) ? control.titlePadding : 0
        anchors.bottom: (control.orientation !== Qt.Horizontal && control.titleAlign === HusDivider.AlignRight) ? parent.right : undefined
        anchors.bottomMargin: (control.orientation !== Qt.Horizontal && control.titleAlign === HusDivider.AlignRight) ? control.titlePadding : 0
        anchors.left: (control.orientation === Qt.Horizontal && control.titleAlign === HusDivider.AlignLeft) ? parent.left : undefined
        anchors.leftMargin: (control.orientation === Qt.Horizontal && control.titleAlign === HusDivider.AlignLeft) ? control.titlePadding : 0
        anchors.right: (control.orientation === Qt.Horizontal && control.titleAlign === HusDivider.AlignRight) ? parent.right : undefined
        anchors.rightMargin: (control.orientation === Qt.Horizontal && control.titleAlign === HusDivider.AlignRight) ? control.titlePadding : 0
        anchors.horizontalCenter: (control.orientation !== Qt.Horizontal || control.titleAlign === HusDivider.AlignCenter) ? parent.horizontalCenter : undefined
        anchors.verticalCenter: (control.orientation === Qt.Horizontal || control.titleAlign === HusDivider.AlignCenter) ? parent.verticalCenter : undefined
        sourceComponent: control.titleDelegate
        active: control.titleVisible
        visible: active
    }

    Accessible.role: Accessible.Separator
    Accessible.name: control.titleText
    Accessible.description: control.ariaConstrual
}
