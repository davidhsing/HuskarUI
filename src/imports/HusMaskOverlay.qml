import QtQuick
import HuskarUI.Basic

HusRectangle {
    id: control

    property bool animationEnabled: HusTheme.animationEnabled
    property bool closable: false
    property color colorBg: HusTheme.HusMaskOverlay.colorBg

    objectName: '__HusMaskOverlay__'
    anchors.fill: parent
    color: control.colorBg
    visible: false

    signal clicked()

    Behavior on opacity {
        enabled: control.animationEnabled
        NumberAnimation {
            duration: HusTheme.Primary.durationMid
            easing.type: Easing.OutQuad
        }
    }

    MouseArea {
        anchors.fill: parent
        onClicked: {
            if (control.closable) {
                control.visible = false;
            }
            control.clicked();
        }
    }
}
