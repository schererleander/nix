import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Networking
import Quickshell.Bluetooth

Squircle {
    id: root
    cornerRadius: 16
    fillColor: Theme.surface
    Layout.fillWidth: true
    Layout.preferredHeight: 140

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 12
        spacing: 0

        Item {
            Layout.fillWidth: true
            height: 50
            scale: wifiArea.pressed ? 0.96 : 1.0
            Behavior on scale {
                NumberAnimation {
                    duration: 150
                    easing.type: Easing.OutCubic
                }
            }

            RowLayout {
                anchors.fill: parent
                spacing: 12

                IconCircle {
                    source: "network-wireless"
                    active: Networking.wifiEnabled
                    size: 32
                    Layout.alignment: Qt.AlignVCenter
                }

                ColumnLayout {
                    spacing: 0
                    Layout.alignment: Qt.AlignVCenter
                    Layout.fillWidth: true
                    Text {
                        text: "Wi-Fi"
                        color: Theme.text
                        font.pixelSize: 13
                        font.weight: Font.DemiBold
                    }
                    Text {
                        text: {
                            const vs = Networking.devices?.values || [];
                            for (const device of vs) {
                                if (device.scannerEnabled !== undefined) {
                                    const nets = device.networks?.values || [];
                                    for (const n of nets)
                                        if (n.connected)
                                            return n.name;
                                }
                            }
                            return Networking.wifiEnabled ? "On" : "Off";
                        }
                        color: Theme.textMuted
                        font.pixelSize: 12
                        font.weight: Font.Medium
                        elide: Text.ElideRight
                        Layout.maximumWidth: 80
                    }
                }
            }

            MouseArea {
                id: wifiArea
                anchors.fill: parent
                onClicked: Qt.callLater(() => GlobalState.open("Wifi"))
            }
        }

        //Item { Layout.fillHeight: true }

        Item {
            Layout.fillWidth: true
            height: 50
            scale: btArea.pressed ? 0.96 : 1.0
            Behavior on scale {
                NumberAnimation {
                    duration: 150
                    easing.type: Easing.OutCubic
                }
            }

            RowLayout {
                anchors.fill: parent
                spacing: 12

                IconCircle {
                    source: "bluetooth-active"
                    active: Bluetooth.defaultAdapter?.enabled ?? false
                    size: 32
                    Layout.alignment: Qt.AlignVCenter
                }

                ColumnLayout {
                    spacing: 0
                    Layout.alignment: Qt.AlignVCenter
                    Layout.fillWidth: true
                    Text {
                        text: "Bluetooth"
                        color: Theme.text
                        font.pixelSize: 13
                        font.weight: Font.DemiBold
                    }
                    Text {
                        text: Bluetooth.defaultAdapter?.enabled ? "On" : "Off"
                        color: Theme.textMuted
                        font.pixelSize: 12
                        font.weight: Font.Medium
                        Layout.fillWidth: true
                    }
                }
            }

            MouseArea {
                id: btArea
                anchors.fill: parent
                onClicked: Qt.callLater(() => GlobalState.open("Bluetooth"))
            }
        }
    }
}
