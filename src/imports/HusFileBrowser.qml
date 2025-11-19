import QtQuick
import QtQuick.Layouts
import QtQuick.Dialogs
import HuskarUI.Basic

Item {
    id: control

    enum BrowserType {
        Browser_File,
        Browser_Files,
        Browser_Folder
    }

    property int browserType: HusFileBrowser.Browser_File
    property string inputText: ''
    property string inputPlaceholder: ''
    property bool inputEnabled: true
    property bool inputReadOnly: false
    property bool buttonEnabled: true
    property string buttonText: qsTr('浏览')
    property int buttonType: HusButton.Type_Default
    property var buttonIconSource: 0 ?? ''
    property int buttonWidth: 80
    property int spacing: 8
    property bool convertLocal: true
    property string pathJoiner: ';'

    // Delegates
    property Component inputDelegate: HusInput { }
    property Component buttonDelegate: HusIconButton { }

    implicitWidth: parent.width
    implicitHeight: __layout.implicitHeight

    signal pathSelected(string path)
    signal pathsSelected(var paths)
    signal textChanged(string text)

    RowLayout {
        id: __layout
        anchors.fill: parent
        spacing: control.spacing

        Loader {
            id: __inputLoader
            Layout.fillWidth: true
            sourceComponent: control.inputDelegate
            onLoaded: {
                item.text = Qt.binding(() => control.inputText);
                item.placeholderText = Qt.binding(() => control.inputPlaceholder);
                item.enabled = Qt.binding(() => control.inputEnabled);
                item.readOnly = Qt.binding(() => control.inputReadOnly);
                item.textChanged.connect(() => {
                    control.inputText = item.text;
                    control.textChanged(item.text);
                });
            }
        }

        Loader {
            id: __buttonLoader
            sourceComponent: control.buttonDelegate
            Layout.preferredWidth: control.buttonWidth
            onLoaded: {
                item.text = Qt.binding(() => control.buttonText);
                item.iconSource = Qt.binding(() => control.buttonIconSource);
                item.enabled = Qt.binding(() => control.buttonEnabled);
                item.type = Qt.binding(() => control.buttonType);
                item.clicked.connect(__openDialog);
            }
        }
    }

    FileDialog {
        id: __fileDialog
        visible: false
        fileMode: (control.browserType === HusFileBrowser.Browser_Files) ? FileDialog.OpenFiles : FileDialog.OpenFile
        onAccepted: {
            if (control.browserType === HusFileBrowser.Browser_Files) {
                const paths = selectedFiles.map(url => control.convertLocal ? __urlToLocalFile(url) : url.toString());
                control.inputText = paths.join(control.pathJoiner);
                control.pathsSelected(paths);
            } else {
                control.inputText = control.convertLocal ? __urlToLocalFile(selectedFile) : selectedFile.toString();
                control.pathSelected(control.inputText);
            }
        }
    }

    FolderDialog {
        id: __folderDialog
        visible: false
        onAccepted: {
            control.inputText = control.convertLocal ? __urlToLocalFile(selectedFolder.toString()) : selectedFolder.toString();
            control.pathSelected(control.inputText);
        }
    }

    function __openDialog() {
        if (control.browserType === HusFileBrowser.Browser_Folder) {
            __folderDialog.open();
        } else {
            __fileDialog.open();
        }
    }

    function __urlToLocalFile(url) {
        if (!url) {
            return url;
        }
        let urlString = (typeof url === 'string') ? url : url.toString();
        if (!urlString.startsWith('file:///')) {
            return urlString;
        }
        urlString = urlString.replace(/^file:\/\/\//, Qt.platform.os === 'windows' ? '' : '/');
        urlString = urlString.replace(/\//g, (Qt.platform.os === 'windows') ? '\\' : '/');
        return urlString;
    }
}
