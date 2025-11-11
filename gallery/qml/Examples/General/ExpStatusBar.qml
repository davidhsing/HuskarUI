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
# HusStatusBar 状态栏\n
状态栏组件,用于在窗口底部显示应用程序状态信息。\n
* **继承自 { Item }**\n
\n<br/>
\n### 支持的属性：\n
属性名 | 类型 | 默认值 | 描述
------ | --- | :---: | ---
animationEnabled | bool | HusTheme.animationEnabled | 是否开启动画
model | var | [] | 状态栏数据模型数组
colorBg | color | HusTheme.Primary.colorBgContainer | 背景颜色
defaultColorText | color | HusTheme.Primary.colorText | 默认文本颜色
defaultFontSize | int | HusTheme.Primary.fontPrimarySize | 默认字体大小
defaultLeftMargin | int | 10 | 默认左边距
defaultRightMargin | int | 10 | 默认右边距
defaultElide | int | Text.ElideRight | 默认文本省略方式
radiusBg | int | 0 | 背景圆角半径
\n<br/>
\n###  Model 参数说明：\n
属性名 | 类型 | 可选/必选 | 描述
------ | --- | :---: | ---
text | string | 是 | 显示的文本内容
width | int | 是 | 格子宽度,负数表示填充剩余空间
align | enum | 否 | 文本对齐方式: Align_Left / Align_Center / Align_Right
colorText | color | 否 | 文本颜色,优先级高于 defaultColorText
fontSize | int | 否 | 字体大小,优先级高于 defaultFontSize
leftMargin | int | 否 | 左边距,优先级高于 defaultLeftMargin
rightMargin | int | 否 | 右边距,优先级高于 defaultRightMargin
| elide | enum | 否 | 文本省略方式,优先级高于 defaultElide
                       `)
        }

        Description {
            title: qsTr('何时使用')
            desc: qsTr('- 需要在窗口底部显示多个状态信息时\n- 需要分格显示不同类型的状态数据时\n- 需要自定义每个格子的样式和对齐方式时')
        }

        ThemeToken {
            source: 'HusStatusBar'
        }

        Description {
            title: qsTr('代码演示')
        }

        CodeBox {
            width: parent.width
            expTitle: qsTr('基础用法')
            desc: qsTr('最简单的用法,通过 `model` 数组定义状态栏的各个格子。')
            code:
                `import QtQuick
import HuskarUI.Basic

HusStatusBar {
    model: [
        { text: "就绪", width: -1 },
        { text: "v1.0.0", width: 100 },
        { text: "192.168.1.1", width: 150 },
        { text: Qt.formatDateTime(new Date(), "yyyy-MM-dd"), width: 90 }
    ]
}`
            exampleDelegate: HusStatusBar {
                model: [
                    { text: "就绪", width: -1 },
                    { text: "v1.0.0", width: 100 },
                    { text: "192.168.1.1", width: 150 },
                    { text: Qt.formatDateTime(new Date(), "yyyy-MM-dd"), width: 90 }
                ]
            }
        }

        CodeBox {
            expTitle: qsTr('自定义对齐方式')
            desc: qsTr('通过 `align` 属性指定每个格子的文本对齐方式,支持 `HusStatusBar.Align_Left`、`HusStatusBar.Align_Center`、`HusStatusBar.Align_Right`。')
            code:
                `import QtQuick
import HuskarUI.Basic

HusStatusBar {
    model: [
        {
            text: "左对齐",
            width: 200,
            align: HusStatusBar.Align_Left
        },
        {
            text: "居中对齐",
            width: -1,
            align: HusStatusBar.Align_Center
        },
        {
            text: "右对齐",
            width: 200,
            align: HusStatusBar.Align_Right
        }
    ]
}`
            exampleDelegate: HusStatusBar {
                model: [
                    { text: "左对齐", width: 200, align: HusStatusBar.Align_Left },
                    { text: "居中对齐", width: -1, align: HusStatusBar.Align_Center },
                    { text: "右对齐", width: 200, align: HusStatusBar.Align_Right }
                ]
            }
        }

        CodeBox {
            width: parent.width
            expTitle: qsTr('自定义样式')
            desc: qsTr('通过 `colorText`、`fontSize`、`leftMargin`、`rightMargin` 等属性自定义每个格子的样式。')
            code:
                `import QtQuick
import HuskarUI.Basic

HusStatusBar {
    defaultFontSize: 14

    model: [
        {
            text: "用户名",
            width: -1,
            colorText: "#1890ff",
            fontSize: 16,
            leftMargin: 15
        },
        {
            text: "v2.0.0",
            width: 100,
            align: HusStatusBar.Align_Center,
            colorText: "#52c41a",
            fontSize: 14
        },
        {
            text: "192.168.1.100",
            width: 150,
            align: HusStatusBar.Align_Right,
            rightMargin: 20
        },
        {
            text: Qt.formatDateTime(new Date(), "yyyy-MM-dd"),
            width: 90,
            align: HusStatusBar.Align_Center,
            fontSize: 12
        }
    ]
}`
            exampleDelegate: HusStatusBar {
                defaultFontSize: 14

                model: [
                    {
                        text: "用户名",
                        width: -1,
                        colorText: "#1890ff",
                        fontSize: 16,
                        leftMargin: 15
                    },
                    {
                        text: "v2.0.0",
                        width: 100,
                        align: HusStatusBar.Align_Center,
                        colorText: "#52c41a",
                        fontSize: 14
                    },
                    {
                        text: "192.168.1.100",
                        width: 150,
                        align: HusStatusBar.Align_Right,
                        rightMargin: 20
                    },
                    {
                        text: Qt.formatDateTime(new Date(), "yyyy-MM-dd"),
                        width: 90,
                        align: HusStatusBar.Align_Center,
                        fontSize: 12
                    }
                ]
            }
        }
    }
}
