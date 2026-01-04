import QtQuick
import QtQuick.Shapes
import HuskarUI.Basic

Item {
    id: control

    enum TitlePosition {
        PositionTop = 0,
        PositionBottom = 1
    }

    enum TitleAlign {
        AlignLeft = 0,
        AlignCenter = 1,
        AlignRight = 2
    }

    property bool animationEnabled: HusTheme.animationEnabled
    property bool titleVisible: true
    property string titleText: ''
    property font titleFont: Qt.font({
        family: HusTheme.HusGroupBox.fontFamily,
        pixelSize: HusTheme.HusGroupBox.fontSize
    })
    property int titlePosition: HusGroupBox.PositionTop
    property int titleAlign: HusGroupBox.AlignLeft
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
    property HusRadius radiusBg: HusRadius { all: HusTheme.HusGroupBox.radiusBg }
    property string ariaConstrual: titleText

    property Component titleDelegate: HusText {
        text: control.titleText
        font: control.titleFont
        color: control.colorTitle
        leftPadding: control.titleLeftPadding
        rightPadding: control.titleRightPadding
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
            y: (control.titlePosition === HusGroupBox.PositionTop) ? -1 : control.height - 1
            width: __titleLoader.implicitWidth + 8
            height: control.borderWidth + 1
            color: control.colorBg
            visible: !!control.titleText
        }
    }

    default property alias content: __contentItem.data

    objectName: '__HusGroupBox__'
    implicitWidth: Math.max(1, __contentItem.implicitWidth + control.contentLeftMargin + control.contentRightMargin)
    implicitHeight: {
        let height = __contentItem.implicitHeight + (control.contentTopMargin + control.contentBottomMargin) * 2 / 3;
        if (!!control.titleText && __titleLoader.item) {
            height += __titleLoader.item.implicitHeight / 2;
        }
        return Math.max(1, height);
    }

    Behavior on colorTitle { enabled: control.animationEnabled; ColorAnimation { duration: HusTheme.Primary.durationFast } }
    Behavior on colorBorder { enabled: control.animationEnabled; ColorAnimation { duration: HusTheme.Primary.durationFast } }
    Behavior on colorBg { enabled: control.animationEnabled; ColorAnimation { duration: HusTheme.Primary.durationFast } }

    Loader {
        id: __borderLoader
        anchors.fill: parent
        sourceComponent: borderDelegate
    }

    Loader {
        id: __titleLoader
        z: 1
        x: {
            if (control.titleAlign === HusGroupBox.AlignLeft) {
                return control.titlePadding;
            } else if (control.titleAlign === HusGroupBox.AlignRight) {
                return control.width - (__titleLoader.item ? __titleLoader.item.implicitWidth : 0) - control.titlePadding;
            }
            return (control.width - (__titleLoader.item ? __titleLoader.item.implicitWidth : 0)) / 2;
        }
        y: {
            if (control.titlePosition === HusGroupBox.PositionTop) {
                return -(__titleLoader.item ? __titleLoader.item.implicitHeight : 0) / 2;
            } else if (control.titlePosition === HusGroupBox.PositionBottom) {
                return control.height - (__titleLoader.item ? __titleLoader.item.implicitHeight : 0) / 2;
            }
            return 0;
        }
        sourceComponent: control.titleDelegate
        active: control.titleVisible
        visible: active
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

    Accessible.role: Accessible.Grouping
    Accessible.name: control.titleText
    Accessible.description: control.ariaConstrual
}
