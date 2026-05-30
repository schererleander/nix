import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Networking
import Quickshell.Bluetooth
import Quickshell.Services.Pipewire
import Quickshell.Services.Mpris

Item {
    id: root
    width: childrenRect.width
    height: parent.height

    BrightnessService {
        id: brightnessService
    }

    MouseArea {
        anchors.fill: parent
        onClicked: GlobalState.toggle("ControlCenter")
    }

    Row {
        anchors.verticalCenter: parent.verticalCenter
        spacing: 4
        Image {
            width: 20
            height: 20
            source: Quickshell.iconPath("emblem-system-symbolic")
            sourceSize: Qt.size(width, height)
            smooth: true
            mipmap: true
        }
    }

    AnchoredPopup {
        popupName: "ControlCenter"
        anchorWindow: barWindow
        anchorItem: root

        PopupCard {
            id: card
            width: 320
            margins: 16

            RowLayout {
                Layout.fillWidth: true
                spacing: 12

                ConnectivityBox {
                    Layout.fillWidth: true
                }

                ColumnLayout {
                    spacing: 12
                    ControlTile {
                        label: "Do Not Disturb"
                        icon: "notifications"
                    }
                    ControlTile {
                        icon: "network-wireless"
                    }
                }
            }

            SliderBox {
                label: "Display"
                icon: "display-brightness"
                value: brightnessService.brightness
                onMoved: val => brightnessService.setBrightness(val)
            }

            SliderBox {
                label: "Sound"
                icon: "audio-volume-high"
                value: Pipewire.defaultAudioSink?.audio?.volume ?? 0
                clickable: true
                onClicked: Qt.callLater(() => GlobalState.open("Volume"))
                onMoved: val => {
                    const sink = Pipewire.defaultAudioSink;
                    if (sink?.audio) {
                        sink.audio.muted = false;
                        sink.audio.volume = val;
                    }
                }
            }

            Squircle {
                Layout.fillWidth: true
                height: 64
                cornerRadius: 16
                fillColor: hoverArea.containsMouse ? Theme.surfaceHover : Theme.surface
                visible: (Mpris.players?.values?.length ?? 0) > 0

                MouseArea {
                    id: hoverArea
                    anchors.fill: parent
                    hoverEnabled: true
                    acceptedButtons: Qt.NoButton
                }

                MediaCard {
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.leftMargin: 12
                    anchors.rightMargin: 12

                    isExpanded: false

                    readonly property var activePlayer: {
                        const ps = Mpris.players?.values || [];
                        for (const p of ps)
                            if (p.playbackState === MprisPlaybackState.Playing)
                                return p;
                        return ps[0] ?? null;
                    }

                    player: activePlayer

                    onClicked: Qt.callLater(() => GlobalState.open("Media"))
                }
            }
        }
    }
}
