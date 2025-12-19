import QtQuick
import HuskarUI.Basic

import '../../Controls'

Flickable {
    contentHeight: column.height
    HusScrollBar.vertical: HusScrollBar { }

    Column {
        id: column
        width: parent.width - 15
        spacing: 30

        Description {
            desc: qsTr(`
# HusShield 徽章 \n
类似 GitHub Shields 的徽章组件。\n
* **继承自 { Item }**\n
\n<br/>
\n### 支持的代理：\n
- **leftDelegate: Component** 左侧代理\n
- **rightDelegate: Component** 右侧代理\n
\n<br/>
\n### 支持的属性：\n
属性名 | 类型 | 默认值 | 描述
------ | --- | :---: | ---
animationEnabled | bool | HusTheme.animationEnabled | 是否开启动画
leftEnabled | bool | true | 是否显示左侧
rightEnabled | bool | true | 是否显示右侧
leftText | string | - | 左侧文本
rightText | string | - | 右侧文本
leftFont | font | - | 左侧字体
rightFont | font | - | 右侧字体
colorLeftBg | color | - | 左侧背景色
colorRightBg | color | - | 右侧背景色
colorLeftText | color | - | 左侧文本颜色
colorRightText | color | - | 右侧文本颜色
radiusBg | [HusRadius](internal://HusRadius) | 4 | 圆角值
\n<br/>
                       `)
        }

        Description {
            title: qsTr('何时使用')
            desc: qsTr(`
需要显示一个徽章时。\n
                       `)
        }

        ThemeToken {
            source: 'HusShield'
        }

        Description {
            title: qsTr('代码演示')
        }

        CodeBox {
            width: parent.width
            descTitle: qsTr('基本用法')
            desc: qsTr(`
最简单的用法。\n
通过 \`leftText\` 属性设置左侧文本。\n
通过 \`rightText\` 属性设置右侧文本。\n
                       `)
            code: `
import QtQuick
import HuskarUI.Basic

Column {
    width: parent.width
    spacing: 20

    HusShield {
        leftText: 'HuskarUI'
        rightText: 'v0.5.0'
    }

    HusShield {
        leftText: 'License'
        rightText: 'MIT'
    }
}
            `
            exampleDelegate: Column {
                width: parent.width
                spacing: 20

                HusShield {
                    leftText: 'HuskarUI'
                    rightText: 'v0.5.0'
                }

                HusShield {
                    leftText: 'License'
                    rightText: 'MIT'
                }
            }
        }


        CodeBox {
            width: parent.width
            descTitle: qsTr('自定义图标')
            desc: qsTr(`
通过代理来自定义图标。\n
通过 \`leftDelegate\` 属性设置左侧代理。\n
通过 \`rightDelegate\` 属性设置右侧代理。\n
                       `)
            code: `
import QtQuick
import HuskarUI.Basic

Column {
    width: parent.width
    spacing: 20

    HusShield {
        leftDelegate: Row {
            spacing: 4
            HusIconText {
                iconSource: HusIcon.GithubOutlined
                iconSize: 16
                colorIcon: '#fff'
            }
            HusText {
                text: 'GitHub'
                color: '#fff'
                font.pixelSize: 12
            }
        }
        rightText: 'Stars'
    }
}
            `
            exampleDelegate: Column {
                width: parent.width
                spacing: 20

                HusShield {
                    leftDelegate: Row {
                        spacing: 4
                        HusIconText {
                            iconSource: HusIcon.GithubOutlined
                            iconSize: 16
                            colorIcon: '#fff'
                        }
                        HusText {
                            text: 'GitHub'
                            color: '#fff'
                            font.pixelSize: 12
                        }
                    }
                    rightText: 'Stars'
                }
            }
        }
    }
}
