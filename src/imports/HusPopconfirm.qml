import QtQuick
import QtQuick.Layouts
import QtQuick.Templates as T
import HuskarUI.Basic

HusPopover {
    id: control

    signal confirm()
    signal cancel()

    property string confirmText: ''
    property string cancelText: ''
    property Component confirmButtonDelegate: HusButton {
        animationEnabled: control.animationEnabled
        padding: 10
        topPadding: 4
        bottomPadding: 4
        text: control.confirmText
        type: HusButton.TypePrimary
        onClicked: control.confirm();
    }
    property Component cancelButtonDelegate: HusButton {
        animationEnabled: control.animationEnabled
        padding: 10
        topPadding: 4
        bottomPadding: 4
        text: control.cancelText
        type: HusButton.TypeDefault
        onClicked: control.cancel();
    }

    footerDelegate: Item {
        implicitHeight: __rowLayout.implicitHeight

        RowLayout {
            id: __rowLayout
            anchors.right: parent.right
            spacing: 10
            visible: __confirmLoader.active || __cancelLoader.active

            Loader {
                id: __confirmLoader
                active: control.confirmText !== ''
                visible: active
                sourceComponent: control.confirmButtonDelegate
            }

            Loader {
                id: __cancelLoader
                active: control.cancelText !== ''
                visible: active
                sourceComponent: control.cancelButtonDelegate
            }
        }
    }

    objectName: '__HusPopconfirm__'
    themeSource: HusTheme.HusPopconfirm
}
