import QtQuick
import QtQuick.Shapes
import HuskarUI.Basic

Item {
    id: control

    enum TitlePosition {
        Position_Top = 0,
        Position_Bottom = 1
    }

    enum TitleAlign {
        Align_Left = 0,
        Align_Center = 1,
        Align_Right = 2
    }

    property bool animationEnabled: HusTheme.animationEnabled
    property string title: ''
    property font titleFont: Qt.font({
        family: HusTheme.HusGroupBox.fontFamily,
        pixelSize: parseInt(HusTheme.HusGroupBox.fontSize)
    })
    property int titlePosition: HusGroupBox.Position_Top
    property int titleAlign: HusGroupBox.Align_Left
    property int titlePadding: 20
    property int titleLeftPadding: 4
    property int titleRightPadding: 4
    property int borderWidth: 1
    property int contentMargins: 16
    property int contentTopMargin: contentMargins
    property int contentBottomMargin: contentMargins
    property int contentLeftMargin: contentMargins
    property int contentRightMargin: contentMargins
    property color colorTitle: HusTheme.HusGroupBox.colorTitle
    property color colorBorder: HusTheme.HusGroupBox.colorBorder
    property color colorBg: HusTheme.HusGroupBox.colorBg
    property HusRadius radiusBg: HusRadius { all: parseInt(HusTheme.HusGroupBox.radiusBg) }
    property string contentDescription: title

    property Component titleDelegate: HusText {
        text: control.title
        font: control.titleFont
        color: control.colorTitle
        leftPadding: control.titleLeftPadding
        rightPadding: control.titleRightPadding
        visible: !!control.title
    }

    property Component borderDelegate: Item {
        // 完整的带圆角边框
        HusRectangle {
            anchors.fill: parent
            color: control.colorBg
            radius: control.radiusBg.all
            topLeftRadius: control.radiusBg.topLeft
            topRightRadius: control.radiusBg.topRight
            bottomLeftRadius: control.radiusBg.bottomLeft
            bottomRightRadius: control.radiusBg.bottomRight
            border.width: control.borderWidth
            border.color: control.colorBorder
            border.style: Qt.SolidLine
        }

        // 标题位置的遮罩
        Rectangle {
            x: __titleLoader.x - 4
            y: (control.titlePosition === HusGroupBox.Position_Top) ? -1 : control.height - 1
            width: __titleLoader.implicitWidth + 8
            height: control.borderWidth + 1
            color: control.colorBg
            visible: !!control.title
        }
    }

    default property alias content: __contentItem.data

    objectName: '__HusGroupBox__'
    implicitWidth: __container.implicitWidth
    implicitHeight: __container.implicitHeight

    Behavior on colorTitle { enabled: control.animationEnabled; ColorAnimation { duration: HusTheme.Primary.durationFast } }
    Behavior on colorBorder { enabled: control.animationEnabled; ColorAnimation { duration: HusTheme.Primary.durationFast } }
    Behavior on colorBg { enabled: control.animationEnabled; ColorAnimation { duration: HusTheme.Primary.durationFast } }

    Item {
        id: __container
        anchors.centerIn: parent
        implicitWidth: Math.max(1, __contentItem.implicitWidth + control.contentLeftMargin + control.contentRightMargin)
        implicitHeight: {
            let height = __contentItem.implicitHeight + (control.contentTopMargin + control.contentBottomMargin) * 2 / 3;
            if (!!control.title) {
                height += (__titleLoader.item ? __titleLoader.item.implicitHeight : 0) / 2;
            }
            return Math.max(1, height);
        }

        width: Math.max(implicitWidth, parent.width)
        height: Math.max(implicitHeight, parent.height)

        Loader {
            id: __borderLoader
            anchors.fill: parent
            sourceComponent: borderDelegate
        }

        Loader {
            id: __titleLoader
            z: 1
            x: {
                if (control.titlePosition === HusGroupBox.Position_Top || control.titlePosition === HusGroupBox.Position_Bottom) {
                    if (control.titleAlign === HusGroupBox.Align_Left) {
                        return control.titlePadding;
                    } else if (control.titleAlign === HusGroupBox.Align_Right) {
                        return __container.width - (__titleLoader.item ? __titleLoader.item.implicitWidth : 0) - control.titlePadding;
                    }
                    return (__container.width - (__titleLoader.item ? __titleLoader.item.implicitWidth : 0)) * 0.5;
                }
                return 0;
            }
            y: {
                if (control.titlePosition === HusGroupBox.Position_Top) {
                    return -(__titleLoader.item ? __titleLoader.item.implicitHeight : 0) * 0.5;
                } else if (control.titlePosition === HusGroupBox.Position_Bottom) {
                    return __container.height - (__titleLoader.item ? __titleLoader.item.implicitHeight : 0) * 0.5;
                }
                return 0;
            }
            sourceComponent: titleDelegate
        }

        Item {
            id: __contentItem
            anchors.fill: parent
            anchors.topMargin: control.contentTopMargin
            anchors.bottomMargin: control.contentBottomMargin
            anchors.leftMargin: control.contentLeftMargin
            anchors.rightMargin: control.contentRightMargin
            implicitWidth: childrenRect.width
            implicitHeight: childrenRect.height
        }
    }

    Accessible.role: Accessible.Grouping
    Accessible.name: control.title
    Accessible.description: control.contentDescription
}
