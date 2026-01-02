import QtQuick
import HuskarUI.Basic

Rectangle {
    id: control

    enum TagState {
        StateDefault = 0,
        StateSuccess = 1,
        StateProcessing = 2,
        StateError = 3,
        StateWarning  = 4
    }

    signal closed()

    property bool animationEnabled: HusTheme.animationEnabled
    property int tagState: HusTag.StateDefault
    property string text: ''
    property font font: Qt.font({
        family: HusTheme.HusTag.fontFamily,
        pixelSize: HusTheme.HusTag.fontSize - 2
    })
    property bool rotating: false
    property var iconSource: 0 ?? ''
    property int iconSize: HusTheme.HusButton.fontSize
    property var closeIconSource: 0 ?? ''
    property int closeIconSize: HusTheme.HusButton.fontSize
    property alias spacing: __row.spacing
    property string presetColor: ''
    property color colorText: presetColor == '' ? HusTheme.HusTag.colorDefaultText : __private.isCustom ? '#fff' : __private.colorArray[5]
    property color colorBg: presetColor == '' ? HusTheme.HusTag.colorDefaultBg : __private.isCustom ? presetColor : __private.colorArray[0]
    property color colorBorder: presetColor == '' ? HusTheme.HusTag.colorDefaultBorder : __private.isCustom ? 'transparent' : __private.colorArray[2]
    property color colorIcon: colorText

    objectName: '__HusTag__'
    implicitWidth: __row.implicitWidth + 16
    implicitHeight: Math.max(__icon.implicitHeight, __text.implicitHeight, __closeIcon.implicitHeight) + 8
    color: colorBg
    border.color: colorBorder
    radius: HusTheme.HusTag.radiusBg
    onTagStateChanged: {
        switch (tagState) {
        case HusTag.StateSuccess: presetColor = '#52c41a'; break;
        case HusTag.StateProcessing: presetColor = '#1677ff'; break;
        case HusTag.StateError: presetColor = '#ff4d4f'; break;
        case HusTag.StateWarning: presetColor = '#faad14'; break;
        case HusTag.StateDefault:
        default: presetColor = '';
        }
    }
    onPresetColorChanged: {
        let preset = -1;
        switch (presetColor) {
        case 'red': preset = HusColorGenerator.Preset_Red; break;
        case 'volcano': preset = HusColorGenerator.Preset_Volcano; break;
        case 'orange': preset = HusColorGenerator.Preset_Orange; break;
        case 'gold': preset = HusColorGenerator.Preset_Gold; break;
        case 'yellow': preset = HusColorGenerator.Preset_Yellow; break;
        case 'lime': preset = HusColorGenerator.Preset_Lime; break;
        case 'green': preset = HusColorGenerator.Preset_Green; break;
        case 'cyan': preset = HusColorGenerator.Preset_Cyan; break;
        case 'blue': preset = HusColorGenerator.Preset_Blue; break;
        case 'geekblue': preset = HusColorGenerator.Preset_Geekblue; break;
        case 'purple': preset = HusColorGenerator.Preset_Purple; break;
        case 'magenta': preset = HusColorGenerator.Preset_Magenta; break;
        }

        if (tagState == HusTag.StateDefault) {
            __private.isCustom = preset == -1 ? true : false;
            __private.presetColor = preset == -1 ? '#000' : husColorGenerator.presetToColor(preset);
        } else {
            __private.isCustom = false;
            __private.presetColor = presetColor;
        }
    }

    Behavior on color { enabled: control.animationEnabled; ColorAnimation { duration: HusTheme.Primary.durationFast } }

    HusColorGenerator {
        id: husColorGenerator
    }

    Row {
        id: __row
        anchors.centerIn: parent
        spacing: 5

        HusIconText {
            id: __icon
            anchors.verticalCenter: parent.verticalCenter
            color: control.colorIcon
            iconSize: control.iconSize
            iconSource: control.iconSource
            verticalAlignment: Text.AlignVCenter
            visible: iconSource != 0

            Behavior on color { enabled: control.animationEnabled; ColorAnimation { duration: HusTheme.Primary.durationFast } }

            NumberAnimation on rotation {
                id: __animation
                running: control.rotating
                from: 0
                to: 360
                loops: Animation.Infinite
                duration: 1000
            }
        }

        HusCopyableText {
            id: __text
            anchors.verticalCenter: parent.verticalCenter
            text: control.text
            font: control.font
            color: control.colorText

            Behavior on color { enabled: control.animationEnabled; ColorAnimation { duration: HusTheme.Primary.durationFast } }
        }

        HusIconText {
            id: __closeIcon
            anchors.verticalCenter: parent.verticalCenter
            color: hovered ? HusTheme.HusTag.colorCloseIconHover : HusTheme.HusTag.colorCloseIcon
            iconSize: control.closeIconSize
            iconSource: control.closeIconSource
            verticalAlignment: Text.AlignVCenter
            visible: iconSource != 0

            property alias hovered: __hoverHander.hovered
            property alias down: __tapHander.pressed

            Behavior on color { enabled: control.animationEnabled; ColorAnimation { duration: HusTheme.Primary.durationFast } }

            HoverHandler {
                id: __hoverHander
                cursorShape: Qt.PointingHandCursor
            }

            TapHandler {
                id: __tapHander
                onTapped: control.closed();
            }
        }
    }

    QtObject {
        id: __private
        property bool isCustom: false
        property color presetColor: '#000'
        property var colorArray: HusThemeFunctions.genColor(presetColor, !HusTheme.isDark, HusTheme.Primary.colorBgBase)
    }
}
