import QtQuick
import HuskarUI.Basic

HusRectangle {
    id: control

    property bool animationEnabled: HusTheme.animationEnabled
    property bool closable: false

    objectName: '__HusMaskOverlay__'
    anchors.fill: parent
    color: HusTheme.HusMaskOverlay.colorBg
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
        hoverEnabled: true
        onClicked: {
            if (control.closable) {
                control.visible = false;
            }
            control.clicked();
        }
    }
}
