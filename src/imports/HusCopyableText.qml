import QtQuick
import HuskarUI.Basic

TextEdit {
    id: control

    property bool copyable: true

    objectName: '__HusCopyableText__'
    readOnly: true
    renderType: HusTheme.textRenderType
    color: HusTheme.HusCopyableText.colorText
    selectByMouse: control.copyable
    selectByKeyboard: control.copyable
    selectedTextColor: HusTheme.HusCopyableText.colorTextSelected
    selectionColor: HusTheme.HusCopyableText.colorSelection
    font {
        family: HusTheme.HusCopyableText.fontFamily
        pixelSize: HusTheme.HusCopyableText.fontSize
    }
}
