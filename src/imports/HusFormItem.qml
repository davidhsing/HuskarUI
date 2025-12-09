import QtQuick
import QtQuick.Layouts
import HuskarUI.Basic

Item {
    id: control

    // 枚举定义
    enum Layout {
        Layout_Vertical = 0,
        Layout_Horizontal = 1
    }

    enum ValidationStatus {
        Validation_None = 0,
        Validation_Success = 1,
        Validation_Error = 2
    }

    // 基础属性
    property bool animationEnabled: HusTheme.animationEnabled
    property bool required: false
    property int requiredSpacing: 4
    property string label: ''
    property int labelAlign: Text.AlignLeft
    property string colonText: ':'
    property bool showColon: false
    property int layout: HusFormItem.Layout_Vertical
    property int labelWidth: 80
    property int labelSpacing: 4
    property int feedbackSpacing: 2
    property bool showEmptyFeedback: true
    property int topMargin: 0
    property int bottomMargin: 0
    property int leftMargin: 0
    property int rightMargin: 0

    // 验证相关
    property var validator: null  // 接受无参数函数: () => ({valid: bool, message: string}) | bool | undefined

    // 主题
    property var themeSource: HusTheme.HusFormItem
    property color colorLabel: themeSource.colorLabel
    property color colorLabelRequired: themeSource.colorLabelRequired
    property color colorFeedbackSuccess: themeSource.colorFeedbackSuccess
    property color colorFeedbackError: themeSource.colorFeedbackError

    // 默认内容
    default property alias contentDelegate: __contentItem.data

    objectName: '__HusFormItem__'
    implicitWidth: __mainLoader.implicitWidth
    implicitHeight: __mainLoader.implicitHeight

    QtObject {
        id: __private
        property int validationStatus: HusFormItem.Validation_None
        property string feedbackText: ''

        function validateInternal(param) {
            if (typeof control.validator !== 'function') {
                __private.validationStatus = HusFormItem.Validation_None;
                __private.feedbackText = '';
                return;
            }
            try {
                // 调用 validator，如果提供了参数则传递参数，否则不传参数
                let result = (arguments.length > 0) ? control.validator(param) : control.validator();
                // 处理 undefined 返回值 - 清空反馈
                if (result === undefined) {
                    __private.validationStatus = HusFormItem.Validation_None;
                    __private.feedbackText = '';
                    return;
                }
                // 支持返回布尔值
                if (typeof result === 'boolean') {
                    __private.validationStatus = result ? HusFormItem.Validation_Success : HusFormItem.Validation_Error;
                    __private.feedbackText = result ? qsTr('校验通过') : qsTr('校验不通过');
                }
                // 支持返回对象 {valid: bool, message: string}
                else if (typeof result === 'object' && result !== null) {
                    __private.validationStatus = result.valid ? HusFormItem.Validation_Success : HusFormItem.Validation_Error;
                    __private.feedbackText = result.message || '';
                }
            } catch (ex) {
                console.error('HusFormItem Validation error:', ex);
                __private.validationStatus = HusFormItem.Validation_Error;
                __private.feedbackText = qsTr('验证出错');
            }
        }
    }

    // 主布局加载器
    Loader {
        id: __mainLoader
        anchors.fill: parent
        sourceComponent: (control.layout === HusFormItem.Layout_Vertical) ? __verticalComponent : __horizontalComponent
    }

    // 垂直布局组件
    Component {
        id: __verticalComponent
        ColumnLayout {
            spacing: 0
            anchors.topMargin: control.topMargin
            anchors.bottomMargin: control.bottomMargin
            anchors.leftMargin: control.leftMargin
            anchors.rightMargin: control.rightMargin

            // 标签
            Loader {
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.alignment: Qt.AlignHCenter
                sourceComponent: __labelComponent
            }

            // 标签间距
            Item {
                height: control.labelSpacing
                Layout.fillWidth: true
            }

            // 内容和反馈
            ColumnLayout {
                spacing: control.feedbackSpacing
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.alignment: Qt.AlignTop

                // 内容区域
                Item {
                    id: __verticalContentArea
                    Layout.fillWidth: true
                    Layout.alignment: Qt.AlignTop
                    Layout.preferredHeight: childrenRect ? childrenRect.height : 0
                    Component.onCompleted: {
                        for (let i = 0; i < __contentItem.data.length; i++) {
                            __contentItem.data[i].parent = __verticalContentArea;
                        }
                    }
                }

                // 反馈文本
                Loader {
                    Layout.fillWidth: true
                    Layout.alignment: Qt.AlignTop
                    sourceComponent: __feedbackComponent
                }
            }
        }
    }

    // 水平布局组件
    Component {
        id: __horizontalComponent
        RowLayout {
            spacing: control.labelSpacing
            anchors.topMargin: control.topMargin
            anchors.bottomMargin: control.bottomMargin
            anchors.leftMargin: control.leftMargin
            anchors.rightMargin: control.rightMargin

            // 标签区域
            Loader {
                Layout.preferredWidth: control.labelWidth
                Layout.fillHeight: true
                Layout.alignment: Qt.AlignVCenter
                sourceComponent: __labelComponent
            }

            // 内容和反馈列
            ColumnLayout {
                Layout.fillWidth: true
                Layout.fillHeight: true
                spacing: control.feedbackSpacing

                // 内容区域
                Item {
                    id: __horizontalContentArea
                    Layout.fillWidth: true
                    Layout.preferredHeight: childrenRect ? childrenRect.height : 0
                    Component.onCompleted: {
                        for (let i = 0; i < __contentItem.data.length; i++) {
                            __contentItem.data[i].parent = __horizontalContentArea;
                        }
                    }
                }

                // 反馈文本
                Loader {
                    Layout.fillWidth: true
                    Layout.alignment: Qt.AlignTop
                    sourceComponent: __feedbackComponent
                }
            }
        }
    }

    // 子组件容器（隐藏）
    Item {
        id: __contentItem
        width: parent.width
        visible: false
    }

    // 标签组件
    Component {
        id: __labelComponent
        RowLayout {
            visible: !!control.colorLabel
            spacing: control.required ? control.requiredSpacing : 0
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.alignment: Qt.AlignVCenter

            // 必填星号
            HusText {
                text: '*'
                color: control.colorLabelRequired
                font {
                    family: control.themeSource.fontLabelFamily
                    pixelSize: control.themeSource.fontLabelSize
                }
                visible: control.required
                Layout.alignment: Qt.AlignVCenter
            }

            // 标签文本
            HusText {
                text: control.label + (control.showColon ? control.colonText : '')
                color: control.colorLabel
                font {
                    family: control.themeSource.fontLabelFamily
                    pixelSize: control.themeSource.fontLabelSize
                }
                horizontalAlignment: control.labelAlign
                visible: !!control.label
                Layout.alignment: Qt.AlignVCenter
                Layout.fillWidth: true
            }
        }
    }

    // 反馈文本组件
    Component {
        id: __feedbackComponent
        HusText {
            opacity: visible ? 1 : 0
            text: __private.feedbackText
            color: {
                switch (__private.validationStatus) {
                    case HusFormItem.Validation_Success:
                        return control.colorFeedbackSuccess;
                    case HusFormItem.Validation_Error:
                        return control.colorFeedbackError;
                    default:
                        return control.themeSource.colorFeedbackNormal;
                }
            }
            font {
                family: control.themeSource.fontFeedbackFamily
                pixelSize: control.themeSource.fontFeedbackSize
            }
            visible: !!__private.feedbackText || control.showEmptyFeedback

            Behavior on opacity {
                enabled: control.animationEnabled
                NumberAnimation { duration: HusTheme.Primary.durationFast }
            }

            Behavior on color {
                enabled: control.animationEnabled
                ColorAnimation { duration: HusTheme.Primary.durationMid }
            }
        }
    }

    // 公开的验证方法 - 校验所有一级子组件
    function validate(param) {
        let allValid = true;
        for (let i = 0; i < __contentItem.children.length; i++) {
            const child = __contentItem.children[i];
            // 如果子组件也有 validate 方法（例如嵌套的 FormItem），递归调用
            if (child.hasOwnProperty('validate') && typeof child.validate === 'function') {
                if (!child.validate(param)) {
                    allValid = false;
                }
            }
        }
        // 执行当前组件的验证
        __private.validateInternal(param);
        // 检查当前组件的验证状态
        if (__private.validationStatus === HusFormItem.Validation_Error) {
            allValid = false;
        }
        return allValid;
    }
}
