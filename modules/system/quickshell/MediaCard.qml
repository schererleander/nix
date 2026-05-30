import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.Mpris

Item {
    id: root

    property QtObject player: null
    property bool isExpanded: false
    signal clicked

    Layout.fillWidth: true
    implicitHeight: layout.implicitHeight

    Behavior on implicitHeight {
        NumberAnimation {
            duration: 200
            easing.type: Easing.OutCubic
        }
    }

    MouseArea {
        anchors.fill: parent
        enabled: !root.isExpanded
        onClicked: root.clicked()
    }

    function formatTime(s) {
        const mins = Math.floor(s / 60);
        const secs = Math.floor(s % 60);
        return `${mins}:${secs.toString().padStart(2, '0')}`;
    }

    ColumnLayout {
        id: layout
        anchors.left: parent.left
        anchors.right: parent.right
        spacing: 16

        RowLayout {
            Layout.fillWidth: true
            spacing: 12

            Squircle {
                width: root.isExpanded ? 56 : 40
                height: root.isExpanded ? 56 : 40
                cornerRadius: root.isExpanded ? 10 : 8
                fillColor: root.player ? Theme.transparent : Theme.surface
                clip: true

                Behavior on width {
                    NumberAnimation {
                        duration: 200
                    }
                }
                Behavior on height {
                    NumberAnimation {
                        duration: 200
                    }
                }
                Behavior on cornerRadius {
                    NumberAnimation {
                        duration: 200
                    }
                }

                Image {
                    anchors.fill: parent
                    source: root.player?.trackArtUrl || ""
                    fillMode: Image.PreserveAspectCrop
                    visible: status === Image.Ready && root.player !== null
                }

                IconCircle {
                    anchors.centerIn: parent
                    size: root.isExpanded ? 28 : 20
                    source: "audio-x-generic-symbolic"
                    visible: !root.player?.trackArtUrl || parent.children[0].status !== Image.Ready || root.player === null
                }
            }

            ColumnLayout {
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignVCenter
                spacing: 2

                Text {
                    Layout.fillWidth: true
                    text: root.player?.trackTitle || "Music"
                    color: root.player ? Theme.text : Theme.textDisabled
                    font.pixelSize: 13
                    font.weight: Font.DemiBold
                    elide: Text.ElideRight
                }

                Text {
                    Layout.fillWidth: true
                    text: root.player?.trackArtist || ""
                    visible: text !== "" && root.player !== null
                    color: Theme.textDim
                    font.pixelSize: 12
                    font.weight: Font.Medium
                    elide: Text.ElideRight
                }

                Text {
                    Layout.fillWidth: true
                    text: root.player?.trackAlbum || ""
                    visible: root.isExpanded && text !== "" && root.player !== null
                    color: Theme.textDisabled
                    font.pixelSize: 11
                    font.weight: Font.Normal
                    elide: Text.ElideRight
                }
            }

            Row {
                visible: !root.isExpanded
                spacing: 12
                Layout.alignment: Qt.AlignVCenter

                Item {
                    width: 24
                    height: 24
                    Image {
                        anchors.centerIn: parent
                        source: Quickshell.iconPath(root.player?.playbackState === MprisPlaybackState.Playing ? "media-playback-pause-symbolic" : "media-playback-start-symbolic")
                        sourceSize: Qt.size(24, 24)
                        opacity: root.player?.canTogglePlaying ? (minPlayMouse.pressed ? 0.7 : 1.0) : 0.3
                    }
                    MouseArea {
                        id: minPlayMouse
                        anchors.fill: parent
                        enabled: root.player?.canTogglePlaying ?? false
                        onClicked: if (root.player)
                            root.player.togglePlaying()
                    }
                }

                Item {
                    width: 24
                    height: 24
                    Image {
                        anchors.centerIn: parent
                        source: Quickshell.iconPath("media-skip-forward-symbolic")
                        sourceSize: Qt.size(20, 20)
                        opacity: root.player?.canGoNext ? (minNextMouse.pressed ? 0.5 : 0.8) : 0.3
                    }
                    MouseArea {
                        id: minNextMouse
                        anchors.fill: parent
                        enabled: root.player?.canGoNext ?? false
                        onClicked: if (root.player)
                            root.player.next()
                    }
                }
            }
        }

        ColumnLayout {
            visible: root.isExpanded && root.player !== null
            Layout.fillWidth: true
            spacing: 8

            ColumnLayout {
                Layout.fillWidth: true
                spacing: 2

                ThinSlider {
                    id: progressSlider
                    Layout.fillWidth: true
                    from: 0
                    to: root.player?.length || 1
                    value: root.player?.position || 0
                    enabled: root.player?.canSeek ?? false

                    onMoved: if (root.player)
                        root.player.position = value

                    Timer {
                        running: root.player?.playbackState === MprisPlaybackState.Playing && root.isExpanded
                        interval: 500
                        repeat: true
                        onTriggered: progressSlider.value = root.player.position
                    }
                }

                RowLayout {
                    Layout.fillWidth: true
                    Text {
                        text: root.formatTime(root.player?.position || 0)
                        color: Theme.textPlaceholder
                        font.pixelSize: 9
                        font.weight: Font.Medium
                    }
                    Item {
                        Layout.fillWidth: true
                    }
                    Text {
                        text: root.formatTime(root.player?.length || 0)
                        color: Theme.textPlaceholder
                        font.pixelSize: 9
                        font.weight: Font.Medium
                    }
                }
            }

            RowLayout {
                Layout.alignment: Qt.AlignHCenter
                spacing: 32

                Item {
                    width: 24
                    height: 24
                    Image {
                        anchors.centerIn: parent
                        source: Quickshell.iconPath("media-skip-backward-symbolic")
                        sourceSize: Qt.size(20, 20)
                        opacity: root.player?.canGoPrevious ? (prevMouse.pressed ? 0.5 : 0.8) : 0.3
                    }
                    MouseArea {
                        id: prevMouse
                        anchors.fill: parent
                        enabled: root.player?.canGoPrevious ?? false
                        onClicked: if (root.player)
                            root.player.previous()
                    }
                }

                Item {
                    width: 32
                    height: 32
                    Image {
                        anchors.centerIn: parent
                        source: Quickshell.iconPath(root.player?.playbackState === MprisPlaybackState.Playing ? "media-playback-pause-symbolic" : "media-playback-start-symbolic")
                        sourceSize: Qt.size(28, 28)
                        opacity: root.player?.canTogglePlaying ? (maxPlayMouse.pressed ? 0.7 : 1.0) : 0.3
                    }
                    MouseArea {
                        id: maxPlayMouse
                        anchors.fill: parent
                        enabled: root.player?.canTogglePlaying ?? false
                        onClicked: if (root.player)
                            root.player.togglePlaying()
                    }
                }

                Item {
                    width: 24
                    height: 24
                    Image {
                        anchors.centerIn: parent
                        source: Quickshell.iconPath("media-skip-forward-symbolic")
                        sourceSize: Qt.size(20, 20)
                        opacity: root.player?.canGoNext ? (maxNextMouse.pressed ? 0.5 : 0.8) : 0.3
                    }
                    MouseArea {
                        id: maxNextMouse
                        anchors.fill: parent
                        enabled: root.player?.canGoNext ?? false
                        onClicked: if (root.player)
                            root.player.next()
                    }
                }
            }
        }
    }
}
