import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Bluetooth
import Quickshell.Widgets
import QtQuick.Effects

Item {
    id: root

    Scope {
        id: internal
        readonly property BluetoothAdapter adapter: Bluetooth.defaultAdapter

        readonly property var allDevices: adapter ? adapter.devices.values : []
        readonly property bool hasPaired: hasPairedDevice()
        readonly property bool hasNewVisible: hasNewVisibleDevice()

        function hasPairedDevice() {
            for (const d of internal.allDevices) {
                if (d?.paired)
                    return true;
            }
            return false;
        }

        function hasNewVisibleDevice() {
            for (const d of internal.allDevices) {
                if (d && !d.paired && d.name)
                    return true;
            }
            return false;
        }
    }

    width: childrenRect.width
    height: parent.height

    Row {
        anchors.verticalCenter: parent.verticalCenter
        spacing: 4

        Image {
            width: 20
            height: 20
            source: Quickshell.iconPath(internal.adapter?.enabled ? "bluetooth-active-symbolic" : "bluetooth-disabled-symbolic")
            sourceSize: Qt.size(width, height)
            smooth: true
            mipmap: true
            opacity: internal.adapter?.enabled ? 1.0 : 0.5
        }
    }

    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        onClicked: mouse => {
            if (mouse.button === Qt.LeftButton) {
                GlobalState.toggle("Bluetooth");
            } else if (mouse.button === Qt.RightButton && internal.adapter) {
                internal.adapter.enabled = !internal.adapter.enabled;
            }
        }
    }

    AnchoredPopup {
        popupName: "Bluetooth"
        anchorWindow: barWindow
        anchorItem: root
        onOpened: if (internal.adapter)
            internal.adapter.discovering = true
        onClosed: if (internal.adapter?.discovering)
            internal.adapter.discovering = false

        PopupCard {
            id: card

            RowLayout {
                Layout.fillWidth: true
                spacing: 8

                Text {
                    text: "Bluetooth"
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
                    checked: internal.adapter?.enabled ?? false
                    enabled: internal.adapter !== null
                    onToggled: internal.adapter.enabled = !internal.adapter.enabled
                }
            }

            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 1
                color: Theme.border
            }

            Text {
                visible: internal.hasPaired
                text: "My Devices"
                color: Theme.textMuted
                font {
                    family: Theme.mainFont
                    pixelSize: 12
                    weight: Font.DemiBold
                }
            }

            ColumnLayout {
                Layout.fillWidth: true
                spacing: 2
                visible: internal.hasPaired

                Repeater {
                    model: internal.adapter ? internal.adapter.devices : null

                    delegate: Squircle {
                        id: pairedItem
                        required property BluetoothDevice modelData
                        readonly property bool hovered: pairedArea.containsMouse
                        visible: pairedItem.modelData?.paired ?? false
                        Layout.fillWidth: true
                        Layout.preferredHeight: visible ? 36 : 0
                        fillColor: hovered ? Theme.surface : Theme.transparent
                        cornerRadius: 6

                        MouseArea {
                            id: pairedArea
                            anchors.fill: parent
                            hoverEnabled: true
                            onClicked: {
                                const d = pairedItem.modelData;
                                if (d.connected)
                                    d.disconnect();
                                else
                                    d.connect();
                            }
                        }

                        RowLayout {
                            anchors {
                                fill: parent
                                margins: 8
                            }
                            spacing: 10

                            Item {
                                Layout.preferredWidth: 20
                                Layout.preferredHeight: 20

                                Image {
                                    id: deviceIcon
                                    anchors.fill: parent
                                    source: Quickshell.iconPath("bluetooth-active-symbolic")
                                    sourceSize: Qt.size(20, 20)
                                    visible: false
                                }

                                MultiEffect {
                                    anchors.fill: deviceIcon
                                    source: deviceIcon
                                    colorizationColor: (pairedItem.modelData?.connected ?? false) ? Theme.accent : Theme.text
                                    colorization: 1.0
                                }
                            }

                            Text {
                                Layout.fillWidth: true
                                text: pairedItem.modelData?.name || pairedItem.modelData?.deviceName || pairedItem.modelData?.address || ""
                                color: Theme.text
                                font {
                                    family: Theme.mainFont
                                    pixelSize: 13
                                }
                                elide: Text.ElideRight
                            }

                            Text {
                                text: (pairedItem.modelData?.connected ?? false) ? "Connected" : "Not Connected"
                                color: Theme.textMuted
                                font {
                                    family: Theme.mainFont
                                    pixelSize: 11
                                }
                            }
                        }
                    }
                }
            }

            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 1
                color: Theme.border
                visible: internal.hasPaired
            }

            RowLayout {
                Layout.fillWidth: true

                Text {
                    text: "Other Devices"
                    color: Theme.textMuted
                    font {
                        family: Theme.mainFont
                        pixelSize: 12
                        weight: Font.DemiBold
                    }
                    Layout.fillWidth: true
                }

                Image {
                    width: 14
                    height: 14
                    source: Quickshell.iconPath("process-working-symbolic")
                    sourceSize: Qt.size(width, height)
                    smooth: true
                    mipmap: true
                    visible: internal.adapter?.discovering ?? false
                    opacity: 0.6

                    RotationAnimation on rotation {
                        running: parent.visible
                        from: 0
                        to: 360
                        duration: 1000
                        loops: Animation.Infinite
                    }
                }
            }

            ColumnLayout {
                Layout.fillWidth: true
                spacing: 2
                visible: internal.hasNewVisible

                Repeater {
                    model: internal.adapter ? internal.adapter.devices : null

                    delegate: Squircle {
                        id: newItem
                        required property BluetoothDevice modelData
                        visible: !(newItem.modelData?.paired ?? true) && (newItem.modelData?.name ?? "") !== ""
                        Layout.fillWidth: true
                        Layout.preferredHeight: visible ? 36 : 0
                        fillColor: newArea.containsMouse ? Theme.surface : Theme.transparent
                        cornerRadius: 6

                        MouseArea {
                            id: newArea
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            enabled: !(newItem.modelData?.pairing ?? false)
                            onClicked: newItem.modelData.pair()
                        }

                        RowLayout {
                            anchors {
                                fill: parent
                                margins: 8
                            }
                            spacing: 10

                            Image {
                                Layout.preferredWidth: 20
                                Layout.preferredHeight: 20
                                source: Quickshell.iconPath("bluetooth-active-symbolic")
                                sourceSize: Qt.size(20, 20)
                                opacity: 0.6
                            }

                            Text {
                                Layout.fillWidth: true
                                text: newItem.modelData?.name || newItem.modelData?.address || ""
                                color: Theme.text
                                font {
                                    family: Theme.mainFont
                                    pixelSize: 13
                                }
                                elide: Text.ElideRight
                            }

                            Text {
                                visible: newItem.modelData?.pairing ?? false
                                text: "Connecting..."
                                color: Theme.textMuted
                                font {
                                    family: Theme.mainFont
                                    pixelSize: 11
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
