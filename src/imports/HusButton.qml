import QtQuick
import QtQuick.Templates as T
import HuskarUI.Basic

T.Button {
    id: control

    enum Type {
        TypeDefault = 0,
        TypeOutlined = 1,
        TypePrimary = 2,
        TypeFilled = 3,
        TypeText = 4,
        TypeLink = 5
    }

    enum Shape {
        ShapeDefault = 0,
        ShapeCircle = 1
    }

    property bool animationEnabled: HusTheme.animationEnabled
    property bool danger: false
    property bool effectEnabled: true
    property bool forceState: false
    property int hoverCursorShape: Qt.PointingHandCursor
    property int type: HusButton.TypeDefault
    property int shape: HusButton.ShapeDefault
    property HusRadius radiusBg: HusRadius { all: HusTheme.HusButton.radiusBg }
    property color colorText: {
        if (enabled || control.forceState) {
            if (control.danger) {
                switch(control.type) {
                    case HusButton.TypePrimary: return 'white';
                    case HusButton.TypeFilled:
                    case HusButton.TypeDefault:
                    case HusButton.TypeOutlined:
                    case HusButton.TypeText:
                    case HusButton.TypeLink:
                        return control.down ? HusTheme.HusButton.colorErrorTextActive : (control.hovered ? HusTheme.HusButton.colorErrorTextHover :  HusTheme.HusButton.colorError);
                }
            }
            switch (control.type) {
                case HusButton.TypeDefault:
                    return control.down ? HusTheme.HusButton.colorTextActive : (control.hovered ? HusTheme.HusButton.colorTextHover : HusTheme.HusButton.colorTextDefault);
                case HusButton.TypeOutlined:
                    return control.down ? HusTheme.HusButton.colorTextActive : (control.hovered ? HusTheme.HusButton.colorTextHover : HusTheme.HusButton.colorText);
                case HusButton.TypePrimary:
                    return 'white';
                case HusButton.TypeFilled:
                case HusButton.TypeText:
                case HusButton.TypeLink:
                    return control.down ? HusTheme.HusButton.colorTextActive : (control.hovered ? HusTheme.HusButton.colorTextHover : HusTheme.HusButton.colorText);
                default:
                    return HusTheme.HusButton.colorText;
            }
        }
        return HusTheme.HusButton.colorTextDisabled;
    }
    property color colorBg: {
        if (control.type === HusButton.TypeLink) {
            return 'transparent';
        }
        if (enabled || control.forceState) {
            if (control.danger) {
                switch(control.type) {
                    case HusButton.TypePrimary:
                        return control.down ? HusTheme.HusButton.colorErrorBgActive: (control.hovered ? HusTheme.HusButton.colorErrorBgHover : HusTheme.HusButton.colorErrorBg);
                    case HusButton.TypeFilled:
                        return control.down ? HusTheme.HusButton.colorErrorFillBgActive: (control.hovered ? HusTheme.HusButton.colorErrorFillBgHover : HusTheme.HusButton.colorErrorFillBg);
                    case HusButton.TypeText:
                        return control.down ? HusTheme.HusButton.colorErrorFillBgActive: (control.hovered ? HusTheme.HusButton.colorErrorFillBg : 'transparent');
                    case HusButton.TypeDefault:
                    case HusButton.TypeOutlined:
                        return control.down ? HusTheme.HusButton.colorBgActive: (control.hovered ? HusTheme.HusButton.colorBgHover : HusTheme.HusButton.colorBg);
                    default: return HusTheme.HusButton.colorBg;
                }
            }
            switch (control.type) {
                case HusButton.TypeDefault:
                case HusButton.TypeOutlined:
                    return control.down ? HusTheme.HusButton.colorBgActive : (control.hovered ? HusTheme.HusButton.colorBgHover : HusTheme.HusButton.colorBg);
                case HusButton.TypePrimary:
                    return control.down ? HusTheme.HusButton.colorPrimaryBgActive : (control.hovered ? HusTheme.HusButton.colorPrimaryBgHover : HusTheme.HusButton.colorPrimaryBg);
                case HusButton.TypeFilled:
                    if (HusTheme.isDark) {
                        return control.down ? HusTheme.HusButton.colorFillBgDarkActive : (control.hovered ? HusTheme.HusButton.colorFillBgDarkHover : HusTheme.HusButton.colorFillBgDark);
                    } else {
                        return control.down ? HusTheme.HusButton.colorFillBgActive : (control.hovered ? HusTheme.HusButton.colorFillBgHover : HusTheme.HusButton.colorFillBg);
                    }
                case HusButton.TypeText:
                    if (HusTheme.isDark) {
                        return control.down ? HusTheme.HusButton.colorFillBgDarkActive : (control.hovered ? HusTheme.HusButton.colorFillBgDarkHover : HusTheme.HusButton.colorTextBg);
                    } else {
                        return control.down ? HusTheme.HusButton.colorTextBgActive : (control.hovered ? HusTheme.HusButton.colorTextBgHover : HusTheme.HusButton.colorTextBg);
                    }
                default:
                    return HusTheme.HusButton.colorBg;
            }
        }
        return HusTheme.HusButton.colorBgDisabled;
    }
    property color colorBorder: {
        if (type === HusButton.TypeLink) {
            return 'transparent';
        }
        if (enabled || control.forceState) {
            if (control.danger) {
                switch (control.type) {
                    case HusButton.TypeDefault:
                        return control.down ? HusTheme.HusButton.colorBorderActive : (control.hovered ? HusTheme.HusButton.colorErrorBorderHover : HusTheme.HusButton.colorDefaultBorder);
                    default:
                        return control.down ? HusTheme.HusButton.colorErrorBorderActive: (control.hovered ? HusTheme.HusButton.colorErrorBorderHover : HusTheme.HusButton.colorErrorBorder);
                }
            }
            switch (control.type) {
                case HusButton.TypeDefault:
                    return control.down ? HusTheme.HusButton.colorBorderActive : (control.hovered ? HusTheme.HusButton.colorBorderHover : HusTheme.HusButton.colorDefaultBorder);
                default:
                    return control.down ? HusTheme.HusButton.colorBorderActive : (control.hovered ? HusTheme.HusButton.colorBorderHover : HusTheme.HusButton.colorBorder);
            }
        }
        return HusTheme.HusButton.colorBorderDisabled;
    }
    property string contentDescription: text

    objectName: '__HusButton__'
    implicitWidth: implicitContentWidth + leftPadding + rightPadding
    implicitHeight: implicitContentHeight + topPadding + bottomPadding
    padding: 15
    topPadding: 6
    bottomPadding: 6
    font {
        family: HusTheme.HusButton.fontFamily
        pixelSize: HusTheme.HusButton.fontSize
    }
    contentItem: Text {
        text: control.text
        font: control.font
        lineHeight: HusTheme.HusButton.fontLineHeight
        color: control.colorText
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight

        Behavior on color { enabled: control.animationEnabled; ColorAnimation { duration: HusTheme.Primary.durationFast } }
    }
    background: Item {
        Rectangle {
            id: __effect
            width: __bg.width
            height: __bg.height
            radius: control.shape === HusButton.ShapeCircle ? height / 2 : __bg.radius
            anchors.centerIn: parent
            visible: control.effectEnabled && control.type !== HusButton.TypeLink
            color: 'transparent'
            border.width: 0
            border.color: (control.enabled || control.forceState) ? HusTheme.HusButton.colorBorderHover : 'transparent'
            opacity: 0.2

            ParallelAnimation {
                id: __animation
                onFinished: __effect.border.width = 0;
                NumberAnimation {
                    target: __effect; property: 'width'; from: __bg.width + 3; to: __bg.width + 8;
                    duration: HusTheme.Primary.durationFast
                    easing.type: Easing.OutQuart
                }
                NumberAnimation {
                    target: __effect; property: 'height'; from: __bg.height + 3; to: __bg.height + 8;
                    duration: HusTheme.Primary.durationFast
                    easing.type: Easing.OutQuart
                }
                NumberAnimation {
                    target: __effect; property: 'opacity'; from: 0.2; to: 0;
                    duration: HusTheme.Primary.durationSlow
                }
            }

            Connections {
                target: control
                function onReleased() {
                    if (control.animationEnabled && control.effectEnabled) {
                        __effect.border.width = 8;
                        __animation.restart();
                    }
                }
            }
        }
        HusRectangleInternal {
            id: __bg
            width: realWidth
            height: realHeight
            anchors.centerIn: parent
            radius: control.radiusBg?.all ?? 0
            topLeftRadius: control.shape === HusButton.ShapeDefault ? control.radiusBg?.topLeft ?? 0 : height / 2
            topRightRadius: control.shape === HusButton.ShapeDefault ? control.radiusBg?.topRight ?? 0 : height / 2
            bottomLeftRadius: control.shape === HusButton.ShapeDefault ? control.radiusBg?.bottomLeft ?? 0 : height / 2
            bottomRightRadius: control.shape === HusButton.ShapeDefault ? control.radiusBg?.bottomRight ?? 0 : height / 2
            color: control.colorBg
            border.color: (control.enabled || control.forceState) ? control.colorBorder : (control.type === HusButton.TypeLink ? 'transparent' : HusTheme.HusButton.colorDefaultBorder)
            border.width: (control.type === HusButton.TypeFilled || control.type === HusButton.TypeText) ? 0 : 1

            property real realWidth: control.shape === HusButton.ShapeDefault ? parent.width : parent.height
            property real realHeight: control.shape === HusButton.ShapeDefault ? parent.height : parent.height

            Behavior on color { enabled: control.animationEnabled; ColorAnimation { duration: HusTheme.Primary.durationMid } }
            Behavior on border.color { enabled: control.animationEnabled; ColorAnimation { duration: HusTheme.Primary.durationMid } }
        }
    }

    HoverHandler {
        cursorShape: control.hoverCursorShape
    }

    Accessible.role: Accessible.Button
    Accessible.name: control.text
    Accessible.description: control.contentDescription
    Accessible.onPressAction: control.clicked();
}
