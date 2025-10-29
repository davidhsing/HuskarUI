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
# HusQrCode 二维码 \n
显示一个二维码。\n
* **继承自 { Item }**\n
\n<br/>
\n### 支持的属性：\n
属性名 | 类型 | 默认值 | 描述
------ | --- | :---: | ---
content | string | - | 文本内容
colorBackground | color | HusTheme.Primary.colorBgContainer | 背景颜色
colorForeground | color | HusTheme.Primary.colorTextPrimary | 文本颜色
eccLevel | int | HusQrCode.ECC_LEVEL_L | 二维码的纠错级别(来自 HusQrCode)
padding | int | 2 | 到边缘的间距级别
rawWidth | int | 500 | 图片的原始宽度(会缩放到组件的宽度)
rawHeight | int | 500 | 图片的原始高度(会缩放到组件的高度)
rawSource | string | - | 图片的原始源(data:image格式,只读)
\n<br/>
                       `)
        }

        Description {
            title: qsTr('何时使用')
            desc: qsTr(`
需要显示二维码的场景。\n
                       `)
        }

        ThemeToken {
            source: 'HusQrCode'
        }

        Description {
            title: qsTr('代码演示')
        }

        CodeBox {
            width: parent.width
            expTitle: '基本用法'
            desc: '一个简单的二维码。'
            code: `
                import QtQuick
                import HuskarUI.Basic

                HusQrCode {
                    width: 250
                    height: 250
                    content: 'Hello world, welcome to use the QRCode'
                }
            `
            exampleDelegate: Item {
                width: 256
                height: 256

                HusQrCode {
                    content: 'Hello world, welcome to use the QRCode'
                }
            }
        }
    }
}
