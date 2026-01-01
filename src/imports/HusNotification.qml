pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import QtQuick.Templates as T
import HuskarUI.Basic

Item {
    id: control

    enum NotificationPosition {
        PositionTop = 0,
        PositionTopLeft = 1,
        PositionTopRight = 2,
        PositionBottom = 3,
        PositionBottomLeft = 4,
        PositionBottomRight = 5,
        PositionLeft = 6,
        PositionRight = 7
    }

    enum MessageType {
        TypeNone = 0,
        TypeSuccess = 1,
        TypeWarning = 2,
        TypeMessage = 3,
        TypeError = 4
    }

    signal closed(key: string)

    property bool animationEnabled: HusTheme.animationEnabled
    property int position: HusNotification.PositionTop
    property bool pauseOnHover: true
    property bool showProgress: false
    property bool stackMode: true
    property int stackThreshold: 5
    property int defaultIconSize: 20
    property int maxNotificationWidth: 300
    property int spacing: 10
    property bool closeButtonVisible: true
    property int topMargin: 12
    property int bgTopPadding: 12
    property int bgBottomPadding: 12
    property int bgLeftPadding: 12
    property int bgRightPadding: 12
    property color colorMessage: HusTheme.HusNotification.colorMessage
    property color colorDescription: HusTheme.HusNotification.colorDescription
    property color colorBg: HusTheme.isDark ? HusTheme.HusNotification.colorBgDark : HusTheme.HusNotification.colorBg
    property color colorBgShadow: HusTheme.HusNotification.colorBgShadow
    property HusRadius radiusBg: HusRadius { all: HusTheme.HusNotification.radiusBg }
    property font messageFont: Qt.font({
        family: HusTheme.HusNotification.fontFamily,
        pixelSize: parseInt(HusTheme.HusNotification.fontMessageSize)
    })
    property int messageSpacing: 8
    property font descriptionFont: Qt.font({
        family: HusTheme.HusNotification.fontFamily,
        pixelSize: parseInt(HusTheme.HusNotification.fontDescriptionSize)
    })
    property int descriptionSpacing: 10

    property Component messageDelegate: HusText {
        font: control.messageFont
        color: control.colorMessage
        text: parent.message
        horizontalAlignment: Text.AlignLeft
        wrapMode: Text.WrapAnywhere
    }
    property Component descriptionDelegate: HusText {
        width: parent.width
        font: control.descriptionFont
        color: control.colorDescription
        text: parent.description
        horizontalAlignment: Text.AlignLeft
        wrapMode: Text.WrapAnywhere
    }

    objectName: '__HusNotification__'

    Behavior on colorBg { enabled: control.animationEnabled; ColorAnimation { duration: HusTheme.Primary.durationMid } }
    Behavior on colorMessage { enabled: control.animationEnabled; ColorAnimation { duration: HusTheme.Primary.durationMid } }
    Behavior on colorDescription { enabled: control.animationEnabled; ColorAnimation { duration: HusTheme.Primary.durationMid } }

    QtObject {
        id: __private

        property bool isLeft: control.position == HusNotification.PositionLeft ||
                              control.position == HusNotification.PositionTopLeft ||
                              control.position == HusNotification.PositionBottomLeft
        property bool isRight: control.position == HusNotification.PositionRight ||
                               control.position == HusNotification.PositionTopRight ||
                               control.position == HusNotification.PositionBottomRight
        property bool isTop: control.position == HusNotification.PositionTop ||
                             control.position == HusNotification.PositionTopLeft ||
                             control.position == HusNotification.PositionTopRight
        property bool isBottom: control.position == HusNotification.PositionBottom ||
                                control.position == HusNotification.PositionBottomLeft ||
                                control.position == HusNotification.PositionBottomRight

        function initObject(object) {
            if (!object.hasOwnProperty('key')) object.key = '';
            if (!object.hasOwnProperty('loading')) object.loading = false;
            if (!object.hasOwnProperty('message')) object.message = '';
            if (!object.hasOwnProperty('description')) object.description = '';
            if (!object.hasOwnProperty('type')) object.type = HusNotification.TypeNone;
            if (!object.hasOwnProperty('duration')) object.duration = 4500;
            if (!object.hasOwnProperty('iconSize')) object.iconSize = control.defaultIconSize;
            if (!object.hasOwnProperty('iconSource')) object.iconSource = 0;

            if (!object.hasOwnProperty('colorIcon')) object.colorIcon = '';
            else object.colorIcon = String(object.colorIcon);

            return object;
        }
    }

    ColumnLayout {
        id: __columnLayout
        anchors {
            left: __private.isLeft ? parent.left : undefined
            right: __private.isRight ? parent.right : undefined
            top: __private.isTop ? parent.top : undefined
            bottom: __private.isBottom ? parent.bottom : undefined
            horizontalCenter: control.position == HusNotification.PositionTop||
                              control.position == HusNotification.PositionBottom ? parent.horizontalCenter : undefined
            verticalCenter: control.position == HusNotification.PositionLeft ||
                            control.position == HusNotification.PositionRight ? parent.verticalCenter : undefined
            margins: 10
            topMargin: control.topMargin
        }
        spacing: 0

        Repeater {
            id: __repeater

            property bool collapsed: control.stackMode && __listModel.count > control.stackThreshold && !__hoverHandler.hovered

            model: ListModel { id: __listModel }
            delegate: Item {
                id: __rootItem
                z: -index
                Layout.preferredWidth: __content.width
                Layout.preferredHeight: __content.height
                Layout.leftMargin: __private.isLeft ? (-__content.width - 20) : 0
                Layout.rightMargin: __private.isRight ? (-__content.width - 20) : 0
                Layout.topMargin: index == 0 ? 0 : (__repeater.collapsed ? collapseTopMargin : control.spacing)
                Layout.alignment: __private.isLeft ? Qt.AlignLeft : Qt.AlignRight

                required property int index
                required property string key
                required property bool loading
                required property string message
                required property string description
                required property int type
                required property int duration
                required property int iconSize
                required property int iconSource
                required property string colorIcon

                property real collapseTopMargin: index == 0 ? 10 : (index == 1 || index == 2) ? (10 - __content.height) : (- __content.height)

                function removeSelf() {
                    __content.height = 0;
                    __removeTimer.start();
                }

                NumberAnimation on Layout.leftMargin {
                    running: control.animationEnabled && __private.isLeft
                    to: 0
                    easing.type: Easing.OutQuad
                    duration: HusTheme.Primary.durationMid
                }

                NumberAnimation on Layout.rightMargin {
                    running: control.animationEnabled && __private.isRight
                    to: 0
                    duration: HusTheme.Primary.durationMid
                }

                Behavior on Layout.topMargin { enabled: control.animationEnabled; NumberAnimation { duration: HusTheme.Primary.durationMid } }

                Timer {
                    id: __timer
                    running: control.pauseOnHover ? !__hoverHandler.hovered : true
                    interval: 25
                    repeat: true
                    onTriggered: {
                        time += 25;
                        if (time >= __rootItem.duration) {
                            stop();
                            __rootItem.removeSelf();
                        }
                    }
                    property int time: 0
                }

                HusShadow {
                    anchors.fill: __rootItem
                    source: __bgRect
                    shadowColor: control.colorBgShadow
                    shadowEnabled: __repeater.collapsed ? index <= 2 : true
                }

                HusRectangleInternal {
                    id: __bgRect
                    anchors.fill: parent
                    color: control.colorBg
                    radius: control.radiusBg.all
                    topLeftRadius: control.radiusBg.topLeft
                    topRightRadius: control.radiusBg.topRight
                    bottomLeftRadius: control.radiusBg.bottomLeft
                    bottomRightRadius: control.radiusBg.bottomRight
                    visible: false
                }

                Item {
                    id: __content
                    width: __rowLayout.width + control.bgLeftPadding + control.bgRightPadding
                    height: 0
                    opacity: 0
                    clip: true

                    Component.onCompleted: {
                        opacity = 1;
                        height = Qt.binding(() => __rowLayout.height + control.bgTopPadding + control.bgBottomPadding);
                    }

                    Behavior on opacity { enabled: control.animationEnabled; NumberAnimation { duration: HusTheme.Primary.durationMid } }
                    Behavior on height { enabled: control.animationEnabled; NumberAnimation { duration: HusTheme.Primary.durationMid } }

                    Timer {
                        id: __removeTimer
                        running: false
                        interval: control.animationEnabled ? HusTheme.Primary.durationMid : 0
                        onTriggered: {
                            control.closed(__rootItem.key);
                            __listModel.remove(__rootItem.index);
                        }
                    }

                    RowLayout {
                        id: __rowLayout
                        width: Math.min(control.maxNotificationWidth, control.width - control.bgLeftPadding - control.bgRightPadding)
                        anchors.centerIn: parent
                        spacing: control.messageSpacing

                        HusIconText {
                            Layout.alignment: Qt.AlignTop
                            Layout.topMargin: 5
                            iconSize: __rootItem.iconSize
                            iconSource: {
                                if (__rootItem.loading) return HusIcon.LoadingOutlined;
                                if (__rootItem.iconSource != 0) return __rootItem.iconSource;
                                switch (type) {
                                    case HusNotification.TypeSuccess: return HusIcon.CheckCircleFilled;
                                    case HusNotification.TypeWarning: return HusIcon.ExclamationCircleFilled;
                                    case HusNotification.TypeMessage: return HusIcon.ExclamationCircleFilled;
                                    case HusNotification.TypeError: return HusIcon.CloseCircleFilled;
                                    default: return 0;
                                }
                            }
                            colorIcon: {
                                if (__rootItem.loading) return HusTheme.Primary.colorInfo;
                                if (__rootItem.colorIcon !== '') return __rootItem.colorIcon;
                                switch ((type)) {
                                    case HusNotification.TypeSuccess: return HusTheme.Primary.colorSuccess;
                                    case HusNotification.TypeWarning: return HusTheme.Primary.colorWarning;
                                    case HusNotification.TypeMessage: return HusTheme.Primary.colorInfo;
                                    case HusNotification.TypeError: return HusTheme.Primary.colorError;
                                    default: return HusTheme.Primary.colorInfo;
                                }
                            }

                            NumberAnimation on rotation {
                                running: __rootItem.loading
                                from: 0
                                to: 360
                                loops: Animation.Infinite
                                duration: 1000
                            }
                        }

                        Item {
                            Layout.alignment: Qt.AlignTop
                            Layout.topMargin: 5
                            Layout.fillWidth: true
                            Layout.preferredHeight: __messageLoader.height + __descriptionLoader.height + control.descriptionSpacing

                            Loader {
                                id: __messageLoader
                                width: parent.width
                                sourceComponent: control.messageDelegate
                                property alias index: __rootItem.index
                                property alias key: __rootItem.key
                                property alias message: __rootItem.message
                            }

                            Loader {
                                id: __descriptionLoader
                                width: parent.width
                                anchors.top: __messageLoader.bottom
                                anchors.topMargin: control.descriptionSpacing
                                sourceComponent: control.descriptionDelegate
                                property alias index: __rootItem.index
                                property alias key: __rootItem.key
                                property alias description: __rootItem.description
                            }
                        }

                        Loader {
                            Layout.alignment: Qt.AlignTop
                            Layout.topMargin: 5
                            active: control.closeButtonVisible
                            sourceComponent: HusCaptionButton {
                                topPadding: 2
                                bottomPadding: 2
                                leftPadding: 4
                                rightPadding: 4
                                radiusBg.all: 2
                                animationEnabled: control.animationEnabled
                                hoverCursorShape: Qt.PointingHandCursor
                                iconSource: HusIcon.CloseOutlined
                                colorIcon: hovered ? HusTheme.HusNotification.colorCloseHover : HusTheme.HusNotification.colorClose
                                onClicked: {
                                    __timer.stop();
                                    __rootItem.removeSelf();
                                }
                            }
                        }
                    }

                    Loader {
                        width: parent.width - __bgRect.radius * 2
                        height: 2
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.bottom: parent.bottom
                        active: control.showProgress
                        sourceComponent: HusProgress {
                            percent: (__rootItem.duration - __timer.time) / __rootItem.duration * 100
                            animationEnabled: false
                            showInfo: false
                        }
                    }
                }
            }
        }

        HoverHandler {
            id: __hoverHandler
        }
    }

    function info(message: string, description: string, duration = 4500) {
        open({
            'message': message,
            'description': description,
            'type': HusNotification.TypeMessage,
            'duration': duration
        });
    }

    function success(message: string, description: string, duration = 4500) {
        open({
            'message': message,
            'description': description,
            'type': HusNotification.TypeSuccess,
            'duration': duration
        });
    }

    function error(message: string, description: string, duration = 4500) {
        open({
            'message': message,
            'description': description,
            'type': HusNotification.TypeError,
            'duration': duration
        });
    }

    function warning(message: string, description: string, duration = 4500) {
        open({
            'message': message,
            'description': description,
            'type': HusNotification.TypeWarning,
            'duration': duration
        });
    }

    function loading(message: string, description: string, duration = 4500) {
        open({
            'loading': true,
            'message': message,
            'description': description,
            'type': HusNotification.TypeMessage,
            'duration': duration
        });
    }

    function open(object) {
        __listModel.insert(0, __private.initObject(object));
    }

    function close(key: string) {
        for (let i = 0; i < __listModel.count; i++) {
            const object = __listModel.get(i);
            if (object.key && object.key === key) {
                const item = __repeater.itemAt(i);
                if (item)
                    item.removeSelf();
                break;
            }
        }
    }

    function clear() {
        __listModel.clear();
    }

    function getNotification(key: string): var {
        for (let i = 0; i < __listModel.count; i++) {
            const object = __listModel.get(i);
            if (object.key && object.key === key) {
                return object;
            }
        }
        return undefined;
    }

    function setProperty(key: string, property: string, value: var) {
        for (let i = 0; i < __listModel.count; i++) {
            const object = __listModel.get(i);
            if (object.key && object.key === key) {
                __listModel.setProperty(i, property, value);
                break;
            }
        }
    }
}
