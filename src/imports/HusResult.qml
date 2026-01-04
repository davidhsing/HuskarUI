import QtQuick
import QtQuick.Layouts
import HuskarUI.Basic

Item {
    id: control

    enum ResultType {
        TypeInfo = 0,
        TypeWarning = 1,
        TypeSuccess = 2,
        TypeError = 3
    }

    enum ExtraPosition {
        PositionLeft = 0,
        PositionRight = 1
    }

    // Basic properties
    property bool animationEnabled: HusTheme.animationEnabled
    property bool borderVisible: true
    property int spacing: 16
    property int type: HusResult.TypeInfo

    // Icon properties
    property bool iconVisible: control.iconSource !== 0 && control.iconSource !== ''
    property var iconSource: 0 ?? ''
    property real iconSize: 80
    property var iconImageSource: ''
    property var iconImageFallback: ''
    property int iconImageFillMode: Image.PreserveAspectFit
    property bool iconImageEmptyAsError: false
    property int iconImageWidth: -1
    property int iconImageHeight: -1
    property color colorIcon: {
        switch (control.type) {
            case HusResult.TypeInfo: return HusTheme.Primary.colorInfo;
            case HusResult.TypeWarning: return HusTheme.Primary.colorWarning;
            case HusResult.TypeSuccess: return HusTheme.Primary.colorSuccess;
            case HusResult.TypeError: return HusTheme.Primary.colorError;
            default: return HusTheme.Primary.colorInfo;
        }
    }

    // Extra properties
    property bool extraVisible: true
    property int extraPosition: HusResult.PositionRight

    // Title properties
    property bool titleVisible: !!control.titleText
    property string titleText: ''
    property font titleFont: Qt.font({
        family: HusTheme.HusResult.fontTitleFamily,
        pixelSize: HusTheme.HusResult.fontTitleSize
    })

    // Description properties
    property bool descriptionVisible: !!control.descriptionText
    property string descriptionText: ''
    property font descriptionFont: Qt.font({
        family: HusTheme.HusResult.fontDescriptionFamily,
        pixelSize: HusTheme.HusResult.fontDescriptionSize
    })

    // Action properties
    property bool actionVisible: true

    // Footer properties
    property bool footerVisible: true

    // Background properties
    property color colorBg: HusTheme.HusResult.colorBg
    property HusRadius radiusBg: HusRadius { all: HusTheme.HusResult.radiusBg }

    // Margin properties
    property HusMargin marginExtra: HusMargin { all: 0 }
    property HusMargin marginIcon: HusMargin { top: 8; bottom: 0 }
    property HusMargin marginTitle: HusMargin { top: 4; bottom: 0 }
    property HusMargin marginDescription: HusMargin { all: 0 }
    property HusMargin marginAction: HusMargin { all: 0 }
    property HusMargin marginFooter: HusMargin { all: 0 }

    // Delegates
    property Component iconDelegate: ColumnLayout {
        implicitHeight: __iconLoader.item ? __iconLoader.item.implicitHeight : control.iconSize
        implicitWidth: __iconLoader.item ? __iconLoader.item.implicitWidth : control.iconSize

        Loader {
            id: __iconLoader
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignHCenter
            sourceComponent: (typeof control.iconImageSource === 'string' && control.iconImageSource !== '') || (typeof control.iconImageSource === 'object' && control.iconImageSource.toString() !== '') ? __iconImageComp : __iconTextComp
        }

        Component {
            id: __iconImageComp
            HusImage {
                id: __iconImage
                anchors.fill: parent
                emptyAsError: control.iconImageEmptyAsError
                fallback: control.iconImageFallback
                fillMode: control.iconImageFillMode
                horizontalAlignment: Text.AlignHCenter
                width: control.iconImageWidth > 0 ? control.iconImageWidth : implicitWidth
                height: control.iconImageHeight > 0 ? control.iconImageHeight : implicitHeight
                source: control.iconImageSource
            }
        }

        Component {
            id: __iconTextComp
            HusIconText {
                id: __iconText
                anchors.fill: parent
                color: control.colorIcon
                iconSource: {
                    switch (control.type) {
                        case HusResult.TypeInfo: return HusIcon.ExclamationCircleFilled;
                        case HusResult.TypeWarning: return HusIcon.ExclamationCircleFilled;
                        case HusResult.TypeSuccess: return HusIcon.CheckCircleFilled;
                        case HusResult.TypeError: return HusIcon.CloseCircleFilled;
                        default: return HusIcon.ExclamationCircleFilled;
                    }
                }
                iconSize: control.iconSize
                horizontalAlignment: Text.AlignHCenter
            }
        }
    }

    property Component extraDelegate: Item { }

    property Component titleDelegate: HusText {
        text: control.titleText
        font: control.titleFont
        color: HusTheme.HusResult.colorTitle
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        visible: !!control.titleText
    }

    property Component descriptionDelegate: HusText {
        text: control.descriptionText
        font: control.descriptionFont
        color: HusTheme.HusResult.colorDescription
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        visible: !!control.descriptionText
    }

    property Component actionDelegate: Item { }

    property Component footerDelegate: Item { }

    property Component bgDelegate: HusRectangleInternal {
        border.color: HusTheme.HusResult.colorBorder
        border.width: 1
        color: control.colorBg
        radius: control.radiusBg.all
        topLeftRadius: control.radiusBg.topLeft
        topRightRadius: control.radiusBg.topRight
        bottomLeftRadius: control.radiusBg.bottomLeft
        bottomRightRadius: control.radiusBg.bottomRight
    }

    objectName: '__HusResult__'
    implicitWidth: Math.max(__bgLoader.implicitWidth, __mainLayout.implicitWidth)
    implicitHeight: Math.max(__bgLoader.implicitHeight, __mainLayout.implicitHeight)
    width: parent.width
    height: implicitHeight

    Loader {
        id: __bgLoader
        anchors.fill: parent
        sourceComponent: control.bgDelegate
    }

    // Extra area
    Item {
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.topMargin: control.marginExtra.top
        anchors.leftMargin: control.extraPosition === HusResult.PositionLeft ? control.marginExtra.left : 0
        anchors.rightMargin: control.extraPosition === HusResult.PositionRight ? control.marginExtra.right : 0
        implicitHeight: __extraLoader.item ? __extraLoader.item.implicitHeight : 0
        visible: control.extraVisible

        Loader {
            id: __extraLoader
            anchors.top: parent.top
            anchors.left: control.extraPosition === HusResult.PositionLeft ? parent.left : undefined
            anchors.right: control.extraPosition === HusResult.PositionRight ? parent.right : undefined
            sourceComponent: control.extraDelegate
            active: control.extraVisible
            visible: active
            z: 1
        }
    }

    // Content area
    ColumnLayout {
        id: __mainLayout
        anchors.fill: parent
        spacing: control.spacing

        // Icon
        Loader {
            id: __iconLoader
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
            Layout.topMargin: control.marginIcon.top
            Layout.bottomMargin: control.marginIcon.bottom
            Layout.leftMargin: control.marginIcon.left
            Layout.rightMargin: control.marginIcon.right
            sourceComponent: control.iconDelegate
            active: control.iconVisible
            visible: active
        }

        // Title
        Loader {
            id: __titleLoader
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
            Layout.topMargin: control.marginTitle.top
            Layout.bottomMargin: control.marginTitle.bottom
            Layout.leftMargin: control.marginTitle.left
            Layout.rightMargin: control.marginTitle.right
            sourceComponent: control.titleDelegate
            active: control.titleVisible
            visible: active
        }

        // Description
        Loader {
            id: __descriptionLoader
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
            Layout.topMargin: control.marginDescription.top
            Layout.bottomMargin: control.marginDescription.bottom
            Layout.leftMargin: control.marginDescription.left
            Layout.rightMargin: control.marginDescription.right
            sourceComponent: control.descriptionDelegate
            active: control.descriptionVisible
            visible: active
        }

        // Action
        Loader {
            id: __actionLoader
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
            Layout.topMargin: control.marginAction.top
            Layout.bottomMargin: control.marginAction.bottom
            Layout.leftMargin: control.marginAction.left
            Layout.rightMargin: control.marginAction.right
            sourceComponent: control.actionDelegate
            active: control.actionVisible
            visible: active
        }

        // Footer
        Loader {
            id: __footerLoader
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
            Layout.topMargin: control.marginFooter.top
            Layout.bottomMargin: control.marginFooter.bottom
            Layout.leftMargin: control.marginFooter.left
            Layout.rightMargin: control.marginFooter.right
            sourceComponent: control.footerDelegate
            active: control.footerVisible
            visible: active
        }
    }
}
