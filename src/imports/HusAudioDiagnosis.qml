import QtQuick
import QtMultimedia
import Qt.labs.platform
import HuskarUI.Basic

Item {
    id: control

    property string deviceId: ''
    property bool autoRecord: true
    property bool fallbackDefault: false
    readonly property alias recording: __private.audioRecording
    property bool buttonVisible: true
    property alias buttonType: controlButton.type
    property string startText: qsTr('开始')
    property string endText: qsTr('停止')
    property string warnText: qsTr('设备不存在')
    property int interval: 50
    property var iconSource: HusIcon.IcoMoonMic
    property int iconSize: 56
    property int progressWidth: 160
    property int progressHeight: 160
    property int progressGap: 90
    property bool progressGradient: true
    property real progressThickness: 12
    property var locationCallback: () => {
        return StandardPaths.writableLocation(StandardPaths.TempLocation) + '/HusAudioDiagnosis_' + new Date().getTime() + '.m4a';
    }
    property color colorBar: HusTheme.HusAudioDiagnosis.colorBar
    property color colorTrack: HusTheme.HusAudioDiagnosis.colorTrack
    property color colorWarningText: HusTheme.HusAudioDiagnosis.colorWarnText
    property color colorIconRecording: HusTheme.HusAudioDiagnosis.colorIconRecording
    property color colorIconStopped: HusTheme.HusAudioDiagnosis.colorIconStopped

    objectName: '__HusAudioDiagnosis__'
    implicitWidth: 200
    implicitHeight: 240

    Component.onCompleted: {
        if (!control.autoRecord) {
            return;
        }
        __private.validateDevice();
        if (__private.deviceValid) {
            mediaRecorder.record();
        }
    }

    // 监听音频设备变化
    MediaDevices {
        id: mediaDevices
        onAudioInputsChanged: {
            __private.validateDevice();
        }
    }

    CaptureSession {
        id: captureSession
        audioInput: audioInput
        recorder: mediaRecorder
    }

    AudioInput {
        id: audioInput
        device: __private.findAudioDevice()
    }

    MediaRecorder {
        id: mediaRecorder
        outputLocation: __private.audioLocation
        onRecorderStateChanged: {
            __private.audioRecording = recorderState === MediaRecorder.RecordingState;
            if (!__private.audioRecording) {
                volumeProgress.percent = 0;
            }
        }
    }

    // 音频探针
    HusAudioProbe {
        id: audioProbe
        deviceId: control.deviceId
        active: __private.audioRecording
        interval: control.interval
        fallbackDefault: control.fallbackDefault
        onLevelChanged: {
            if (__private.audioRecording) {
                volumeProgress.percent = level * 100;
            }
        }
    }

    // 警告文本
    HusText {
        id: warningText
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.bottomMargin: 10
        text: control.warnText
        color: control.colorWarningText
        visible: !__private.deviceValid
    }

    // 圆形进度条
    HusProgress {
        id: volumeProgress
        anchors.centerIn: parent
        width: control.progressWidth
        height: control.progressHeight
        type: HusProgress.Type_Dashboard
        colorBar: control.colorBar
        colorTrack: control.colorTrack
        barThickness: control.progressThickness
        gapDegree: control.progressGap
        useGradient: control.progressGradient
        showInfo: false
        opacity: __private.deviceValid ? 1.0 : 0.5
    }

    // 麦克风图标
    HusIconText {
        id: micIcon
        anchors.centerIn: parent
        iconSource: control.iconSource
        iconSize: control.iconSize
        color: __private.audioRecording ? control.colorIconRecording : control.colorIconStopped
        opacity: __private.deviceValid ? 1.0 : 0.5

        Behavior on color {
            ColorAnimation { duration: 200 }
        }
    }

    // 开始/停止按钮
    HusButton {
        id: controlButton
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.topMargin: 10
        enabled: __private.deviceValid
        visible: control.buttonVisible
        text: __private.audioRecording ? control.endText : control.startText
        onClicked: {
            if (__private.audioRecording) {
                mediaRecorder.stop();
            } else {
                __private.audioLocation = control.locationCallback()
                mediaRecorder.record();
            }
        }
    }

    onDeviceIdChanged: __private.validateDevice()
    onFallbackDefaultChanged: __private.validateDevice()

    QtObject {
        id: __private
        property string audioLocation: control.locationCallback()
        property bool audioRecording: false
        property bool deviceValid: false

        function findAudioDevice() {
            const devices = mediaDevices.audioInputs;
            if (control.deviceId !== '') {
                for (let i = 0; i < devices.length; i++) {
                    if (devices[i].id === control.deviceId) {
                        return devices[i];
                    }
                }
            }
            if (control.fallbackDefault && devices.length > 0) {
                return devices[0];    // Default device
            }
        }

        function validateDevice() {
            const device = findAudioDevice(control.deviceId);
            __private.deviceValid = !!device;
            if (!__private.deviceValid && __private.audioRecording) {
                mediaRecorder.stop();
            }
        }
    }
}
