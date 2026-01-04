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
# HusMaskOverlay 遮罩层\n
HusMaskOverlay 是一个独立的遮罩层组件，提供半透明背景覆盖效果。\n
* **继承自 { [HusRectangle](internal://HusRectangle) }**\n
                       `)
        }

        Description {
            title: qsTr('何时使用')
            desc: qsTr(`  
- 需要创建模态遮罩效果时  
- 需要禁用背景交互时  
- 需要突出显示前景内容时  
- 作为自定义模态组件的背景层  
            `)
        }

        ThemeToken {
            source: 'HusMaskOverlay'
        }

        Description {
            title: qsTr('代码演示')
        }

        CodeBox {
            width: parent.width
            descTitle: qsTr("基础用法")
            desc: qsTr(`  
最简单的遮罩层使用，覆盖整个顶层容器。\n
可以通过 'parent' 属性更改要覆盖的容器。 
            `)
            code: `  
import QtQuick  
import HuskarUI.Basic  
  
Item {
    width: parent.width
    height: 50

    HusButton {
        text: '打开遮罩层'
        onClicked: {
            maskOverlay.visible = true
        }
    }

    HusMaskOverlay {
        id: maskOverlay
        closable: true
        onMaskClicked: {
            messageApi.success('遮罩层被点击');
        }
    }

    HusMessage {
        id: messageApi
        z: 999
        parent: galleryWindow.captionBar
        width: parent.width
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.bottom
    }
}
            `
            exampleDelegate: Item {
                width: parent.width
                height: 50

                HusButton {
                    text: '打开遮罩层'
                    onClicked: {
                        maskOverlay.visible = true
                    }
                }

                HusMaskOverlay {
                    id: maskOverlay
                    closable: true
                    onMaskClicked: {
                        messageApi.success('遮罩层被点击');
                    }
                }

                HusMessage {
                    id: messageApi
                    z: 999
                    parent: galleryWindow.captionBar
                    width: parent.width
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.top: parent.bottom
                }
            }
        }
    }
}
