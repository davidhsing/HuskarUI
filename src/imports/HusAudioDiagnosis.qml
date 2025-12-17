import QtQuick
import QtMultimedia
import Qt.labs.platform
import HuskarUI.Basic

Item {
    id: control

    property string deviceId: ''
    property bool active: true
    property bool fallbackDefault: false
    property bool autoStart: false
    readonly property alias recording: __private.audioRecording
    property bool buttonVisible: true
    property alias buttonType: controlButton.type
    property alias buttonWidth: controlButton.width
    property int buttonMargin: 8
    property string startText: qsTr('开始')
    property string endText: qsTr('停止')
    property var iconSource: HusIcon.AudioOutlined
    property var iconSourceMuted: HusIcon.AudioMutedOutlined
    property int iconSize: 60
    property int probeInterval: 50
    property int progressWidth: 160
    property int progressHeight: 160
    property int progressGap: 100
    property bool progressGradient: true
    property real progressThickness: 10
    property var locationCallback: () => {
        return generateAudioLocation();
    }
    property color colorBar: HusTheme.HusAudioDiagnosis.colorBar
    property color colorTrack: HusTheme.HusAudioDiagnosis.colorTrack
    property color colorIconRecording: HusTheme.HusAudioDiagnosis.colorIconRecording
    property color colorIconStopped: HusTheme.HusAudioDiagnosis.colorIconStopped
    property color colorIconMuted: HusTheme.HusAudioDiagnosis.colorIconMuted

    objectName: '__HusAudioDiagnosis__'
    implicitWidth: 200
    implicitHeight: 200

    Component.onCompleted: {
        Qt.callLater(() => {
            __private.validateDevice();
            if (control.active && control.autoStart && __private.audioDevice) {
                mediaRecorder.record();
            }
        });
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
    }

    Binding {
        target: audioInput
        property: 'device'
        value: __private.audioDevice
        when: !!__private.audioDevice
    }

    MediaRecorder {
        id: mediaRecorder
        outputLocation: __private.audioLocation
        onRecorderStateChanged: {
            __private.audioRecording = (recorderState === MediaRecorder.RecordingState);
            if (!__private.audioRecording) {
                volumeProgress.percent = 0;
            }
        }
    }

    // 音频探针
    HusAudioProbe {
        id: audioProbe
        deviceId: control.deviceId
        active: control.active && __private.audioRecording
        interval: control.probeInterval
        fallbackDefault: control.fallbackDefault
        onLevelChanged: {
            if (__private.audioRecording) {
                volumeProgress.percent = level * 100;
            }
        }
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
    }

    // 麦克风图标
    HusIconText {
        id: micIcon
        anchors.centerIn: parent
        iconSource: !__private.audioDevice ? control.iconSourceMuted : control.iconSource
        iconSize: control.iconSize
        color: !__private.audioDevice ? control.colorIconMuted : (__private.audioRecording ? control.colorIconRecording : control.colorIconStopped)

        Behavior on color {
            ColorAnimation { duration: 200 }
        }
    }

    // 开始/停止按钮
    HusButton {
        id: controlButton
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: control.buttonMargin
        enabled: !!__private.audioDevice
        visible: control.buttonVisible
        text: __private.audioRecording ? control.endText : control.startText
        onClicked: {
            if (__private.audioRecording) {
                mediaRecorder.stop();
            } else {
                __private.audioLocation = control.locationCallback();
                mediaRecorder.record();
            }
        }
    }

    onDeviceIdChanged: __private.validateDevice()
    onFallbackDefaultChanged: __private.validateDevice()

    function generateAudioLocation() {
        return StandardPaths.writableLocation(StandardPaths.TempLocation) + '/HusAudioDiagnosis_' + new Date().getTime() + '.m4a';
    }

    QtObject {
        id: __private
        property string audioLocation: control.locationCallback()
        property var audioDevice: null
        property bool audioRecording: false

        function findAudioDevice() {
            const devices = mediaDevices.audioInputs;
            if (control.deviceId) {
                for (let i = 0; i < devices.length; i++) {
                    const id = devices[i].id;
                    const idString = id ? (typeof id === 'string' ? id : id.toString()) : ('AudioInput-' + (i + 1));
                    if (idString === control.deviceId) {
                        return devices[i];
                    }
                }
            }
            if (control.fallbackDefault && devices.length > 0) {
                return devices[0];    // Default device
            }
        }

        function validateDevice() {
            __private.audioDevice = findAudioDevice();
            if (!__private.audioDevice) {
                mediaRecorder.stop();
            }
        }
    }
}
