import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Services.Pipewire

Item {
    id: root
    width: childrenRect.width
    height: parent.height

    // Properties bound directly to the Pipewire service
    readonly property PwNode sink: Pipewire.defaultAudioSink
    readonly property bool muted: sink && sink.audio ? sink.audio.muted : true
    readonly property real volume: sink && sink.audio ? sink.audio.volume : 0

    // Pipewire nodes only emit property updates while tracked.
    PwObjectTracker {
        objects: root.sink ? [root.sink] : []
    }

    function setVolume(value) {
        if (sink?.ready && sink?.audio) {
            sink.audio.muted = false;
            sink.audio.volume = value;
        } else {
            // Fallback for unbound nodes
            Quickshell.execDetached(["wpctl", "set-volume", "@DEFAULT_AUDIO_SINK@", value.toFixed(2)]);
        }
    }

    function toggleMute() {
        if (sink?.ready && sink?.audio) {
            sink.audio.muted = !sink.audio.muted;
        } else {
            Quickshell.execDetached(["wpctl", "set-mute", "@DEFAULT_AUDIO_SINK@", "toggle"]);
        }
    }

    function getDeviceIcon(node) {
        return node?.properties?.["device.icon-name"] ?? "audio-card"
    }

    Row {
        id: triggerRow
        anchors {
            verticalCenter: parent.verticalCenter
        }
        spacing: 4

        Image {
            width: 20
            height: 20
            source: Quickshell.iconPath(root.getDeviceIcon(root.sink) + "-symbolic")
            sourceSize: Qt.size(width, height)
            smooth: true
            mipmap: true
            opacity: root.muted ? 0.5 : 1.0
        }
    }

    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        onClicked: mouse => {
            if (mouse.button === Qt.LeftButton) {
                GlobalState.toggle("Volume")
            } else if (mouse.button === Qt.RightButton) {
                root.toggleMute()
            }
        }
        onWheel: wheel => {
            const step = 0.05
            const next = wheel.angleDelta.y > 0 ? root.volume + step : root.volume - step
            root.setVolume(Math.max(0.0, Math.min(1.0, next)))
        }
    }

    PopupWindow {
        id: popup
        visible: GlobalState.activePopup === "Volume"
        grabFocus: true
        implicitWidth: bgRect.width
        implicitHeight: bgRect.height
        
        anchor {
            window: barWindow
            item: root
            edges: Edges.Bottom
            gravity: Edges.Bottom
            margins.top: Theme.popupGap
        }
        
        color: "transparent"
        
        onVisibleChanged: {
            if (visible) anchor.updateAnchor()
        }
        
        Squircle {
            id: bgRect
            width: 260
            height: contentCol.height + 24
            fillColor: Theme.bg
            strokeColor: Theme.border
            strokeWidth: 1
            cornerRadius: 8

            Column {
                id: contentCol
                anchors {
                    top: parent.top
                    left: parent.left
                    right: parent.right
                    margins: 12
                }
                spacing: 12

                Text {
                    text: "Sound"
                    color: Theme.text
                    font {
                        family: Theme.mainFont
                        pixelSize: 14
                        weight: Font.DemiBold
                    }
                }

                PillSlider {
                    id: volumeSlider
                    width: parent.width
                    value: root.volume
                    onMoved: root.setVolume(value)

                    Binding {
                        target: volumeSlider
                        property: "value"
                        value: root.volume
                        when: !volumeSlider.pressed
                    }
                }

                Rectangle { width: parent.width; height: 1; color: Theme.border }

                Text {
                    text: "Output Devices"
                    color: Theme.textMuted
                    font {
                        family: Theme.mainFont
                        pixelSize: 12
                        weight: Font.DemiBold
                    }
                    padding: 4
                }

                Repeater {
                    model: Pipewire.nodes
                    delegate: Item {
                        width: parent.width
                        property bool isOutput: modelData && modelData.isSink && !modelData.isStream && modelData.name !== "Dummy-Driver"
                        visible: isOutput
                        height: isOutput ? 40 : 0
                        
                        Squircle {
                            anchors.fill: parent
                            fillColor: mouseArea.containsMouse ? Theme.surfaceLighter : Theme.transparent
                            cornerRadius: 6
                            
                            RowLayout {
                                anchors.fill: parent
                                anchors.margins: 8
                                spacing: 12
                                
                                IconCircle {
                                    size: 24
                                    source: root.getDeviceIcon(modelData)
                                    active: root.sink && root.sink.id === modelData.id
                                }
                                
                                Text {
                                    Layout.fillWidth: true
                                    text: modelData.description || modelData.nickname || modelData.name
                                    color: (root.sink && root.sink.id === modelData.id) ? Theme.text : Theme.textDim
                                    font {
                                        family: Theme.mainFont
                                        pixelSize: 13
                                    }
                                    elide: Text.ElideRight
                                }
                            }
                            
                            MouseArea {
                                id: mouseArea
                                anchors.fill: parent
                                hoverEnabled: true
                                onClicked: {
                                    Quickshell.execDetached(["wpctl", "set-default", modelData.id.toString()])
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
