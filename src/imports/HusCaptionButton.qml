import QtQuick
import HuskarUI.Basic

HusIconButton {
    id: control

    property bool errorState: false

    objectName: '__HusCaptionButton__'
    leftPadding: 12
    rightPadding: 12
    radiusBg: 0
    hoverCursorShape: Qt.ArrowCursor
    type: HusButton.Type_Text
    iconSize: HusTheme.HusCaptionButton.fontSize
    effectEnabled: false
    colorIcon: {
        if (control.enabled || control.noDisabledState) {
            return checked ? HusTheme.HusCaptionButton.colorIconChecked : HusTheme.HusCaptionButton.colorIcon;
        }
        return HusTheme.HusCaptionButton.colorIconDisabled;
    }
    colorBg: {
        if (control.enabled || control.noDisabledState) {
            if (errorState) {
                return control.down ? HusTheme.HusCaptionButton.colorErrorBgActive: (control.hovered ? HusTheme.HusCaptionButton.colorErrorBgHover : HusTheme.HusCaptionButton.colorErrorBg);
            }
            return control.down ? HusTheme.HusCaptionButton.colorBgActive: (control.hovered ? HusTheme.HusCaptionButton.colorBgHover : HusTheme.HusCaptionButton.colorBg);
        }
        return HusTheme.HusCaptionButton.colorBgDisabled;
    }
}
