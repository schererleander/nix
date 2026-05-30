import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.Pipewire

Item {
    id: root
    width: indicator.visible ? indicator.width : 0
    height: parent.height
    visible: root.micInUse

    readonly property PwNode source: Pipewire.defaultAudioSource
    readonly property bool muted: source && source.audio ? source.audio.muted : true
    readonly property real volume: source && source.audio ? source.audio.volume : 0
    readonly property bool micInUse: {
        const nodes = Pipewire.nodes?.values || [];
        for (const node of nodes) {
            if (node && (node.type & PwNodeType.AudioInStream))
                return true;
        }
        return false;
    }

    onMicInUseChanged: {
        if (!micInUse && GlobalState.activePopup === "MicInput")
            GlobalState.close();
    }

    PwObjectTracker {
        objects: root.source ? [root.source] : []
    }

    function setVolume(value) {
        if (source?.ready && source?.audio) {
            source.audio.muted = false;
            source.audio.volume = value;
        }
    }

    function toggleMute() {
        if (source?.ready && source?.audio) {
            source.audio.muted = !source.audio.muted;
        }
    }

    function getDeviceIcon(node) {
        return node?.properties?.["device.icon-name"] ?? "audio-input-microphone";
    }

    Squircle {
        id: indicator
        anchors.verticalCenter: parent.verticalCenter
        width: 28
        height: 22
        cornerRadius: 8
        fillColor: "#FFFF9500"

        Image {
            anchors.centerIn: parent
            width: 16
            height: 16
            source: Quickshell.iconPath(root.muted ? "microphone-sensitivity-muted-symbolic" : "audio-input-microphone-symbolic")
            sourceSize: Qt.size(width, height)
            smooth: true
            mipmap: true
        }
    }

    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        cursorShape: Qt.PointingHandCursor
        onClicked: mouse => {
            if (mouse.button === Qt.RightButton)
                root.toggleMute();
            else
                GlobalState.toggle("MicInput");
        }
        onWheel: wheel => {
            const step = 0.05;
            const next = wheel.angleDelta.y > 0 ? root.volume + step : root.volume - step;
            root.setVolume(Math.max(0.0, Math.min(1.0, next)));
        }
    }

    AnchoredPopup {
        popupName: "MicInput"
        anchorWindow: barWindow
        anchorItem: root

        PopupCard {
            width: 280
            margins: 14

            RowLayout {
                Layout.fillWidth: true
                spacing: 8

                Text {
                    text: "Microphone"
                    color: Theme.text
                    font {
                        family: Theme.mainFont
                        pixelSize: 14
                        weight: Font.DemiBold
                    }
                }

                Item {
                    Layout.fillWidth: true
                }

                Toggle {
                    checked: !root.muted
                    enabled: root.source !== null
                    onToggled: root.toggleMute()
                }
            }

            PillSlider {
                id: micSlider
                Layout.fillWidth: true
                icon: "audio-input-microphone-symbolic"
                value: root.volume
                enabled: root.source !== null
                colorProgress: "#FFFF9500"
                onMoved: root.setVolume(value)

                Binding {
                    target: micSlider
                    property: "value"
                    value: root.volume
                    when: !micSlider.pressed
                }
            }

            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 1
                color: Theme.border
            }

            Text {
                text: "Input Devices"
                color: Theme.textMuted
                font {
                    family: Theme.mainFont
                    pixelSize: 12
                    weight: Font.DemiBold
                }
                Layout.leftMargin: 4
            }

            Repeater {
                model: Pipewire.nodes

                delegate: Squircle {
                    id: inputItem
                    required property var modelData
                    readonly property bool isInput: modelData && (modelData.type & PwNodeType.AudioSource) && !modelData.isStream && modelData.name !== "Dummy-Driver"

                    visible: isInput
                    Layout.fillWidth: true
                    Layout.preferredHeight: visible ? 40 : 0
                    cornerRadius: 6
                    fillColor: inputArea.containsMouse ? Theme.surfaceLighter : Theme.transparent

                    RowLayout {
                        anchors {
                            fill: parent
                            margins: 8
                        }
                        spacing: 12

                        IconCircle {
                            size: 24
                            source: root.getDeviceIcon(inputItem.modelData)
                            active: root.source && root.source.id === inputItem.modelData.id
                        }

                        Text {
                            Layout.fillWidth: true
                            text: inputItem.modelData.description || inputItem.modelData.nickname || inputItem.modelData.name
                            color: (root.source && root.source.id === inputItem.modelData.id) ? Theme.text : Theme.textDim
                            elide: Text.ElideRight
                            font {
                                family: Theme.mainFont
                                pixelSize: 13
                            }
                        }
                    }

                    MouseArea {
                        id: inputArea
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: Pipewire.preferredDefaultAudioSource = inputItem.modelData
                    }
                }
            }
        }
    }
}
