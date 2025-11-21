import QtQuick
import HuskarUI.Basic
import '/HuskarUI/resources/js/qrcode-svg.min.js' as QRCodeSvg

Item {
    id: control

    enum EccLevel
    {
        ECC_LEVEL_L = 0,
        ECC_LEVEL_M = 1,
        ECC_LEVEL_Q = 2,
        ECC_LEVEL_H = 3
    }

    property string content
    property string container: 'svg'
    property color colorBackground: HusTheme.HusQRCode.colorBackground
    property color colorForeground: HusTheme.HusQRCode.colorForeground
    property int eccLevel: HusQRCode.ECC_LEVEL_L
    property bool join: false
    property int padding: 2
    property bool predefined: false
    property bool pretty: true
    property bool swap: false
    property bool xmlDeclaration: true
    property int rawWidth: 500
    property int rawHeight: 500

    readonly property string rawSource: !__private.svgString ? '' : ('data:image/svg+xml;utf8,' + __private.svgString)

    objectName: '__HusQrCode__'
    implicitWidth: 256
    implicitHeight: 256

    onContentChanged: {
        createSvgString();
    }

    Component.onCompleted: {
        createSvgString();
    }

    QtObject {
        id: __private
        property string svgString: ''
    }

    Image {
        width: control.width ?? control.implicitWidth
        height: control.height ?? control.implicitHeight
        anchors.centerIn: parent
        source: control.rawSource
    }

    function createSvgString() {
        if (!control.content) {
            __private.svgString = '';
            return;
        }
        let levelStr;
        switch (control.eccLevel) {
            case HusQRCode.ECC_LEVEL_M:
                levelStr = 'M';
                break;
            case HusQRCode.ECC_LEVEL_Q:
                levelStr = 'Q';
                break;
            case HusQRCode.ECC_LEVEL_H:
                levelStr = 'H';
                break;
            default:
                levelStr = 'L';
                break;
        }
        __private.svgString = new QRCodeSvg.QRCode({
            content: control.content,
            container: control.container,
            width: control.rawWidth > 0 ? control.rawWidth : control.implicitWidth,
            height: control.rawHeight > 0 ? control.rawHeight : control.implicitHeight,
            background: control.colorBackground,
            color: control.colorForeground,
            ecl: levelStr,
            join: control.join,
            padding: control.padding,
            predefined: control.predefined,
            pretty: control.pretty,
            swap: control.swap,
            xmlDeclaration: control.xmlDeclaration
        }).svg();
    }
}
