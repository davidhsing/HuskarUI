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
    property string defaultFolder: ''
    property string inputText: ''
    property string inputPlaceholder: ''
    property bool inputEnabled: true
    property bool inputReadOnly: false
    property bool inputReadOnlyBg: false
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
                if (item.hasOwnProperty('text')) {
                    item.text = Qt.binding(() => control.inputText);
                }
                if (item.hasOwnProperty('placeholderText')) {
                    item.placeholderText = Qt.binding(() => control.inputPlaceholder);
                }
                if (item.hasOwnProperty('enabled')) {
                    item.enabled = Qt.binding(() => control.inputEnabled);
                }
                if (item.hasOwnProperty('readOnly')) {
                    item.readOnly = Qt.binding(() => control.inputReadOnly);
                }
                if (item.hasOwnProperty('readOnlyBg')) {
                    item.readOnlyBg = Qt.binding(() => control.inputReadOnlyBg);
                }
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
                if (item.hasOwnProperty('text')) {
                    item.text = Qt.binding(() => control.buttonText);
                }
                if (item.hasOwnProperty('iconSource')) {
                    item.iconSource = Qt.binding(() => control.buttonIconSource);
                }
                if (item.hasOwnProperty('enabled')) {
                    item.enabled = Qt.binding(() => control.buttonEnabled);
                }
                if (item.hasOwnProperty('type')) {
                    item.type = Qt.binding(() => control.buttonType);
                }
                if (item.hasOwnProperty('clicked') && typeof item.clicked.connect === 'function') {
                    item.clicked.connect(__openDialog);
                }
            }
        }
    }

    FileDialog {
        id: __fileDialog
        visible: false
        fileMode: (control.browserType === HusFileBrowser.Browser_File) ? FileDialog.OpenFile : FileDialog.OpenFiles
        currentFolder: (control.browserType === HusFileBrowser.Browser_File && !!control.inputText) ? Qt.resolvedUrl(__urlToUniformFile(control.inputText)) : currentFolder
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
        currentFolder: control.inputText ? Qt.resolvedUrl(__urlToUniformFile(control.inputText)) : currentFolder
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

    function __urlToUniformFile(path) {
        if (!path) {
            return path;
        }
        let pathString = (typeof path === 'string') ? path : path.toString();
        if (pathString.startsWith('file:///')) {
            return pathString;
        }
        return 'file:///' + pathString;
    }
}
