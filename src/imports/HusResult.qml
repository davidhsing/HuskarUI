import QtQuick
import QtQuick.Layouts
import HuskarUI.Basic

Item {
    id: control

    enum ResultType {
        Type_Info = 0,
        Type_Warning = 1,
        Type_Success = 2,
        Type_Error = 3
    }

    enum ExtraPosition {
        Position_Start = 0,
        Position_End = 1
    }

    // Basic properties
    property bool animationEnabled: HusTheme.animationEnabled
    property int spacing: 16
    property int type: HusResult.Type_Info

    // Icon properties
    property var iconSource: 0 ?? ''
    property real iconSize: 80
    property var iconImageSource: ''
    property var iconImageFallback: ''
    property int iconImageFillMode: Image.PreserveAspectFit
    property bool iconImageEmptyAsError: false
    property bool iconVisible: true
    property color colorIcon: {
        switch (control.type) {
            case HusResult.Type_Info: return HusTheme.Primary.colorInfo;
            case HusResult.Type_Warning: return HusTheme.Primary.colorWarning;
            case HusResult.Type_Success: return HusTheme.Primary.colorSuccess;
            case HusResult.Type_Error: return HusTheme.Primary.colorError;
            default: return HusTheme.Primary.colorInfo;
        }
    }

    // Extra properties
    property int extraPosition: HusResult.Position_End
    property bool extraVisible: true

    // Title properties
    property string titleText: ''
    property font titleFont: Qt.font({
        family: HusTheme.HusResult.fontTitleFamily,
        pixelSize: HusTheme.HusResult.fontTitleSize
    })
    property bool titleVisible: true

    // Description properties
    property string descriptionText: ''
    property font descriptionFont: Qt.font({
        family: HusTheme.HusResult.fontDescriptionFamily,
        pixelSize: HusTheme.HusResult.fontDescriptionSize
    })
    property bool descriptionVisible: true

    // Action properties
    property bool actionVisible: true

    // Footer properties
    property bool footerVisible: true

    // Background properties
    property color colorBg: HusTheme.HusResult.colorBg
    property HusRadius radiusBg: HusRadius { all: HusTheme.HusResult.radiusBg }

    // Margin properties
    property HusMargin marginExtra: HusMargin { all: 8 }
    property HusMargin marginIcon: HusMargin { all: 0 }
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
                source: control.iconImageSource
                emptyAsError: control.iconImageEmptyAsError
                fallback: control.iconImageFallback
                fillMode: control.iconImageFillMode
                horizontalAlignment: Text.AlignHCenter
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
                        case HusResult.Type_Info: return HusIcon.ExclamationCircleFilled;
                        case HusResult.Type_Warn: return HusIcon.ExclamationCircleFilled;
                        case HusResult.Type_Success: return HusIcon.CheckCircleFilled;
                        case HusResult.Type_Error: return HusIcon.CloseCircleFilled;
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
        color: control.colorBg
        radius: control.radiusBg.all
        topLeftRadius: control.radiusBg.topLeft
        topRightRadius: control.radiusBg.topRight
        bottomLeftRadius: control.radiusBg.bottomLeft
        bottomRightRadius: control.radiusBg.bottomRight
    }

    property Component contentDelegate: Item {
        implicitHeight: __mainColumn.implicitHeight

        // Extra content (top left or top right)
        Item {
            Layout.fillWidth: true
            Layout.topMargin: control.marginExtra.top
            Layout.leftMargin: control.extraPosition === HusResult.Position_Start ? control.marginExtra.left : 0
            Layout.rightMargin: control.extraPosition === HusResult.Position_End ? control.marginExtra.right : 0
            implicitHeight: __extraLoader.item ? __extraLoader.item.implicitHeight : 0
            visible: control.extraVisible

            Loader {
                id: __extraLoader
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.alignment: control.extraPosition === HusResult.Position_Start ? Qt.AlignLeft : Qt.AlignRight
                sourceComponent: control.extraDelegate
                active: control.extraVisible
                visible: active
                z: 1
            }
        }

        ColumnLayout {
            id: __mainColumn
            anchors.fill: parent
            spacing: control.spacing

            Component.onCompleted: {
                height = Qt.binding(() => __mainColumn.implicitHeight);
            }

            // Icon
            Item {
                id: __iconItem
                Layout.fillWidth: true
                Layout.topMargin: control.marginIcon.top
                Layout.bottomMargin: control.marginIcon.bottom
                Layout.leftMargin: control.marginIcon.left
                Layout.rightMargin: control.marginIcon.right
                implicitHeight: __iconLoader.item ? __iconLoader.item.implicitHeight : 0
                visible: control.iconVisible

                Loader {
                    id: __iconLoader
                    anchors.fill: parent
                    sourceComponent: control.iconDelegate
                    active: control.iconVisible
                    visible: active
                }
            }

            // Title
            Item {
                id: __titleItem
                Layout.fillWidth: true
                Layout.topMargin: control.marginTitle.top
                Layout.bottomMargin: control.marginTitle.bottom
                Layout.leftMargin: control.marginTitle.left
                Layout.rightMargin: control.marginTitle.right
                implicitHeight: __titleLoader.item ? __titleLoader.item.implicitHeight : 0
                visible: control.titleVisible

                Loader {
                    id: __titleLoader
                    anchors.fill: parent
                    sourceComponent: control.titleDelegate
                    active: control.titleVisible
                    visible: active
                }
            }

            // Description
            Item {
                Layout.fillWidth: true
                Layout.topMargin: control.marginDescription.top
                Layout.bottomMargin: control.marginDescription.bottom
                Layout.leftMargin: control.marginDescription.left
                Layout.rightMargin: control.marginDescription.right
                implicitHeight: __descriptionLoader.item ? __descriptionLoader.item.implicitHeight : 0
                visible: control.descriptionVisible

                Loader {
                    id: __descriptionLoader
                    anchors.fill: parent
                    sourceComponent: control.descriptionDelegate
                    active: control.descriptionVisible
                    visible: active
                }
            }

            // Action
            Item {
                Layout.fillWidth: true
                Layout.topMargin: control.marginAction.top
                Layout.bottomMargin: control.marginAction.bottom
                Layout.leftMargin: control.marginAction.left
                Layout.rightMargin: control.marginAction.right
                Layout.preferredHeight: __actionLoader.item ? __actionLoader.item.implicitHeight : 0
                visible: control.actionVisible

                Loader {
                    id: __actionLoader
                    Layout.alignment: Qt.AlignHCenter
                    anchors.fill: parent
                    sourceComponent: control.actionDelegate
                    active: control.actionVisible
                    visible: active
                }
            }

            // Footer
            Item {
                Layout.alignment: Qt.AlignHCenter
                Layout.fillWidth: true
                Layout.topMargin: control.marginFooter.top
                Layout.bottomMargin: control.marginFooter.bottom
                Layout.leftMargin: control.marginFooter.left
                Layout.rightMargin: control.marginFooter.right
                implicitHeight: __footerLoader.item ? __footerLoader.item.implicitHeight : 0
                visible: control.footerVisible

                Loader {
                    id: __footerLoader
                    anchors.fill: parent
                    sourceComponent: control.footerDelegate
                    active: control.footerVisible
                    visible: active
                }
            }
        }
    }

    objectName: '__HusResult__'
    implicitWidth: __contentLoader.implicitWidth
    implicitHeight: __contentLoader.implicitHeight
    width: parent.width
    height: implicitHeight

    Loader {
        id: __bgLoader
        anchors.fill: parent
        sourceComponent: control.bgDelegate
    }

    Loader {
        id: __contentLoader
        anchors.fill: parent
        sourceComponent: control.contentDelegate
    }
}
