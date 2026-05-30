import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.Pipewire
import Quickshell.Wayland

Scope {
    id: root

    readonly property PwNode sink: Pipewire.defaultAudioSink
    property bool visible: false

    PwObjectTracker {
        objects: root.sink ? [root.sink] : []
    }

    Connections {
        target: root.sink && root.sink.audio ? root.sink.audio : null
        ignoreUnknownSignals: true

        function onVolumeChanged() {
            root.visible = true;
            hideTimer.restart();
        }
        function onMutedChanged() {
            root.visible = true;
            hideTimer.restart();
        }
    }

    Timer {
        id: hideTimer
        interval: 2000
        onTriggered: root.visible = false
    }

    PanelWindow {
        visible: root.visible

        anchors.bottom: true
        margins.bottom: 100
        exclusiveZone: 0

        implicitWidth: 240
        implicitHeight: 64

        WlrLayershell.layer: WlrLayer.Overlay
        exclusionMode: ExclusionMode.Ignore
        color: Theme.transparent
        mask: Region {}

        Squircle {
            id: card
            anchors.fill: parent
            fillColor: Theme.bg
            strokeColor: Theme.border
            strokeWidth: 1
            cornerRadius: 16

            RowLayout {
                anchors {
                    fill: parent
                    margins: 16
                }
                spacing: 12

                IconCircle {
                    size: 32
                    source: {
                        if (root.sink?.audio?.muted)
                            return "audio-volume-muted";
                        const vol = root.sink?.audio?.volume ?? 0;
                        if (vol <= 0)
                            return "audio-volume-low";
                        if (vol <= 0.33)
                            return "audio-volume-low";
                        if (vol <= 0.66)
                            return "audio-volume-medium";
                        return "audio-volume-high";
                    }
                    active: !(root.sink?.audio?.muted ?? true)
                }

                PillSlider {
                    Layout.fillWidth: true
                    value: root.sink?.audio?.volume ?? 0
                    enabled: false
                }
            }
        }
    }
}
