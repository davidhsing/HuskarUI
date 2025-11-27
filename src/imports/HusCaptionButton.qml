import QtQuick
import HuskarUI.Basic

HusIconButton {
    id: control

    property bool isError: false
    property bool noDisabledState: false

    objectName: '__HusCaptionButton__'
    leftPadding: 12
    rightPadding: 12
    radiusBg: 0
    hoverCursorShape: Qt.ArrowCursor
    type: HusButton.Type_Text
    iconSize: HusTheme.HusCaptionButton.fontSize
    effectEnabled: false
    colorIcon: {
        if (!enabled || !noDisabledState) {
            return HusTheme.HusCaptionButton.colorIconDisabled;
        }
        return checked ? HusTheme.HusCaptionButton.colorIconChecked : HusTheme.HusCaptionButton.colorIcon;
    }
    colorBg: {
        if (!enabled || !noDisabledState) {
            return HusTheme.HusCaptionButton.colorBgDisabled;
        }
        if (isError) {
            return control.down ? HusTheme.HusCaptionButton.colorErrorBgActive: (control.hovered ? HusTheme.HusCaptionButton.colorErrorBgHover : HusTheme.HusCaptionButton.colorErrorBg);
        }
        return control.down ? HusTheme.HusCaptionButton.colorBgActive: (control.hovered ? HusTheme.HusCaptionButton.colorBgHover : HusTheme.HusCaptionButton.colorBg);
    }
    colorBorder: {
        if (type === HusButton.Type_Link) {
            return 'transparent';
        }
        if (!enabled || !noDisabledState) {
            return HusTheme.HusButton.colorBorderDisabled;
        }
        switch (control.type) {
            case HusButton.Type_Default:
                return control.down ? HusTheme.HusButton.colorBorderActive : (control.hovered ? HusTheme.HusButton.colorBorderHover : HusTheme.HusButton.colorDefaultBorder);
            default:
                return control.down ? HusTheme.HusButton.colorBorderActive : (control.hovered ? HusTheme.HusButton.colorBorderHover : HusTheme.HusButton.colorBorder);
        }
    }
}
