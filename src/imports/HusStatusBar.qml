import QtQuick
import QtQuick.Layouts
import HuskarUI.Antd

Item {
    id: control

    enum Horizontal_Align {
        Align_Left = 0,
        Align_Center = 1,
        Align_Right = 2
    }

    property bool animationEnabled: HusTheme.animationEnabled
    property var model: []
    property int defaultFontSize: HusTheme.HusStatusBar.fontSize - 2
    property int defaultLeftMargin: 10
    property int defaultRightMargin: 10
    property int defaultElide: Text.ElideRight
    property color colorBg: HusTheme.HusStatusBar.colorBg
    property color colorDivider: HusTheme.HusStatusBar.colorDivider
    property color defaultColorText: HusTheme.HusStatusBar.colorText
    property int radiusBg: 0
    property string textRole: 'text'
    property string widthRole: 'width'
    property string alignRole: 'align'
    property string colorTextRole: 'colorText'
    property string fontSizeRole: 'fontSize'
    property string leftMarginRole: 'leftMargin'
    property string rightMarginRole: 'rightMargin'
    property string elideRole: 'elide'

    objectName: '__HusStatusBar__'
    implicitWidth: parent.width
    implicitHeight: 26

    Rectangle {
        anchors.fill: parent
        color: control.colorBg
        radius: control.radiusBg

        RowLayout {
            anchors.fill: parent
            anchors.margins: 0
            spacing: 0

            Repeater {
                model: control.model

                Item {
                    id: __item
                    required property var modelData
                    required property int index

                    property int itemWidth: modelData[control.widthRole] ?? 0
                    property int itemAlign: modelData[control.alignRole] ?? HusStatusBar.Align_Left
                    property color itemColorText: modelData[control.colorTextRole] ?? control.defaultColorText
                    property int itemFontSize: modelData[control.fontSizeRole] ?? control.defaultFontSize
                    property int itemLeftMargin: modelData[control.leftMarginRole] ?? control.defaultLeftMargin
                    property int itemRightMargin: modelData[control.rightMarginRole] ?? control.defaultRightMargin
                    property int itemElide: modelData[control.elideRole] ?? control.defaultElide

                    Layout.fillHeight: true
                    Layout.preferredWidth: (itemWidth >= 0) ? itemWidth : 0
                    Layout.fillWidth: itemWidth < 0

                    HusText {
                        anchors.fill: parent
                        anchors.leftMargin: __item.itemLeftMargin
                        anchors.rightMargin: __item.itemRightMargin
                        text: __item.modelData[control.textRole] ?? ''
                        color: __item.itemColorText
                        font.pixelSize: __item.itemFontSize
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: {
                            if (__item.itemAlign === HusStatusBar.Align_Left) {
                                return Text.AlignLeft;
                            }
                            else if (__item.itemAlign === HusStatusBar.Align_Right) {
                                return Text.AlignRight;
                            }
                            else if (__item.itemAlign === HusStatusBar.Align_Center) {
                                return Text.AlignHCenter;
                            }
                            else {
                                return Text.AlignLeft;
                            }
                        }
                        elide: __item.itemElide

                        Behavior on color {
                            enabled: control.animationEnabled
                            ColorAnimation { duration: HusTheme.Primary.durationFast }
                        }
                    }

                    HusDivider {
                        width: 1
                        height: parent.height * 0.6
                        anchors.right: parent.right
                        anchors.verticalCenter: parent.verticalCenter
                        visible: __item.index < control.model.length - 1
                        orientation: Qt.Vertical
                    }
                }
            }
        }
    }

    Behavior on colorBg {
        enabled: control.animationEnabled
        ColorAnimation { duration: HusTheme.Primary.durationFast }
    }
    Behavior on defaultColorText {
        enabled: control.animationEnabled
        ColorAnimation { duration: HusTheme.Primary.durationFast }
    }
}