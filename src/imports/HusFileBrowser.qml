import QtQuick
import QtQuick.Layouts
import QtQuick.Dialogs
import HuskarUI.Basic

Item {
    id: control

    enum BrowserMode {
        ModeOpenFile,
        ModeOpenFiles,
        ModeOpenFolder,
        ModeSaveFile
    }

    property int mode: HusFileBrowser.ModeOpenFile
    property string defaultFolder: ''
    property string inputText: ''
    property string inputPlaceholder: ''
    property bool inputEnabled: true
    property bool inputReadOnly: false
    property bool inputReadOnlyBg: false
    property bool buttonEnabled: true
    property string buttonText: qsTr('浏览')
    property int buttonType: control.danger ? HusButton.TypeOutlined : HusButton.TypeDefault
    property var buttonIconSource: 0 ?? ''
    property int buttonWidth: 80
    property bool danger: false
    property int spacing: 8
    property bool convertLocal: true
    property string initFolder: ''
    property alias defaultSuffix: __fileDialog.defaultSuffix
    property alias nameFilters: __fileDialog.nameFilters
    property string pathJoiner: ';'

    // Delegates
    property Component inputDelegate: HusInput {
        text: control.inputText
        placeholderText: control.inputPlaceholder
        enabled: control.inputEnabled
        readOnly: control.inputReadOnly
        readOnlyBg: control.inputReadOnlyBg
        danger: control.danger
    }
    property Component buttonDelegate: HusIconButton {
        text: control.buttonText
        iconSource: control.buttonIconSource
        enabled: control.buttonEnabled
        type: control.buttonType
        danger: control.danger
    }

    implicitWidth: parent.width
    implicitHeight: __layout.implicitHeight

    signal pathSelected(path: string)
    signal pathsSelected(paths: var)

    RowLayout {
        id: __layout
        anchors.fill: parent
        spacing: control.spacing

        Loader {
            id: __inputLoader
            Layout.fillWidth: true
            sourceComponent: control.inputDelegate
            onLoaded: {
                // Check if item has properties before binding
                if (item.hasOwnProperty('text') && item.hasOwnProperty('textChanged') && typeof item.textChanged.connect === 'function') {
                    item.textChanged.connect(() => {
                        control.inputText = item.text;
                    });
                }
            }
        }

        Loader {
            id: __buttonLoader
            sourceComponent: control.buttonDelegate
            Layout.preferredWidth: control.buttonWidth
            onLoaded: {
                // Check if item has properties before binding
                if (item.hasOwnProperty('clicked') && typeof item.clicked.connect === 'function') {
                    item.clicked.connect(__private.openDialog);
                }
            }
        }
    }

    FileDialog {
        id: __fileDialog
        visible: false
        fileMode: (control.mode === HusFileBrowser.ModeSaveFile) ? FileDialog.SaveFile : ((control.mode === HusFileBrowser.ModeOpenFile) ? FileDialog.OpenFile : FileDialog.OpenFiles)
        currentFolder: ((control.mode === HusFileBrowser.ModeOpenFile || control.mode === HusFileBrowser.ModeSaveFile) && !!control.inputText) ? Qt.resolvedUrl(__private.urlToUniformFile(control.inputText)) : control.initFolder
        defaultSuffix: control.defaultSuffix
        nameFilters: control.nameFilters
        onAccepted: {
            if (control.mode === HusFileBrowser.ModeOpenFiles) {
                const paths = selectedFiles.map(url => control.convertLocal ? __private.urlToLocalFile(url) : url.toString());
                control.inputText = paths.join(control.pathJoiner);
                control.pathsSelected(paths);
            } else {
                control.inputText = control.convertLocal ? __private.urlToLocalFile(selectedFile) : selectedFile.toString();
                control.pathSelected(control.inputText);
            }
        }
    }

    FolderDialog {
        id: __folderDialog
        visible: false
        currentFolder: control.inputText ? Qt.resolvedUrl(__private.urlToUniformFile(control.inputText)) : control.initFolder
        onAccepted: {
            control.inputText = control.convertLocal ? __private.urlToLocalFile(selectedFolder.toString()) : selectedFolder.toString();
            control.pathSelected(control.inputText);
        }
    }

    QtObject {
        id: __private

        function openDialog(): void {
            if (control.mode === HusFileBrowser.ModeOpenFolder) {
                __folderDialog.open();
            } else {
                __fileDialog.open();
            }
        }

        function urlToLocalFile(url: url): string {
            if (!url) {
                return url;
            }
            let urlString = (typeof url === 'string') ? url : url.toString();
            if (!urlString.startsWith('file:///')) {
                return decodeURIComponent(urlString);
            }
            // 解码 URL 转义字符
            urlString = decodeURIComponent(urlString);
            urlString = urlString.replace(/^file:\/\/\//, Qt.platform.os === 'windows' ? '' : '/');
            urlString = urlString.replace(/\//g, (Qt.platform.os === 'windows') ? '\\' : '/');
            return urlString;
        }

        function urlToUniformFile(path: url): string {
            if (!path) {
                return path;
            }
            let pathString = (typeof path === 'string') ? path : path.toString();
            if (pathString.startsWith('file:///')) {
                return encodeURIComponent(pathString);
            }
            // 编码 URL 转义字符
            return 'file:///' + encodeURIComponent(pathString);
        }
    }
}
