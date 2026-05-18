import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.Mpris

Item {
    id: root

    property QtObject manualExpandedPlayer: null

    readonly property var activePlayers: Mpris.players?.values || []

    readonly property var expandedPlayer: {
        if (root.manualExpandedPlayer !== null && root.activePlayers.includes(root.manualExpandedPlayer)) {
            return root.manualExpandedPlayer;
        }
        for (const player of root.activePlayers) {
            if (player.playbackState === MprisPlaybackState.Playing) {
                return player;
            }
        }
        if (root.activePlayers.length > 0) {
            return root.activePlayers[0];
        }
        return null;
    }

    width: childrenRect.width
    height: parent.height

    Row {
        anchors.verticalCenter: parent.verticalCenter

        MusicVisualizer {
            active: root.expandedPlayer?.playbackState === MprisPlaybackState.Playing
            anchors.verticalCenter: parent.verticalCenter
        }
    }

    MouseArea {
        anchors.fill: parent
        onClicked: GlobalState.toggle("Media")
    }

    PopupWindow {
        id: popup
        visible: GlobalState.activePopup === "Media"
        grabFocus: true
        implicitWidth: card.width
        implicitHeight: card.height

        anchor {
            window: barWindow
            item: root
            edges: Edges.Bottom
            gravity: Edges.Bottom
            margins.top: Theme.popupGap
        }

        color: Theme.transparent

        PopupCard {
            id: card
            width: 320

            ColumnLayout {
                Layout.fillWidth: true
                spacing: 0
                Layout.margins: 8

                Repeater {
                    model: root.activePlayers.length > 0 ? root.activePlayers : [null]

                    delegate: Item {
                        id: playerDelegate
                        Layout.fillWidth: true
                        implicitHeight: mediaCard.implicitHeight + (separator.visible ? separator.height + 16 : 0)

                        required property var modelData
                        required property int index

                        readonly property bool isEmpty: modelData === null
                        readonly property bool isExpanded: root.expandedPlayer === modelData && !isEmpty

                        ColumnLayout {
                            anchors.fill: parent
                            spacing: 16

                            MediaCard {
                                id: mediaCard
                                Layout.fillWidth: true
                                player: playerDelegate.modelData
                                isExpanded: playerDelegate.isExpanded

                                onClicked: {
                                    if (!playerDelegate.isEmpty) {
                                        root.manualExpandedPlayer = playerDelegate.modelData;
                                    } else {
                                        Quickshell.execDetached(["spotify"]);
                                    }
                                }
                            }

                            Rectangle {
                                id: separator
                                Layout.fillWidth: true
                                height: 1
                                color: Theme.border
                                opacity: 0.3
                                visible: !playerDelegate.isEmpty && playerDelegate.index < root.activePlayers.length - 1
                                Layout.topMargin: 4
                            }
                        }
                    }
                }
            }
        }
    }
}
