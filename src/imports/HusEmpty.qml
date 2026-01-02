import QtQuick
import QtQuick.Layouts
import HuskarUI.Basic

Item {
    id: control

    enum ImageStyle {
        ImageNone = 0,
        ImageDefault = 1,
        ImageSimple = 2
    }

    property int imageStyle: HusEmpty.Image_Default
    property string imageSource: {
        switch (imageStyle) {
            case HusEmpty.ImageNone: return '';
            case HusEmpty.ImageDefault: return 'qrc:/HuskarUI/resources/images/empty-default.svg';
            case HusEmpty.ImageSimple: return 'qrc:/HuskarUI/resources/images/empty-simple.svg';
        }
    }
    property int imageWidth: {
        switch (imageStyle) {
            case HusEmpty.ImageNone: return width / 3;
            case HusEmpty.ImageDefault: return 92;
            case HusEmpty.ImageSimple: return 64;
        }
    }
    property int imageHeight: {
        switch (imageStyle) {
            case HusEmpty.ImageNone: return height / 3;
            case HusEmpty.ImageDefault: return 76;
            case HusEmpty.ImageSimple: return 41;
        }
    }
    property bool descriptionVisible: true
    property string descriptionText: ''
    property int descriptionSpacing: 12
    property font descriptionFont: Qt.font({
        family: HusTheme.HusEmpty.fontFamily,
        pixelSize: HusTheme.HusEmpty.fontSize
    })
    property color colorDescription: HusTheme.HusEmpty.colorDescription

    property Component imageDelegate: Image {
        width: control.imageWidth
        height: control.imageHeight
        source: control.imageSource
        sourceSize: Qt.size(width, height)
    }
    property Component descriptionDelegate: HusText {
        text: control.descriptionText
        font: control.descriptionFont
        color: control.colorDescription
        horizontalAlignment: Text.AlignHCenter
    }

    objectName: '__HusEmpty__'
    implicitWidth: 200
    implicitHeight: 200

    ColumnLayout {
        anchors.centerIn: parent
        spacing: control.descriptionSpacing

        Loader {
            Layout.alignment: Qt.AlignHCenter
            Layout.fillWidth: true
            visible: active
            active: control.imageSource !== '' || control.imageType !== HusEmpty.Image_None
            sourceComponent: control.imageDelegate
        }

        Loader {
            Layout.alignment: Qt.AlignHCenter
            Layout.fillWidth: true
            visible: active
            active: control.descriptionVisible
            sourceComponent: control.descriptionDelegate
        }
    }
}
