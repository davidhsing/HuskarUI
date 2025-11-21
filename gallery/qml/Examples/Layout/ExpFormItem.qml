import QtQuick
import QtQuick.Controls.Basic
import HuskarUI.Basic

import '../../Controls'

Flickable {
    contentHeight: column.height
    ScrollBar.vertical: HusScrollBar { }

    Column {
        id: column
        width: parent.width - 15
        spacing: 30

        Description {
            desc: qsTr(`
# HusFormItem 表单项
表单项组件，用于包装输入组件并提供标签、验证反馈等功能。
* **继承自 { [Item](internal://Item) }**

\n<br/>
\n### 支持的代理：\n
- **contentDelegate: Component** 内容代理\n
\n### 支持的属性：
属性名 | 类型 | 默认值 | 描述
------ | --- | :---: | ---
animationEnabled | bool | HusTheme.animationEnabled | 是否启用动画
layout | int | HusFormItem.Layout_Vertical | 布局方式（来自 HusFormItem）
label | string | '' | 标签文本
labelAlign | int | Text.AlignLeft | 标签文本对齐方式（Text.AlignLeft/AlignRight/AlignHCenter）
required | bool | false | 是否必填，为 true 时标签前显示红色 *
requiredSpacing | int | 4 | 红色 * 与标签的间距
colonText | string | ':' | 标签末尾分隔符文本
showColon | bool | true | 是否显示标签末尾分隔符
labelWidth | int | 80 | 水平布局时标签宽度
labelSpacing | int | 4 | 标签与输入组件的间距
feedbackSpacing | int | 2 | 输入组件与反馈文本的间距
showEmptyFeedback | bool | true | 当反馈文本为空时，依然保留反馈文本的区域
topMargin | int | 0 | 上边距
bottomMargin | int | 0 | 下边距
leftMargin | int | 0 | 左边距
rightMargin | int | 0 | 右边距
validator | function | - | 验证函数，参数为任意自定义对象，返回 {valid: bool, message: string} 或 boolean 或 undefined
colorLabel | color | HusTheme.Primary.colorTextBase | 标签颜色
colorLabelRequired | color | HusTheme.Primary.colorError | 必填星号颜色
colorFeedbackSuccess | color | HusTheme.Primary.colorSuccess | 成功状态颜色
colorFeedbackError | color | HusTheme.Primary.colorError | 错误状态颜色
\n<br/>
\n### 支持的函数：
- \`validate()\` 执行验证，返回 bool 表示是否通过
\n<br/>
\n### 枚举：
- \`HusFormItem.Layout_Vertical\` 垂直布局
- \`HusFormItem.Layout_Horizontal\` 水平布局
- \`HusFormItem.Validation_None\` 无验证状态
- \`HusFormItem.Validation_Success\` 验证成功
- \`HusFormItem.Validation_Error\` 验证失败
            `)
        }

        Description {
            title: qsTr('何时使用')
            desc: qsTr(`
- 需要统一管理表单项的布局和样式时
            `)
        }

        ThemeToken {
            source: 'HusFormItem'
        }

        Description {
            title: qsTr('代码演示')
        }

        CodeBox {
            width: parent.width
            descTitle: qsTr('基础用法')
            desc: qsTr(`最基本的表单项，包含标签和输入组件。`)
            code: `
import QtQuick
import HuskarUI.Basic

Column {
    spacing: 2

    HusFormItem {
        label: "用户名"
        width: parent.width

        HusInput {
            width: parent.width
            placeholderText: "请输入用户名"
        }
    }
}
            `
            exampleDelegate: Column {
                spacing: 2

                HusFormItem {
                    label: "用户名"
                    width: parent.width

                    HusInput {
                        width: parent.width
                        placeholderText: "请输入用户名"
                    }
                }
            }
        }

        CodeBox {
            width: parent.width
            descTitle: qsTr('表单验证')
            desc: qsTr(`
通过 \`validator\` 属性提供验证函数，参数为空或任意自定义对象，返回 \`{valid: bool, message: string}\` 对象来显示验证反馈。
            `)
            code: `
import QtQuick
import HuskarUI.Basic

Column {
    spacing: 2

    HusFormItem {
        id: usernameItem
        width: parent.width
        required: true
        label: "用户名"
        validator: function() {
            if (!username.text) {
                return {
                    valid: false,
                    message: "用户名不能为空"
                };
            }
            if (username.text.length < 3) {
                return {
                    valid: false,
                    message: "用户名至少3个字符"
                };
            }
            return {
                valid: true,
                message: "用户名可用"
            };
        }

        HusInput {
            id: username
            width: parent.width
            placeholderText: "请输入用户名"
            onTextChanged: usernameItem.validate()
        }
    }

    HusFormItem {
        id: emailItem
        width: parent.width
        required: true
        label: "邮箱"
        validator: function() {
            if (!email.text) {
                return {
                    valid: false,
                    message: "邮箱不能为空"
                };
            }
            const emailRegex = /^[^\\s@]+@[^\\s@]+\\.[^\\s@]+$/;
            if (!emailRegex.test(email.text)) {
                return {
                    valid: false,
                    message: "邮箱格式不正确"
                };
            }
            return {
                valid: true,
                message: "邮箱格式正确"
            };
        }

        HusInput {
            id: email
            width: parent.width
            placeholderText: "请输入邮箱"
            onTextChanged: emailItem.validate()
        }
    }
}
            `
            exampleDelegate: Column {
                spacing: 2

                HusFormItem {
                    id: usernameItem
                    width: parent.width
                    required: true
                    label: "用户名"
                    validator: function() {
                        if (!username.text) {
                            return {
                                valid: false,
                                message: "用户名不能为空"
                            };
                        }
                        if (username.text.length < 3) {
                            return {
                                valid: false,
                                message: "用户名至少3个字符"
                            };
                        }
                        return {
                            valid: true,
                            message: "用户名可用"
                        };
                    }

                    HusInput {
                        id: username
                        width: parent.width
                        placeholderText: "请输入用户名"
                        onTextChanged: usernameItem.validate()
                    }
                }

                HusFormItem {
                    id: emailItem
                    width: parent.width
                    required: true
                    label: "邮箱"
                    validator: function() {
                        if (!email.text) {
                            return {
                                valid: false,
                                message: "邮箱不能为空"
                            };
                        }
                        const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
                        if (!emailRegex.test(email.text)) {
                            return {
                                valid: false,
                                message: "邮箱格式不正确"
                            };
                        }
                        return {
                            valid: true,
                            message: "邮箱格式正确"
                        };
                    }

                    HusInput {
                        id: email
                        width: parent.width
                        placeholderText: "请输入邮箱"
                        onTextChanged: emailItem.validate()
                    }
                }
            }
        }
    }
}
