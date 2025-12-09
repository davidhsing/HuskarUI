import QtQuick
import QtQuick.Templates as T
import HuskarUI.Basic

T.ComboBox {
    id: control

    signal clickClear()

    property bool animationEnabled: HusTheme.animationEnabled
    readonly property bool active: hovered || activeFocus
    property bool clearEnabled: true
    property var clearIconSource: HusIcon.CloseCircleFilled ?? ''
    property int defaultPopupMaxHeight: 240
    property bool errorState: false
    property int hoverCursorShape: Qt.PointingHandCursor
    property var initValue: null
    property bool loading: false
    property bool tooltipVisible: false
    property color colorText: enabled ? (popup.visible ? themeSource.colorTextActive : themeSource.colorText) : themeSource.colorTextDisabled
    property color colorBorder: errorState ? (active ? themeSource.colorErrorBorderHover : themeSource.colorErrorBorder) : (enabled ? (active ? themeSource.colorBorderHover : themeSource.colorBorder) : themeSource.colorBorderDisabled)
    property color colorBg: enabled ? themeSource.colorBg : themeSource.colorBgDisabled
    property int radiusBg: themeSource.radiusBg
    property int radiusItemBg: themeSource.radiusItemBg
    property int radiusPopupBg: themeSource.radiusPopupBg
    property string contentDescription: ''
    property var themeSource: HusTheme.HusSelect

    property Component indicatorDelegate: HusIconText {
        colorIcon: {
            if (control.enabled) {
                if (__clearMouseArea.active) {
                    return __clearMouseArea.pressed ? control.themeSource.colorIndicatorActive :
                                                      __clearMouseArea.hovered ? control.themeSource.colorIndicatorHover :
                                                                                 control.themeSource.colorIndicator;
                } else {
                    return control.themeSource.colorIndicator;
                }
            } else {
                return control.themeSource.colorIndicatorDisabled;
            }
        }
        iconSize: control.themeSource.fontSize
        iconSource: {
            if (control.enabled && control.clearEnabled && __clearMouseArea.active) {
                return control.clearIconSource;
            } else {
                return control.loading ? HusIcon.LoadingOutlined : HusIcon.DownOutlined
            }
        }

        Behavior on colorIcon { enabled: control.animationEnabled; ColorAnimation { duration: HusTheme.Primary.durationMid } }

        NumberAnimation on rotation {
            running: control.loading
            from: 0
            to: 360
            loops: Animation.Infinite
            duration: 1000
        }

        MouseArea {
            id: __clearMouseArea
            anchors.fill: parent
            enabled: control.enabled
            hoverEnabled: true
            cursorShape: hovered ? Qt.PointingHandCursor : Qt.ArrowCursor
            onEntered: hovered = true;
            onExited: hovered = false;
            onClicked: function(mouse) {
                if (active && control.clearEnabled) {
                    control.currentIndex = -1;
                    control.clickClear();
                } else {
                    if (control.popup.opened) {
                        control.popup.close();
                    } else {
                        control.popup.open();
                    }
                }
                mouse.accepted = true;
            }
            property bool active: !control.loading && control.currentIndex >= 0 && control.count > 0 && control.hovered
            property bool hovered: false
        }
    }

    Behavior on colorText { enabled: control.animationEnabled; ColorAnimation { duration: HusTheme.Primary.durationFast } }
    Behavior on colorBorder { enabled: control.animationEnabled; ColorAnimation { duration: HusTheme.Primary.durationFast } }
    Behavior on colorBg { enabled: control.animationEnabled; ColorAnimation { duration: HusTheme.Primary.durationFast } }

    Component.onCompleted: {
        if (control.initValue !== undefined && control.initValue !== null && control.model && control.count > 0) {
            for (let i = 0; i < control.count; i++) {
                const item = control.model[i];
                if (item && item[control.valueRole] === control.initValue) {
                    control.currentIndex = i;
                    return;
                }
            }
        }
    }

    objectName: '__HusSelect__'
    leftPadding: 4
    rightPadding: 8
    topPadding: 4
    bottomPadding: 4
    implicitWidth: implicitContentWidth + implicitIndicatorWidth + leftPadding + rightPadding
    implicitHeight: implicitContentHeight + topPadding + bottomPadding
    currentIndex: -1
    textRole: 'label'
    valueRole: 'value'
    font {
        family: control.themeSource.fontFamily
        pixelSize: control.themeSource.fontSize
    }
    delegate: T.ItemDelegate { }
    indicator: Loader {
        x: control.width - width - control.rightPadding
        y: control.topPadding + (control.availableHeight - height) / 2
        sourceComponent: indicatorDelegate
    }
    contentItem: HusText {
        topPadding: 1
        bottomPadding: 1
        leftPadding: 8
        rightPadding: control.indicator.width + control.spacing
        text: control.displayText
        font: control.font
        color: control.colorText
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
    }
    background: Rectangle {
        color: control.colorBg
        border.color: control.colorBorder
        border.width: control.visualFocus ? 2 : 1
        radius: control.radiusBg
    }
    popup: HusPopup {
        id: __popup
        y: control.height + 2
        implicitWidth: control.width
        implicitHeight: Math.min(control.defaultPopupMaxHeight, __popupListView.contentHeight) + topPadding + bottomPadding
        leftPadding: 4
        rightPadding: 4
        topPadding: 6
        bottomPadding: 6
        animationEnabled: control.animationEnabled
        radiusBg: control.themeSource.radiusPopupBg
        colorBg: HusTheme.isDark ? control.themeSource.colorPopupBgDark : control.themeSource.colorPopupBg
        enter: Transition {
            NumberAnimation {
                property: 'opacity'
                from: 0.0
                to: 1.0
                easing.type: Easing.OutQuad
                duration: control.animationEnabled ? HusTheme.Primary.durationMid : 0
            }
            NumberAnimation {
                property: 'height'
                to: __popup.implicitHeight
                easing.type: Easing.OutQuad
                duration: control.animationEnabled ? HusTheme.Primary.durationMid : 0
            }
        }
        exit: Transition {
            NumberAnimation {
                property: 'opacity'
                from: 1.0
                to: 0.0
                easing.type: Easing.InQuad
                duration: control.animationEnabled ? HusTheme.Primary.durationMid : 0
            }
            NumberAnimation {
                property: 'height'
                from: Math.min(control.defaultPopupMaxHeight, __popupListView.contentHeight) + topPadding + bottomPadding
                to: 0
                easing.type: Easing.InQuad
                duration: control.animationEnabled ? HusTheme.Primary.durationMid : 0
            }
        }
        contentItem: ListView {
            id: __popupListView
            clip: true
            model: control.popup.visible ? control.model : null
            currentIndex: control.highlightedIndex
            boundsBehavior: Flickable.StopAtBounds
            delegate: T.ItemDelegate {
                id: __popupDelegate

                required property var model
                required property int index

                width: __popupListView.width
                height: implicitContentHeight + topPadding + bottomPadding
                leftPadding: 8
                rightPadding: 8
                topPadding: 5
                bottomPadding: 5
                enabled: model.enabled ?? true
                contentItem: HusText {
                    text: __popupDelegate.model[control.textRole]
                    color: __popupDelegate.enabled ? control.themeSource.colorItemText : control.themeSource.colorItemTextDisabled;
                    font {
                        family: control.themeSource.fontFamily
                        pixelSize: control.themeSource.fontSize
                        weight: highlighted ? Font.DemiBold : Font.Normal
                    }
                    elide: Text.ElideRight
                    verticalAlignment: Text.AlignVCenter
                }
                background: Rectangle {
                    radius: control.radiusItemBg
                    color: {
                        if (__popupDelegate.enabled)
                            return highlighted ? control.themeSource.colorItemBgActive :
                                                 hovered ? control.themeSource.colorItemBgHover :
                                                           control.themeSource.colorItemBg;
                        else
                            return control.themeSource.colorItemBgDisabled;
                    }

                    Behavior on color { enabled: control.animationEnabled; ColorAnimation { duration: HusTheme.Primary.durationFast } }
                }
                highlighted: control.highlightedIndex === index
                onClicked: {
                    control.currentIndex = index;
                    control.activated(index);
                    control.popup.close();
                }

                HoverHandler {
                    cursorShape: control.hoverCursorShape
                }

                Loader {
                    y: __popupDelegate.height
                    anchors.horizontalCenter: parent.horizontalCenter
                    active: control.tooltipVisible
                    sourceComponent: HusToolTip {
                        arrowVisible: false
                        visible: __popupDelegate.hovered
                        animationEnabled: control.animationEnabled
                        text: __popupDelegate.model[control.textRole]
                        position: HusToolTip.Position_Bottom
                    }
                }
            }
            T.ScrollBar.vertical: HusScrollBar {
                animationEnabled: control.animationEnabled
            }
        }

        Binding on height { when: __popup.opened; value: __popup.implicitHeight }
    }

    HoverHandler {
        cursorShape: control.hoverCursorShape
    }

    Accessible.role: Accessible.ComboBox
    Accessible.name: control.displayText
    Accessible.description: control.contentDescription
}
