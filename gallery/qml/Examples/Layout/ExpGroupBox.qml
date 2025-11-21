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
# HusGroupBox 分组框
用于将相关内容组织在一起的分组框。
* **继承自 { [Item](internal://Item) }**

\n<br/>
\n### 支持的代理：\n
- **titleDelegate: Component** 标题代理\n
- **borderDelegate: Component** 边框代理\n
\n### 支持的属性：
属性名 | 类型 | 默认值 | 描述
------ | --- | :---: | ---
animationEnabled | bool | HusTheme.animationEnabled | 是否启用动画
title | string | '' | 标题文本 |
titlePosition | enum | Position_Top | 标题位置(Position_Top/Position_Bottom)（来自 HusGroupBox）
titleAlign | enum | Align_Left | 标题对齐方式(Align_Left/Align_Center/Align_Right)（来自 HusGroupBox）
titlePadding | int | 20 | 标题距离边框的水平距离
titleLeftPadding | int | 4 | 标题左侧内边距
titleRightPadding | int | 4 | 标题右侧内边距
titleFont | font | - | 标题字体
borderWidth | int | 1 | 边框宽度
colorTitle | color | - | 标题颜色
colorBorder | color | - | 边框颜色
colorBg | color | - | 背景颜色
radiusBg | HusRadius | - | 圆角半径
contentMargins | int | 12 | 内容区域统一边距
contentTopMargin | int | - | 内容区域顶部边距(标题在顶部时为15)
contentBottomMargin | int | - | 内容区域底部边距(标题在底部时为15)
contentLeftMargin | int | - | 内容区域左侧边距
contentRightMargin | int | - | 内容区域右侧边距
\n<br/>
            `)
        }

        Description {
            title: qsTr('何时使用')
            desc: qsTr(`
- 需要管理表单项，将相关内容组织在一起时
            `)
        }

        ThemeToken {
            source: 'HusGroupBox'
        }

        Description {
            title: qsTr('代码演示')
        }

        CodeBox {
            width: parent.width
            descTitle: qsTr("基础用法")
            desc: qsTr("最简单的用法,默认标题在顶部左对齐。")
            code: `
HusGroupBox {
    width: 300
    height: 200
    title: "用户信息"

    Column {
        width: parent.width
        spacing: 10

        HusText { text: "姓名: 张三" }
        HusText { text: "年龄: 25" }
        HusText { text: "职业: 软件工程师" }
    }
}`
            exampleDelegate: HusGroupBox {
                width: 300
                height: 200
                title: qsTr("用户信息")

                Column {
                    width: parent.width
                    spacing: 10

                    HusText { text: qsTr("姓名: 张三") }
                    HusText { text: qsTr("年龄: 25") }
                    HusText { text: qsTr("职业: 软件工程师") }
                }
            }
        }

        CodeBox {
            width: parent.width
            descTitle: qsTr("标题位置")
            desc: qsTr("可以设置标题在顶部或底部。")
            code: `
Row {
    width: parent.width
    spacing: 20

    HusGroupBox {
        width: 250
        height: 150
        title: "顶部标题"
        titlePosition: HusGroupBox.Position_Top

        HusText {
            anchors.centerIn: parent
            text: "标题在顶部"
        }
    }

    HusGroupBox {
        width: 250
        height: 150
        title: "底部标题"
        titlePosition: HusGroupBox.Position_Bottom

        HusText {
            anchors.centerIn: parent
            text: "标题在底部"
        }
    }
}`
            exampleDelegate: Row {
                width: parent.width
                spacing: 20

                HusGroupBox {
                    width: 250
                    height: 150
                    title: qsTr("顶部标题")
                    titlePosition: HusGroupBox.Position_Top

                    HusText {
                        anchors.centerIn: parent
                        text: qsTr("标题在顶部")
                    }
                }

                HusGroupBox {
                    width: 250
                    height: 150
                    title: qsTr("底部标题")
                    titlePosition: HusGroupBox.Position_Bottom

                    HusText {
                        anchors.centerIn: parent
                        text: qsTr("标题在底部")
                    }
                }
            }
        }

        CodeBox {
            width: parent.width
            descTitle: qsTr("标题对齐")
            desc: qsTr("可以设置标题左对齐、居中或右对齐。")
            code: `
Column {
    width: parent.width
    spacing: 20

    HusGroupBox {
        width: 400
        height: 100
        title: "左对齐"
        titleAlign: HusGroupBox.Align_Left

        HusText {
            anchors.centerIn: parent
            text: "标题左对齐"
        }
    }

    HusGroupBox {
        width: 400
        height: 100
        title: "居中对齐"
        titleAlign: HusGroupBox.Align_Center

        HusText {
            anchors.centerIn: parent
            text: "标题居中对齐"
        }
    }

    HusGroupBox {
        width: 400
        height: 100
        title: "右对齐"
        titleAlign: HusGroupBox.Align_Right

        HusText {
            anchors.centerIn: parent
            text: "标题右对齐"
        }
    }
}`
            exampleDelegate: Column {
                width: parent.width
                spacing: 20

                HusGroupBox {
                    width: 400
                    height: 100
                    title: qsTr("左对齐")
                    titleAlign: HusGroupBox.Align_Left

                    HusText {
                        anchors.centerIn: parent
                        text: qsTr("标题左对齐")
                    }
                }

                HusGroupBox {
                    width: 400
                    height: 100
                    title: qsTr("居中对齐")
                    titleAlign: HusGroupBox.Align_Center

                    HusText {
                        anchors.centerIn: parent
                        text: qsTr("标题居中对齐")
                    }
                }

                HusGroupBox {
                    width: 400
                    height: 100
                    title: qsTr("右对齐")
                    titleAlign: HusGroupBox.Align_Right

                    HusText {
                        anchors.centerIn: parent
                        text: qsTr("标题右对齐")
                    }
                }
            }
        }
    }
}
