import QtQuick
import QtQuick.Layouts
import HuskarUI.Basic

Rectangle {
    id: control

    property bool animationEnabled: HusTheme.animationEnabled
    property bool borderVisible: true
    property string titleText: ''
    property font titleFont: Qt.font({
        family: HusTheme.HusCard.fontFamily,
        pixelSize: HusTheme.HusCard.fontSizeTitle,
        weight: Font.DemiBold,
    })
    property var coverSource: ''
    property int coverFillMode: Image.Stretch
    property int coverHeight: 180
    property int bodyAvatarSize: 40
    property var bodyAvatarIcon: 0 ?? ''
    property var bodyAvatarSource: ''
    property string bodyAvatarText: ''
    property string bodyTitleText: ''
    property font bodyTitleFont: Qt.font({
        family: HusTheme.HusCard.fontFamily,
        pixelSize: HusTheme.HusCard.fontSizeBodyTitle,
        weight: Font.DemiBold,
    })
    property string bodyDescription: ''
    property font bodyDescriptionFont: Qt.font({
        family: HusTheme.HusCard.fontFamily,
        pixelSize: HusTheme.HusCard.fontSizeBodyDescription,
    })
    property color colorTitle: HusTheme.HusCard.colorTitle
    property color colorBodyAvatar: HusTheme.HusCard.colorBodyAvatar
    property color colorBodyAvatarBg: 'transparent'
    property color colorBodyTitle: HusTheme.HusCard.colorBodyTitle
    property color colorBodyDescription: HusTheme.HusCard.colorBodyDescription

    property Component titleDelegate: Item {
        height: 60

        RowLayout {
            anchors.fill: parent
            anchors.topMargin: 5
            anchors.bottomMargin: 5
            anchors.leftMargin: 15
            anchors.rightMargin: 15

            HusText {
                Layout.fillWidth: true
                Layout.fillHeight: true
                text: control.titleText
                font: control.titleFont
                color: control.colorTitle
                wrapMode: Text.WrapAnywhere
                verticalAlignment: Text.AlignVCenter
            }

            Loader {
                Layout.alignment: Qt.AlignVCenter
                sourceComponent: extraDelegate
            }
        }

        HusDivider {
            width: parent.width;
            height: 1
            anchors.bottom: parent.bottom
            visible: (typeof control.coverSource == 'string' && control.coverSource !== '') || (typeof control.coverSource == 'object' && control.coverSource.toString() !== '')
        }
    }
    property Component extraDelegate: Item { }
    property Component coverDelegate: Image {
        height: !visible ? 0 : control.coverHeight
        fillMode: control.coverFillMode
        source: control.coverSource
        visible: (typeof control.coverSource == 'string' && control.coverSource !== '') || (typeof control.coverSource == 'object' && control.coverSource.toString() !== '')
    }
    property Component bodyDelegate: Item {
        height: 100

        RowLayout {
            anchors.fill: parent

            Item {
                Layout.preferredWidth: __avatar.visible ? 70 : 0
                Layout.fillHeight: true

                HusAvatar {
                    id: __avatar
                    size: control.bodyAvatarSize
                    anchors.centerIn: parent
                    colorBg: control.colorBodyAvatarBg
                    iconSource: control.bodyAvatarIcon
                    imageSource: control.bodyAvatarSource
                    textSource: control.bodyAvatarText
                    colorIcon: control.colorBodyAvatar
                    colorText: control.colorBodyAvatar
                    // visible: !(iconSource == 0 && imageSource == '' && textSource == '')
                    visible: (iconSource !== 0 && iconSource !== '') || ((typeof imageSource == 'string' && imageSource !== '') || (typeof imageSource == 'object' && imageSource.toString() !== '')) || textSource !== ''
                }
            }

            ColumnLayout {
                Layout.fillWidth: true
                Layout.fillHeight: true

                HusText {
                    Layout.fillWidth: true
                    leftPadding: __avatar.visible ? 0 : 15
                    rightPadding: 15
                    text: control.bodyTitleText
                    font: control.bodyTitleFont
                    color: control.colorBodyTitle
                    wrapMode: Text.WrapAnywhere
                    visible: control.bodyTitleText !== ''
                }

                HusText {
                    Layout.fillWidth: true
                    leftPadding: __avatar.visible ? 0 : 15
                    rightPadding: 15
                    text: control.bodyDescription
                    font: control.bodyDescriptionFont
                    color: control.colorBodyDescription
                    wrapMode: Text.WrapAnywhere
                    visible: control.bodyDescription !== ''
                }
            }
        }
    }
    property Component actionDelegate: Item { }

    objectName: '__HusCard__'
    width: 300
    height: __column.height
    color: HusTheme.HusCard.colorBg
    border.color: HusTheme.isDark ? HusTheme.HusCard.colorBorderDark : HusTheme.HusCard.colorBorder
    border.width: !control.borderVisible ? 0 : 1
    radius: HusTheme.HusCard.radiusBg
    clip: true

    Behavior on color { enabled: control.animationEnabled; ColorAnimation { duration: HusTheme.Primary.durationMid } }

    Column {
        id: __column
        width: parent.width

        Loader {
            width: parent.width
            sourceComponent: titleDelegate
        }
        Loader {
            width: parent.width - control.border.width * 2
            anchors.horizontalCenter: parent.horizontalCenter
            sourceComponent: coverDelegate
        }
        Loader {
            width: parent.width
            sourceComponent: bodyDelegate
        }
        Loader {
            width: parent.width
            sourceComponent: actionDelegate
        }
    }
}
