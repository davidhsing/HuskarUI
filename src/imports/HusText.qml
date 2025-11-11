import QtQuick
import HuskarUI.Antd

Text {
    id: control

    objectName: '__HusText__'
    renderType: HusTheme.textRenderType
    color: HusTheme.Primary.colorTextBase
    font {
        family: HusTheme.Primary.fontPrimaryFamily
        pixelSize: HusTheme.Primary.fontPrimarySize
    }
}
